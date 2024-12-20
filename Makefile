# eventually there might be more than one target...
.PHONY: all
all: user-bin dotfiles

# most of this is shamelessly stolen
# src: https://github.com/jessfraz/dotfiles/blob/master/Makefile

.PHONY: user-bin
user-bin: ## Installs the bin directory files.
	# add aliases for things in bin
	if [ ! -d $$HOME/bin ]; then \
		mkdir -p $$HOME/bin; \
	fi; \
	for file in $(shell find $(CURDIR)/bin \
					-type f \
					-not -name "*-backlight" \
					-not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $$HOME/bin/$$f; \
	done; \

.PHONY: dotfiles
dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) \
					-name ".*" \
					-not -name ".gitignore" \
					-not -name ".travis.yml" \
					-not -name ".git" \
					-not -name ".*.swp" \
					-not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $$HOME/$$f; \
	done; \

.PHONY: test
test: shellcheck

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

.PHONY: shellcheck
shellcheck:
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh
