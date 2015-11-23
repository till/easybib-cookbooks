rake=bundle exec rake

cs:
	$(rake) rubocop
	$(rake) foodcritic

test:
	$(rake) unittest
	$(rake) spec
