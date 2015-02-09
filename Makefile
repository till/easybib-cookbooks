rake=bundle exec rake

cs:
	$(rake) rubocop
	$(rake) foodcritic

test:
	$(rake) test
	$(rake) spec
