ALL: docker

build-install:
	./build-install.sh

docker:
	docker build -t registry.zerotier.com/zerotier/install.zerotier.com:drone-${DRONE_BUILD_NUMBER} .

push:
	docker push registry.zerotier.com/zerotier/install.zerotier.com:drone-${DRONE_BUILD_NUMBER}

drone:
	@echo "signing drone.yml"
	drone sign --save zerotier/install.zerotier.com