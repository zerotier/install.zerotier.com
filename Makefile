ALL: docker

docker:
	docker build -t registry.zerotier.com/zerotier/install.zerotier.com:drone-${DRONE_BUILD_NUMBER} .

drone:
	@echo "signing drone.yml"
	drone sign --save zerotier/install.zerotier.com