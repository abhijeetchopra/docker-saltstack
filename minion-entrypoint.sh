#!/bin/bash

# Set the grain based on the environment variables
echo "grains:" > /etc/salt/minion.d/grains.conf

if [ -n "$ROLES" ]; then
  echo "Setting grain roles to $ROLES"
  echo "  roles: [${ROLES// /, }]" >> /etc/salt/minion.d/grains.conf
fi

if [ -n "$ENV" ]; then
  echo "Setting grain env to $ENV"
  echo "  env: $ENV" >> /etc/salt/minion.d/grains.conf
fi

# Start the salt-minion
exec salt-minion -l debug
