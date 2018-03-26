[![build status][251]][232] [![commit][255]][231] [![version:x86_64][256]][235] [![size:x86_64][257]][235] [![version:armhf][258]][236] [![size:armhf][259]][236]

## [Alpine-Ubooquity][234]
#### Container for Alpine Linux + OpenJDK8 + Ubooquity
---

This [image][233] containerizes [Ubooquity][135] e-book
server/viewer, to serve files and read comics/ebooks shared from
a device in the network, running under [OpenJDK][136] 8.\*.\*.

Current stable version is `2.1.1`.

Based on [Alpine Linux][131]  from my [alpine-openjdk8][132] image
with the [s6][133] init system and GNU LibC [overlayed][134] in
it.

The image is tagged respectively for the following architectures,
* **armhf**
* **x86_64** (retagged as the `latest` )

**armhf** builds have embedded binfmt_misc support and contain the
[qemu-user-static][105] binary that allows for running it also inside
an x64 environment that has it.

---
#### Get the Image
---

Pull the image for your architecture it's already available from
Docker Hub.

```
# make pull
docker pull woahbase/alpine-ubooquity:x86_64
```
---
#### Configuration Defaults
---

* Configuration are read from `/config/preferences.json`, edit or
  remount this file to customize settings.

* Default serves books from `/books`, comics from `/comics` and
  files from `/files`. They should be readable by the process
  user.

* Default exposes the library port at `2202` and adminport at
  `2203`, however, user management is disabled in the default
  configurations.

* The `MAXMEM` variable limits how much memory the JVM can use.

* This image already has a user `alpine` configured to drop
  privileges to the passed `PUID`/`PGID` which is ideal if its
  used to run in non-root mode. That way you only need to specify
  the values at runtime and pass the `-u alpine` if need be. (run
  `id` in your terminal to see your own `PUID`/`PGID` values.)

---
#### Run
---

If you want to run images for other architectures, you will need
to have binfmt support configured for your machine. [**multiarch**][104],
has made it easy for us containing that into a docker container.

```
# make regbinfmt
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Without the above, you can still run the image that is made for your
architecture, e.g for an x86_64 machine..

Running `make` starts the service.

```
# make
docker run --rm -it \
  --name docker_ubooquity --hostname ubooquity \
  -e PGID=1000 -e PUID=1000 \
  -c 512 -m 1024m -e MAXMEM=1024 \
  -p 2202:2202 -p 2203:2203 \
  -v config:/config \
  -v books:/books \
  -v comics:/comics \
  -v files:/files \
  woahbase/alpine-ubooquity:x86_64
```

Stop the container with a timeout, (defaults to 2 seconds)

```
# make stop
docker stop -t 2 docker_ubooquity
```

Removes the container, (always better to stop it first and `-f`
only when needed most)

```
# make rm
docker rm -f docker_ubooquity
```

Restart the container with

```
# make restart
docker restart docker_ubooquity
```

---
#### Shell access
---

Get a shell inside a already running container,

```
# make shell
docker exec -it docker_ubooquity /bin/bash
```

set user or login as root,

```
# make rshell
docker exec -u root -it docker_ubooquity /bin/bash
```

To check logs of a running container in real time

```
# make logs
docker logs -f docker_ubooquity
```

---
### Development
---

If you have the repository access, you can clone and
build the image yourself for your own system, and can push after.

---
#### Setup
---

Before you clone the [repo][231], you must have [Git][101], [GNU make][102],
and [Docker][103] setup on the machine.

```
git clone https://github.com/woahbase/alpine-ubooquity
cd alpine-ubooquity
```
You can always skip installing **make** but you will have to
type the whole docker commands then instead of using the sweet
make targets.

---
#### Build
---

You need to have binfmt_misc configured in your system to be able
to build images for other architectures.

Otherwise to locally build the image for your system.
[`ARCH` defaults to `x86_64`, need to be explicit when building
for other architectures.]

```
# make ARCH=x86_64 build
# sets up binfmt if not x86_64
docker build --rm --compress --force-rm \
  --no-cache=true --pull \
  -f ./Dockerfile_x86_64 \
  --build-arg ARCH=x86_64 \
  --build-arg DOCKERSRC=alpine-openjdk8 \
  --build-arg UBVERSION=2.1.0 \
  --build-arg USERNAME=woahbase \
  -t woahbase/alpine-ubooquity:x86_64 \
  .
```

To check if its working..

```
# make ARCH=x86_64 test
docker run --rm -it \
  --name docker_ubooquity \
  --hostname ubooquity  \
  -e PGID=1000 -e PUID=1000 \
  -c 512 -m 1024m -e MAXMEM=1024 \
  woahbase/alpine-ubooquity:x86_64 \
  sh -ec 'sleep 15; java -version';
```

And finally, if you have push access,

```
# make ARCH=x86_64 push
docker push woahbase/alpine-ubooquity:x86_64
```

---
### Maintenance
---

Sources at [Github][106]. Built at [Travis-CI.org][107] (armhf / x64 builds). Images at [Docker hub][108]. Metadata at [Microbadger][109].

Maintained by [WOAHBase][204].

[101]: https://git-scm.com
[102]: https://www.gnu.org/software/make/
[103]: https://www.docker.com
[104]: https://hub.docker.com/r/multiarch/qemu-user-static/
[105]: https://github.com/multiarch/qemu-user-static/releases/
[106]: https://github.com/
[107]: https://travis-ci.org/
[108]: https://hub.docker.com/
[109]: https://microbadger.com/

[131]: https://alpinelinux.org/
[132]: https://hub.docker.com/r/woahbase/alpine-openjdk8
[133]: https://skarnet.org/software/s6/
[134]: https://github.com/just-containers/s6-overlay
[135]: http://vaemendis.net/ubooquity/
[136]: http://openjdk.java.net/

[201]: https://github.com/woahbase
[202]: https://travis-ci.org/woahbase/
[203]: https://hub.docker.com/u/woahbase
[204]: https://woahbase.online/

[231]: https://github.com/woahbase/alpine-ubooquity
[232]: https://travis-ci.org/woahbase/alpine-ubooquity
[233]: https://hub.docker.com/r/woahbase/alpine-ubooquity
[234]: https://woahbase.online/#/images/alpine-ubooquity
[235]: https://microbadger.com/images/woahbase/alpine-ubooquity:x86_64
[236]: https://microbadger.com/images/woahbase/alpine-ubooquity:armhf

[251]: https://travis-ci.org/woahbase/alpine-ubooquity.svg?branch=master

[255]: https://images.microbadger.com/badges/commit/woahbase/alpine-ubooquity.svg

[256]: https://images.microbadger.com/badges/version/woahbase/alpine-ubooquity:x86_64.svg
[257]: https://images.microbadger.com/badges/image/woahbase/alpine-ubooquity:x86_64.svg

[258]: https://images.microbadger.com/badges/version/woahbase/alpine-ubooquity:armhf.svg
[259]: https://images.microbadger.com/badges/image/woahbase/alpine-ubooquity:armhf.svg
