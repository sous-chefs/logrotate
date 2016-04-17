travis: bundle
	bundle exec chefstyle -D
	bundle exec foodcritic .
	bundle exec rspec --color --format doc

bundle:
	bundle install
