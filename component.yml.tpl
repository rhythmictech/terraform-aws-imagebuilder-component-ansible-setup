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
            - sudo yum install -y python python3 python-pip python3-pip git ${additional_pkgs}
            # Install Ansible
            - python3 -m venv ${ansible_venv_path}
            - source ${ansible_venv_path}/bin/activate
            - pip install ansible ${additional_pip_pkgs}
