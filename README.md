# Diff

Pure Crystal implementation of various diffing algorithms. Currently includes:

- Myers
- Myers (linear)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     diff:
       github: watzon/diff
   ```

2. Run `shards install`

## Usage

```crystal
require "diff"

a = File.open("foo.cr")
b = File.open("foo_edited.cr")

diff = Diff.new(a, b, Diff::MyersLinear)
puts diff.to_s
```

## Contributing

1. Fork it (<https://github.com/watzon/diff/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
