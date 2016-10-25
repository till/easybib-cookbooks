rake=bundle exec rake
berks=bundle exec berks

cs:
	$(rake) rubocop
	$(rake) foodcritic

test:
	$(rake) unittest
	$(rake) parallel_spec

release:
	bundle exec berks package --quiet

berkshelf:
	cd stack-api; $(berks) package
	cd stack-citationapi; $(berks) package
	cd stack-cmbm; $(berks) package
	cd stack-easybib; $(berks) package
	cd stack-ops; $(berks) package
	cd stack-qa; $(berks) package
	cd stack-research; $(berks) package
	cd stack-service; $(berks) package
