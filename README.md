# StatC

[![Gem Version](https://badge.fury.io/rb/stat_c.svg)](https://badge.fury.io/rb/stat_c) [![Build Status](https://travis-ci.org/mooreryan/stat_c.svg?branch=master)](https://travis-ci.org/mooreryan/stat_c) [![Coverage Status](https://coveralls.io/repos/github/mooreryan/stat_c/badge.svg?branch=master)](https://coveralls.io/github/mooreryan/stat_c?branch=master)

Fast, well documented C stats extension for Ruby.

Pronounce it like "Statsie" and you will feel all warm and fuzzy inside!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stat_c'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stat_c

## Usage

```ruby
require "stat_c"

ary = [-1.4, 0, 1, 2, 3.0]

StatC::Array.mean(ary).round(2)  #=> 0.92

# Stats based on sample variance
StatC::Array.var(ary).round(2)  #=> 2.93
StatC::Array.sd(ary).round(2)   #=> 1.71
StatC::Array.se(ary).round(2)   #=> 0.77

# Stats based on population variance
StatC::Array.var(ary, pop=true).round(2)  #=> 2.35
StatC::Array.sd(ary,  pop=true).round(2)  #=> 1.53
StatC::Array.se(ary,  pop=true).round(2)  #=> 0.68
```

## Benchmark ##

StatC is faster than pure Ruby (duh, it's a C extension {^_^} ). See `benchmark/benchmark.rb` for more info.

    $ ruby benchmark/benchmark.rb

    Rehearsal ----------------------------------------------
    Ruby  mean   0.090000   0.000000   0.090000 (  0.085029)
    StatC mean   0.010000   0.000000   0.010000 (  0.009604)
    Ruby  var    0.350000   0.010000   0.360000 (  0.357243)
    StatC var    0.020000   0.000000   0.020000 (  0.020343)
    Ruby  sd     0.350000   0.000000   0.350000 (  0.355273)
    StatC sd     0.020000   0.000000   0.020000 (  0.018590)
    Ruby  se     0.340000   0.000000   0.340000 (  0.353170)
    StatC se     0.030000   0.000000   0.030000 (  0.025813)
    ------------------------------------- total: 1.220000sec

                     user     system      total        real
    Ruby  mean   0.080000   0.000000   0.080000 (  0.079849)
    StatC mean   0.000000   0.000000   0.000000 (  0.009006)

    Ruby  var    0.320000   0.010000   0.330000 (  0.322538)
    StatC var    0.020000   0.000000   0.020000 (  0.018962)

    Ruby  sd     0.330000   0.000000   0.330000 (  0.329038)
    StatC sd     0.020000   0.000000   0.020000 (  0.020783)

    Ruby  se     0.310000   0.000000   0.310000 (  0.319696)
    StatC se     0.020000   0.000000   0.020000 (  0.019259)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mooreryan/stat_c. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
