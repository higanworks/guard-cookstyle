# Guard::Cookstyle

[![Gem Version](https://badge.fury.io/rb/guard-cookstyle.svg)](https://badge.fury.io/rb/guard-cookstyle)

guard-cookstyle allows you to automatically check Chef cookbook style with [Cookstyle](https://github.com/chef/cookstyle) when files are modified.

Cookstyle is a wrapper of rubocop, so most of the codes were based on [yujinakayama/guard-rubocop]((https://github.com/yujinakayama/guard-rubocop)).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'guard-cookstyle'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install guard-cookstyle
```

Add the default Guard::Cookstyle definition to your Guardfile by running:

```
$ guard init cookstyle
```

## Usage

Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

## Options

You can pass some options in `Guardfile` like the following example:

```ruby
guard :cookstyle, all_on_start: false, cli: ['--format', 'clang'], cookbook_dirs: ['mycookbooks'] do
  # ...
end
```

### Available Options

```ruby
all_on_start: true     # Check all files at Guard startup.
                       #   default: true
cli: '--rails'         # Pass arbitrary Cookstyle CLI arguments. (almost same of RuboCop)
                       # An array or string is acceptable.
                       #   default: nil
hide_stdout: false     # Do not display console output (in case outputting to file).
                       #   default: false
keep_failed: true      # Keep failed files until they pass.
                       #   default: true
notification: :failed  # Display Growl notification after each run.
                       #   true    - Always notify
                       #   false   - Never notify
                       #   :failed - Notify only when failed
                       #   default: :failed
launchy: nil           # Filename to launch using Launchy after RuboCop runs.
                       #   default: nil
cookbook_dirs: []      # Directory of Cookbooks to check.
                       #   default: %w[cookbooks site-cookbooks]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/higanworks/guard-cookstyle.


## License

Licensed under the Apache License, Version 2.0.
