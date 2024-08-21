.PHONY: init
init:
	@docker compose build
	@docker compose run web rails db:setup

# Compiles requirements.txt files from dependencies specified in requirements.in
.PHONY: start
start:
	@docker compose up

# Catch-all target which does nothing
%:
	@:
