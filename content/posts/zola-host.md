---
title: "Switch host to Codeberg"
date: 2025-02-25T08:27:00
draft: false
category: ["update"]
tags: ["blog", "hosting", "self-reflection"]
---

This site has now switched to Codeberg hosting. Codeberg is an up-and-coming community run alternative to the popular Github service. Being a FOSS enthusiast myself, it was an natural move for me. Going forward I intend to host all my new projects in Codeberg. I have linked to my Codeberg profile in the site homepage now instead.

Codeberg is built on the open-source Forgejo base software. Naturally I tried my hand at selfhosting it, complete with a runner (CI workflow host helper). Unfortunately the online version doesn't offer a CI runner for free.

As a result of this, we can't have automated hosted (on push) builds of the SSG site generation. We have to build it locally (or supply a CI runner in the form of a VM). But I see this as a good thing. This will force you to test the generated site for errors locally.

We could have also pushed to a temporary host branch/repo to see if it's successful before merging into the actual site repo (but this is beyond my understanding). So far I have been just making the necessary changes to source files and then blindly push to Github, where the runner builds (fingers crossed). Fortunately `zola` version provided by Github images was not updated over time (which have come through breaking changes!).

To make this local build process seamless, I use a Makefile in the project root:

```
.PHONY: pages clean publish
SHELL := /bin/bash
LAST_COMMIT_MESSAGE := $(shell git log -n 1 --pretty=format:'%s')
PAGES_REPO_URL := git@codeberg.org:ntn888/pages.git
PAGES_DIR := ../pages

pages: clean
	flatpak run org.getzola.zola build

clean:
	rm -rf public/

publish: pages
	# Clone the repo if it doesn't exist
	if [ ! -d "$(PAGES_DIR)" ]; then \
		git clone --depth=1 $(PAGES_REPO_URL) $(PAGES_DIR); \
	fi

	# Remove all files except .git (ensuring .git and its content remain intact)
	find $(PAGES_DIR) -mindepth 1 -not -path "$(PAGES_DIR)/.git/*" -not -name ".git" -exec rm -rf {} +

	# Copy all built files to the cleaned pages directory
	cp -r public/. $(PAGES_DIR)/

	# Push new changes to the remote repository
	pushd $(PAGES_DIR) && \
		git add . && \
		git commit -m "Update site: $(LAST_COMMIT_MESSAGE)" && \
		git push origin main && \
	popd
```

As seen, this creates (if not already present) `pages` directory adjacent to the current SSG source project directory. And pushes this to the `pages` repo to Codeberg (which is the specified repo for hosting pages).

Now, run `make pages` to generate followed by `make publish`.

In other news, I have reclaimed my `simplycreate.online` domain for this site. This will help sustain the site in-case of problems with a specific host, in this case Codeberg.

