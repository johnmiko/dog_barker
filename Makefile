
PYTHON := python3.11 # installed manually, consider using pyenv to manage
SHELL := /bin/bash

help: ## To show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: venv
venv: ## To relock all dependencies and regenerate a new virtual environment
	rm --force --recursive .venv/
	rm --force Pipfile.lock
	$(PYTHON) -m venv --upgrade-deps .venv
	@source .venv/bin/activate
	python -m pip install --upgrade pip
	python -m pip install pipenv
	pipenv install -d
	pipenv install


.PHONY: init
init: ## To initialize the virtual environement needed for all other targets
	rm --force --recursive .venv/
	$(PYTHON) -m venv --upgrade-deps .venv
	@source .venv/bin/activate
	python -m pip install --upgrade pip
	python -m pip install pipenv
	pipenv update


.PHONY: checkcode
checkcode: ## To check the code quality
	pipenv run pre-commit run --all


.PHONY: test
test:  ## To execute all the tests
	pipenv run python -m pytest ./tests

