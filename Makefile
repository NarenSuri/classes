UNAME := $(shell uname)

BROWSER=firefox
ifeq ($(UNAME), Darwin)
BROWSER=open
endif
ifeq ($(UNAME), Linux)
BROWSER=xdg-open
endif
ifeq ($(UNAME), Windows)
BROWSER=/cygdrive/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe
endif
ifeq ($(UNAME), CYGWIN_NT-6.3)
BROWSER=/cygdrive/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe
endif

doc: 
	cd docs; make html

pdf: 
	cd docs; make latex
	cd docs/build/latex; pdflatex Classes

pdfview:
	cd docs/build/latex; $(BROWSER) Classes.pdf

watch:
	watchmedo shell-command --patterns="*.rst;*.csv;*.py" --recursive --command='make doc'

publish:
	ghp-import -n -p docs/build/html

view:
	$(BROWSER) docs/build/html/index.html

log:
	gitchangelog | fgrep -v ":dev:" | fgrep -v ":new:" > docs/source/changelog.rst
	git commit -m "chg: dev: Update changelog" docs/source/changelog.rst
	git push

######################################################################
# CLEANING
######################################################################

clean:
	rm -rf *.zip
	rm -rf *.egg-info
	rm -rf *.eggs
	rm -rf docs/build
	rm -rf build
	rm -rf dist
	find . -name '__pycache__' -delete
	find . -name '*.pyc' -delete
	rm -rf .tox
	rm -f *.whl

######################################################################
# TAGGING
######################################################################

tag:
	bin/new_version.sh

rmtag:
	python setup.py rmtag

