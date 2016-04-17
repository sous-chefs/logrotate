travis: bundle
	bundle exec chefstyle -D
	bundle exec foodcritic -f any . --tags ~FC015
	bundle exec rspec --color --format doc

bundle:
	bundle install
