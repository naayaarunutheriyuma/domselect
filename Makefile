.PHONY: init venv deps dirs clean pytest coverage test release mypy pylint ruff check build

.DEFAULT_GOAL := check
FILES_CHECK_MYPY := domselect tests
FILES_CHECK_ALL := $(FILES_CHECK_MYPY)
COVERAGE_TARGET := domselect
PYTHON_VER := 3.13

init: venv deps dirs

venv:
	if which python$(PYTHON_VER); then \
		PYTHON_BINARY=python$(PYTHON_VER); \
	else \
		PYTHON_BINARY=var/bin/python$(PYTHON_VER); \
	fi; \
	virtualenv --python $$PYTHON_BINARY .venv

deps:
	#curl -sS https://bootstrap.pypa.io/get-pip.py | .env/bin/python3 # a fix for manually built python
	.venv/bin/pip install -U setuptools wheel
	.venv/bin/pip install -r requirements_dev.txt
	.venv/bin/pip install -e .

dirs:
	if [ ! -e var/run ]; then mkdir -p var/run; fi
	if [ ! -e var/log ]; then mkdir -p var/log; fi
	if [ ! -e var/bin ]; then mkdir -p var/bin; fi

clean:
	find -name '*.pyc' -delete
	find -name '*.swp' -delete
	find -name '__pycache__' -delete

pytest:
	pytest -n30 -x --cov $(COVERAGE_TARGET) --cov-report term-missing

coverage:
	pytest -n30 -x --cov $(COVERAGE_TARGET) --cov-report term-missing

test: check pytest
	tox -e check-minver


release:
	git push \
	&& git push --tags \
	&& make build \
	&& twine upload dist/*

mypy:
	mypy --strict $(FILES_CHECK_MYPY) --enable-error-code exhaustive-match --python-version 3.9

pylint:
	pylint -j0 $(FILES_CHECK_ALL)

ruff:
	ruff check --target-version=py39 $(FILES_CHECK_ALL)

check: ruff mypy pylint

build:
	rm -rf *.egg-info
	rm -rf dist/*
	python -m build --sdist
