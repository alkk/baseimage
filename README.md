# Docker Base Images

Alpine-based Docker images with Java runtime environments and build tools.

## Available Images

| Image | Tag | Purpose |
|-------|-----|---------|
| Base | `ghcr.io/alkk/baseimage:latest` | Minimal Alpine with essential utilities |
| JRE 17 | `ghcr.io/alkk/baseimage/jre17:latest` | Java 17 runtime |
| JRE 21 | `ghcr.io/alkk/baseimage/jre21:latest` | Java 21 runtime |
| JDK 17 Builder | `ghcr.io/alkk/baseimage/builder-jdk17:latest` | Java 17 build environment with Maven |
| JDK 21 Builder | `ghcr.io/alkk/baseimage/builder-jdk21:latest` | Java 21 build environment with Maven |

All images support `linux/amd64` and `linux/arm64` architectures.

## Base Image

Minimal Alpine image with essential utilities for running applications.

**Included packages:** ca-certificates, dumb-init, su-exec, tzdata

```dockerfile
FROM ghcr.io/alkk/baseimage:latest

COPY myapp /srv/myapp
CMD ["/srv/myapp"]
```

## JRE Images

Runtime images for Java applications. Include automatic privilege dropping to non-root user.

```dockerfile
FROM ghcr.io/alkk/baseimage/jre{17,21}:latest

COPY target/myapp.jar /srv/app.jar
CMD ["java", "-jar", "/srv/app.jar"]
```

### Custom Initialization

Create `/srv/init.sh` to run custom initialization before your application starts:

```dockerfile
FROM ghcr.io/alkk/baseimage/jre{17,21}:latest

COPY init.sh /srv/init.sh
COPY target/myapp.jar /srv/app.jar
CMD ["java", "-jar", "/srv/app.jar"]
```

```bash
#!/bin/sh
# /srv/init.sh - runs before main command
echo "Initializing application..."
mkdir -p /srv/data
```

## Builder Images

Build environment images with JDK and Maven for compiling Java applications.

```dockerfile
FROM ghcr.io/alkk/baseimage/builder-jdk{17,21}:latest AS builder

WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn package

FROM ghcr.io/alkk/baseimage/jre{17,21}:latest
COPY --from=builder /build/target/*.jar /srv/app.jar
CMD ["java", "-jar", "/srv/app.jar"]
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_UID` | `101` | Application user ID |
| `APP_GID` | `990` | Application group ID |
| `TZ` | `Europe/Riga` | Timezone |

### Custom UID/GID

Run container with custom user/group IDs:

```bash
docker run -e APP_UID=1000 -e APP_GID=1000 ghcr.io/alkk/baseimage/jre{17,21}:latest
```

### Custom Timezone

```bash
docker run -e TZ=UTC ghcr.io/alkk/baseimage/jre{17,21}:latest
```

## Building Images Locally

```bash
make all                           # Build all images
make docker-baseimage              # Build base image only
make docker-baseimage-jre17        # Build JRE 17 only
make docker-baseimage-jre21        # Build JRE 21 only
make docker-baseimage-jdk17-builder # Build JDK 17 builder only
make docker-baseimage-jdk21-builder # Build JDK 21 builder only
make clean                         # Remove all images
```

## License

MIT
