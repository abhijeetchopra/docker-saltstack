# docker-saltstack

Docker Compose setup to spin up a salt master and minions.

You can read a full article describing how to use this setup [here](https://medium.com/@timlwhite/the-simplest-way-to-learn-saltstack-cd9f5edbc967).

You will need a system with Docker and Docker Compose installed to use this project.

## Quick Start

### Using Makefile (Recommended)

This project includes a Makefile with convenient commands for managing the SaltStack environment:

```bash
# Start the salt master and minion in detached mode
make up

# Build and start with force recreate
make up-force

# Stop all containers
make down

# View running containers
make ps

# Login to salt master
make master-login

# Login to a specific minion
make minion-login
```

### Using Docker Compose Directly

Alternatively, you can use Docker Compose commands directly:

```bash
# Start with debug logging to console
docker compose up

# Start in detached mode
docker compose up -d
```

Then you can run (in a separate shell window):

```bash
# Using Makefile
make master-login

# Or using Docker Compose directly
docker compose exec salt-master bash
```

and it will log you into the command line of the salt-master server.

From that command line you can run something like:

```bash
salt '*' test.ping
```

and in the window where you started docker compose, you will see the log output of both the master sending the command and the minion receiving the command and replying.

[The Salt Remote Execution Tutorial](https://docs.saltstack.com/en/latest/topics/tutorials/modules.html) has some quick examples of the commands you can run from the master.

Note: you will see log messages like : "Could not determine init system from command line" - those are just because salt is running in the foreground and not from an auto-startup.

The salt-master is set up to accept all minions that try to connect.  Since the network that the salt-master sees is only the docker-compose network, this means that only minions within this docker-compose service network will be able to connect (and not random other minions external to docker).

## Running multiple minions

### Using Makefile

```bash
# Start multiple minions (interactive prompt)
make minion-start

# Stop all minions
make minion-stop
```

### Using Docker Compose Directly

```bash
docker compose up --scale salt-minion=2
```

This will start up two minions instead of just one.

## Available Makefile Commands

- `make up` - Start salt master and minion in detached mode
- `make up-force` - Build and start with force recreate
- `make down` - Stop all containers
- `make ps` - View running containers
- `make clean` - Stop containers and remove images, volumes, and orphans
- `make build` - Build the Docker images
- `make master-login` - Login to salt master container
- `make minion-login` - Login to a specific minion container
- `make minion-start` - Start multiple minions (interactive)
- `make minion-stop` - Stop all minions

## Host Names

The **hostnames** match the names of the containers - so the master is `salt-master` and the minion is `salt-minion`.

If you are running more than one minion with `--scale=2`, you will need to use `docker-saltstack-salt-minion-1` and `docker-saltstack-salt-minion-2` for the minions if you want to target them individually.
