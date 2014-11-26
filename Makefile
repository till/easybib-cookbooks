rake=bundle exec rake

cs:
	$(rake) rubocop
	$(rake) foodcritic

test:
	find . -type f -name "*.rb" -exec ruby -c {} > /dev/null \;
	$(rake) test
	$(rake) spec
