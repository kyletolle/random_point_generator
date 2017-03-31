# random_point_generator

This gem is for generating random map points (latitude, longitude pair).

A bounding box can be given, to restrict points to that area.

## Install

```
gem install random_point_generator
```

## Usage


### Without a Bounding Box

A default bounding box of the entire world will be used when a bounding box is
not given.

```
require 'random_point_generator'

generator = RandomPointGenerator.new
generator.random_point
# => ["-6.331129", "131.379397"]
```

### With a Bounding Box

The initializer takes in a southwest point (array of lat, lng) and a northeast
point (array of lat, lng).

The lat long can be a string value, if you wish to preserve accuracy that
could be lost due to floating points.


```
require 'random_point_generator'

sw_point = ["40.636883","-74.083214"]
ne_point = ["40.831476","-73.673630"]

nyc_point_generator = RandomPointGenerator.new(sw_point, ne_point)
nyc_point_generator.random_point
# => ["40.637508", "-73.951641"]
```

## Development

### Install

```
gem install --dev random_point_generator
```

### Specs

The default Rake task is to run the specs.

```
rake
```

## License

MIT

