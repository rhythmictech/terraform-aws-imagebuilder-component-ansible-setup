name: ${name}-document
%{ if description != null ~}
description: ${description}
%{ endif ~}
schemaVersion: 1.0
phases:
  - name: build
    steps:
      - name: ansible-install
        action: ExecuteBash
        inputs:
          commands:
            # Install Ansible dependencies
            - sudo yum install -y python python3 python-pip python3-pip git
            # Enable Ansible repository
            - sudo amazon-linux-extras enable ansible2
            # Install Ansible
            # TODO: #1 Enable version selection
            - sudo yum install -y ansible
