.PHONY: all clean docker-baseimage docker-baseimage-jre17 docker-baseimage-jdk17-builder docker-baseimage-jre21 docker-baseimage-jdk21-builder

ifdef CI
ADDITIONAL_ARGUMENTS=--progress=plain
else
ADDITIONAL_ARGUMENTS=
endif

TAG=latest

all: docker-baseimage docker-baseimage-jre17 docker-baseimage-jdk17-builder docker-baseimage-jre21 docker-baseimage-jdk21-builder

docker-baseimage:
	docker build -t ghcr.io/alkk/baseimage:$(TAG) . $(ADDITIONAL_ARGUMENTS)

docker-baseimage-jre17:
	docker build -t ghcr.io/alkk/baseimage/jre17:$(TAG) -f Dockerfile.jre17 . $(ADDITIONAL_ARGUMENTS)

docker-baseimage-jdk17-builder:
	docker build -t ghcr.io/alkk/baseimage/builder-jdk17:$(TAG) -f Dockerfile.builder-jdk17 . $(ADDITIONAL_ARGUMENTS)

docker-baseimage-jre21:
	docker build -t ghcr.io/alkk/baseimage/jre21:$(TAG) -f Dockerfile.jre21 . $(ADDITIONAL_ARGUMENTS)

docker-baseimage-jdk21-builder:
	docker build -t ghcr.io/alkk/baseimage/builder-jdk21:$(TAG) -f Dockerfile.builder-jdk21 . $(ADDITIONAL_ARGUMENTS)

clean:
	docker image rm ghcr.io/alkk/baseimage:$(TAG) || true
	docker image rm ghcr.io/alkk/baseimage/jre17:$(TAG) || true
	docker image rm ghcr.io/alkk/baseimage/builder-jdk17:$(TAG) || true
	docker image rm ghcr.io/alkk/baseimage/jre21:$(TAG) || true
	docker image rm ghcr.io/alkk/baseimage/builder-jdk21:$(TAG) || true
