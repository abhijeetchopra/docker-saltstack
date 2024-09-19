
.PHONY: init
init:
		@echo "ERROR: no Makefile target selected"
		@echo ""
		@echo "USAGE: make [clean, build, up, up-force, down, ps, minion-start, minion-stop, master-login, minion-login]"
		@echo ""
		@exit 1


.PHONY: clean
clean:
	docker compose down --rmi all --volumes --remove-orphans

.PHONY: build
build:
	docker compose build

.PHONY: up
up:
	docker compose up -d

.PHONY: up-force
up-force:
	docker compose up -d --build --force-recreate

.PHONY: down
down:
	docker compose down

.PHONY: ps
ps:
	docker compose ps

.PHONY: minion-start
minion-start:
	@echo "Current minions running:"
	@docker compose ps | grep salt-minion || echo "None"
	@echo ""
	@read -p "Enter the total number of minions you want running: " num_minions; \
	docker compose up -d --scale salt-minion=$$num_minions
	@echo ""
	@docker compose ps | grep salt-minion || echo "No minions running"

.PHONY: minion-stop
minion-stop:
	@echo "Stopping all minions..."
	@docker compose up --scale salt-minion=0
	@echo "Minions stopped"

.PHONY: master-login
master-login:
	@echo "" && echo "Connecting to salt-master..." && echo ""
	@docker compose exec salt-master bash

.PHONY: minion-login
minion-login:
	@echo "Current minions running:"
	@echo ""
	@docker compose ps | grep salt-minion || echo "None" && exit
	@echo ""
	@read -p "Enter the minion number: " minion_number; \
	echo "" && echo "Connecting to salt-minion-$$minion_number" && echo ""; \
	docker compose exec --index=$$minion_number salt-minion bash
