rake=bundle exec appraisal rake
berks=bundle exec berks

cs:
	$(rake) rubocop
	$(rake) foodcritic

test:
	$(rake) unittest
	$(rake) spec

release:
	$(berks) package --quiet

berkshelf:
	cd stack-api; $(berks) package
	cd stack-citationapi; $(berks) package
	cd stack-cmbm; $(berks) package
	cd stack-easybib; $(berks) package
	cd stack-qa; $(berks) package
	cd stack-research; $(berks) package
	cd stack-service; $(berks) package

install:
	bundle install
	bundle exec appraisal install
