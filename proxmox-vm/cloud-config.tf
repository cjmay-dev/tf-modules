resource "proxmox_virtual_environment_file" "meta_data_cloud_config" {
  lifecycle {
    ignore_changes = all
  }
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"
  overwrite    = true

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: ${var.APP_SHORTNAME}
    EOF

    file_name = "meta-data-cloud-config.yaml"
  }
}

resource "tls_private_key" "ansible_ssh_key" {
  lifecycle {
    ignore_changes = all
  }
  algorithm = "ED25519"
}

resource "random_password" "ansible_password" {
  lifecycle {
    ignore_changes = all
  }
  length  = 32
  special = true
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  lifecycle {
    ignore_changes = all
  }
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"
  overwrite    = true

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${var.APP_SHORTNAME}
    fqdn: ${var.APP_SHORTNAME}.${var.LOCAL_DOMAIN}
    timezone: America/Chicago
    users:
      - name: ${var.ADMIN_USERNAME}
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${var.ADMIN_SSH_PUBLIC_KEY}
      - name: ansible
        gecos: Ansible User
        groups:
          - sudo
        sudo: "ALL=(ALL) NOPASSWD:ALL"
        shell: /bin/bash
        ssh_authorized_keys:
          - ${tls_private_key.ansible_ssh_key.public_key_openssh}
    chpasswd:
      expire: false
      users:
        - {name: root, type: RANDOM}
        - {name: ${var.ADMIN_USERNAME}, type: RANDOM}
        - {name: ansible, password: "${random_password.ansible_password.result}"}
    allow_public_ssh_keys: true
    ssh_pwauth: false
    disable_root: true
    package_update: true
    packages:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg-agent
      - software-properties-common
      - qemu-guest-agent
      - libpam-ssh-agent-auth
      - net-tools
      - htop
      - python3
      - python3-pip
      - python3-setuptools
      - python3-six
    drivers:
      nvidia:
        license-accepted: true
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - systemctl enable serial-getty@ttyS0.service
      - systemctl start serial-getty@ttyS0.service
      - echo "Defaults env_keep+=SSH_AUTH_SOCK" >> /etc/sudoers
      - sed -i '1 i\auth sufficient pam_ssh_agent_auth.so file=~/.ssh/authorized_keys' /etc/pam.d/sudo
      - cat 'net.ipv4.conf.all.forwarding=1' > /etc/sysctl.d/enabled_ipv4_forwarding.conf
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}