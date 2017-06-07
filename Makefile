all: delivery

travis: debug_version_info all

debug_version_info:
	/opt/chefdk/embedded/bin/chef --version
	/opt/chefdk/embedded/bin/cookstyle --version
	/opt/chefdk/embedded/bin/foodcritic --version

delivery:
	/opt/chefdk/bin/chef exec delivery local all
