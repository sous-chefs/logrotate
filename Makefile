travis: bundle berks
	bundle exec chefstyle -D
	bundle exec foodcritic .
	bundle exec rspec --color --format doc

integration: bundle berks
	bundle exec kitchen test

bundle:
	bundle install

berks:
	bundle exec berks install
