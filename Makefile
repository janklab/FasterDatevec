# This Makefile is for project packaging

default: all

.PHONY: all
all: doc dist

.PHONY: dist
dist:
	bash package_package.sh

# Builds the Matlab Toolbox help files
# feed.xml includes a timestamp and messes up git status, and we don't need
# it, so blow it away
.PHONY: doc
doc:
	(cd doc; bundle exec jekyll build --destination ../M-doc)
	rm M-doc/feed.xml
