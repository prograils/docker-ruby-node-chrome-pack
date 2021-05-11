# docker-ruby-node-chrome-pack

Starting point for running Rails specs - includes Ruby 2.6.6 and
nodejs 10.x and Chrome (Google Chrome & Chromedriver)

## What's inside

The supplied `Dockerfile` will create an images for docker containers
with ruby and nodejs.

## Getting started

### Getting the image

```
$ docker pull prograils/ruby-node-chrome-pack
```

### Running

```
$ docker run -t -i prograils/ruby-node-chrome-pack
```

### Testing

```
$ bundle exec rspec
```

## References

- [Test Drive Your Dockerfiles with RSpec and ServerSpec](https://robots.thoughtbot.com/tdd-your-dockerfiles-with-rspec-and-serverspec)
