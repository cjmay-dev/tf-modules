resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
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
          - ${var.ANSIBLE_SSH_PUBLIC_KEY}
    chpasswd:
      expire: false
      users:
        - {name: root, password: ${var.ROOT_HASHED_PASSWORD}}
        - {name: ${var.ADMIN_USERNAME}, type: RANDOM}
        - {name: ansible, type: RANDOM}
    allow_public_ssh_keys: true
    ssh_pwauth: false
    disable_root: true
    apt:
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