all: delivery

travis: debug_version_info all

debug_version_info:
	/opt/chefdk/bin/chef --version
	/opt/chefdk/bin/cookstyle --version
	/opt/chefdk/bin/foodcritic --version

delivery:
	/opt/chefdk/bin/chef exec delivery local all
