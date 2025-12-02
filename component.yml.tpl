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
            - sudo yum install -y git gcc zlib-devel bzip2 bzip2-devel readline-devel openssl-devel tk-devel libffi-devel xz-devel ${additional_pkgs}
            - curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer -o /var/tmp/pyenv-installer
            - export PYENV_ROOT="${ansible_pyenv_path}"
            - bash /var/tmp/pyenv-installer
            # Set up pyenv in current shell
            - export PATH="$PYENV_ROOT/bin:$PATH"
            - eval "$(pyenv init -)"
            # Install desired Python version
            - pyenv install ${python_version}
            - pyenv global ${python_version}
            - pyenv virtualenv ${python_version} ansible
            # Install Ansible
            - pip install ansible ${additional_pip_pkgs}
