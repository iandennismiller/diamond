# Ian Dennis Miller
# diamond makefile

SHELL=/bin/bash
MOD_NAME=project_system
TEST_CMD=nosetests -w $(MOD_NAME) -c etc/tests.cfg --with-coverage --cover-package=$(MOD_NAME)

install:
	python setup.py install

dev:
	pip install -r requirements-dev.text

clean:
	rm -rf build dist *.egg-info *.pyc
	rm -rf output
	mkdir output

docs:
	rm -rf build/sphinx
	sphinx-build -b html docs build/sphinx

watch:
	watchmedo shell-command -R -p "*.py" -c 'date; $(TEST_CMD); date' .

test:
	$(TEST_CMD)

tox:
	tox

release:
	# first: python setup.py register -r https://pypi.python.org/pypi
	python setup.py sdist upload

# create a homebrew install script
homebrew:
	bin/poet-homebrew.sh
	cp /tmp/project_system.rb etc/project_system.rb

.PHONY: clean install test watch docs release tox dev homebrew
