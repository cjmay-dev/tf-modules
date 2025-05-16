resource "b2_bucket" "backups" {
  bucket_name = "${var.ORG_SHORTNAME}-${var.APP_SHORTNAME}-backup-${var.ENV_SLUG}"
  bucket_type = "allPrivate"

  ### RANSOMWARE PROTECTION CONFIG -- see: https://medium.com/@benjamin.ritter/how-to-do-ransomware-resistant-backups-properly-with-restic-and-backblaze-b2-e649e676b7fa
  # customer managed keys introduce risk of losing backup keys during ransomware event
  default_server_side_encryption {
    algorithm = "AES256"
    mode      = "SSE-B2"  
  }
  # explicitly disable file lock because it breaks restic blob chunking
  file_lock_configuration {
    is_file_lock_enabled = false
  }
  # deleted files and old versions will be temporarily hidden -- enforces immutability on client side
  lifecycle_rules {
    file_name_prefix             = "config"
    days_from_hiding_to_deleting = 90  
  }
  lifecycle_rules {
    file_name_prefix             = "data/"
    days_from_hiding_to_deleting = 90  
  }
  lifecycle_rules {
    file_name_prefix             = "index/"
    days_from_hiding_to_deleting = 90  
  }
  lifecycle_rules {
    file_name_prefix             = "keys/"
    days_from_hiding_to_deleting = 90  
  }
  lifecycle_rules {
    file_name_prefix             = "snapshots/"
    days_from_hiding_to_deleting = 90  
  }
  # remove old locks without relying on client to do so
  lifecycle_rules {
    file_name_prefix              = "locks/"
    days_from_uploading_to_hiding = 1
    days_from_hiding_to_deleting  = 1  
  }
}

resource "b2_application_key" "backups_key" {
  key_name     = b2_bucket.backups.bucket_name
  capabilities = [  # CRITICAL NOTE: do not grant deleteFiles so client can't fully delete backups
    "listAllBucketNames",
    "listBuckets",
    "readBuckets",
    "readBucketEncryption",
    "readBucketLogging",
    "readBucketNotifications",
    "readBucketReplications",
    "readBucketRetentions",
    "listFiles",
    "readFiles",
    "readFileLegalHolds",
    "readFileRetentions",
    "writeFiles"
  ]
  bucket_id    = b2_bucket.backups.bucket_id
}

data "b2_account_info" "account" {}