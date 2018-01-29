# docker-android-alpine

[benjohnde/docker-android-alpine:latest](https://hub.docker.com/r/benjohnde/docker-android-alpine)

This Docker image contains the Android SDK and most common packages necessary for building Android apps in a CI tool like GitLab CI. Make sure your CI environment's caching works as expected, this greatly improves the build time, especially if you use multiple build jobs.

A `.gitlab-ci.yml` with caching of your project's dependencies would look like this:

```
image: benjohnde/docker-android-alpine

stages:
- build

before_script:
- export GRADLE_USER_HOME=$(pwd)/.gradle
- chmod +x ./gradlew

cache:
  key: ${CI_PROJECT_ID}
  paths:
  - .gradle/

build:
  stage: build
  script:
  - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs/apk/app-debug.apk
```

## Kudos

- [jangrewe](https://github.com/jangrewe) and the other contributors for the ubuntu android-ci image.
- [frol](https://github.com/frol) for the [frolvlad/alpine-oraclejdk8:full](https://github.com/frol/docker-alpine-oraclejdk8) alpine docker image.
