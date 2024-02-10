VPATH = $(tmp)

git_base := $(or ${GIT_BASE},main)
git_head := $(or ${GIT_HEAD},)
git_diff = $(subst $(space),..,$(strip $(git_base) $(git_head)))
projects = front-end back-end

null :=
space := $(null) #
tmp := tmp/make/

# ----------------------------------------------------------------------------------------------------------------------
# PRIMARY TARGETS
# ----------------------------------------------------------------------------------------------------------------------

default: FORCE

clean: FORCE
	rm -rf $(tmp)

init: FORCE
	mkdir -p $(tmp) $(tmp)src/
	touch $(projects:%=$(tmp)src/%) $(projects:%=$(tmp)src/%.test)

git-diff: $(projects:%=src/%.git-diff) FORCE

test: $(projects:%=src/%.test) FORCE

# ----------------------------------------------------------------------------------------------------------------------
# SECONDARY TARGETS
# ----------------------------------------------------------------------------------------------------------------------

%.git-diff: FORCE
	if git diff --name-only $(git_diff) -- $* | grep ^ 1>/dev/null; then \
	  echo "$* was changed"; \
	  rm $(tmp)$*; \
	  rm $(tmp)$*.test; \
	fi;

src/%.test: src/%
	echo "RUNNING TESTS FOR $* project in directory src/$*"
	# run some kind of test here
	touch $(tmp)$@

FORCE: ;

# ----------------------------------------------------------------------------------------------------------------------
# PROJECT DEPENDENCY DEFINITIONS
# ----------------------------------------------------------------------------------------------------------------------

src/front-end.test: src/back-end.test
