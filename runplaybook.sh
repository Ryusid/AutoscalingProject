#!/bin/bash
set -e

echo "Ensuring Docker group membership..."
sudo usermod -aG docker $USER || true
newgrp docker <<'EOF'
  echo " Running Ansible playbook..."
  ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --ask-become-pass
EOF
