resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

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
          - ${trimspace(data.local_file.admin_ssh_public_key.content)}
      - name: ansible
        gecos: Ansible User
        groups:
          - sudo
        sudo: "ALL=(ALL) NOPASSWD:ALL"
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(data.local_file.ansible_ssh_public_key.content)}
    chpasswd:
      expire: false
      users:
        - {name: root, type: RANDOM}
        - {name: ${var.ADMIN_USERNAME, type: RANDOM}
        - {name: ansible, type: RANDOM}
    allow_public_ssh_keys: true
    ssh_pwauth: false
    disable_root: true
    apt:
      http_proxy: "http://aptcache.${var.LOCAL_DOMAIN}:3142"
      sources:
        docker.list:
          source: "deb [arch=amd64] http://download.docker.com/linux/ubuntu $RELEASE stable"
          keyid: "9DC858229FC7DD38854AE2D88D81803C0EBFCD88"
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
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
      - docker-compose-plugin
    drivers:
      nvidia:
        license-accepted: true
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - sed -i 's/auth/# auth/g' /etc/pam.d/sudo
      - sed -i '1 i\auth       required   pam_ssh_agent_auth.so allow_user_owned_authorized_keys_file' /etc/pam.d/sudo
      - cat 'net.ipv4.conf.all.forwarding=1' > /etc/sysctl.d/enabled_ipv4_forwarding.conf
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}

data "local_file" "admin_ssh_public_key" {
  filename = "./admin.pub"
}

data "local_file" "ansible_ssh_public_key" {
  filename = "./ansible.pub"
}