.PHONY: start stop stop-minions launch-minions master-login minion-1-login minion-2-login

clean:
	docker compose down --rmi all --volumes --remove-orphans

build:
	docker compose build

up:
	docker compose up -d

up-force:
	docker compose up -d --build --force-recreate

down:
	docker compose down

ps:
	docker compose ps

minion-start:
	@echo "Current minions running:"
	@docker compose ps | grep salt-minion || echo "None"
	@echo ""
	@read -p "Enter the total number of minions you want running: " num_minions; \
	docker compose up -d --scale salt-minion=$$num_minions
	@echo ""
	@docker compose ps | grep salt-minion || echo "No minions running"

minion-stop:
	@echo "Stopping all minions..."
	@docker compose up --scale salt-minion=0
	@echo "Minions stopped"

master-login:
	@echo "" && echo "Connecting to salt-master..." && echo ""
	@docker compose exec salt-master bash

minion-login:
	@echo "Current minions running:"
	@echo ""
	@docker compose ps | grep salt-minion || echo "None" && exit
	@echo ""
	@read -p "Enter the minion number: " minion_number; \
	echo "" && echo "Connecting to salt-minion-$$minion_number" && echo ""; \
	docker compose exec --index=$$minion_number salt-minion bash
