# Project guide

`ruby-osc7501-demo` runs `rake-osc7501`, `rspec-osc7501`, `thor-osc7501` and
`rubocop-osc7501` together so you can watch OSC 7501 status in a terminal.
It is not a gem and has no releases.

- `Rakefile` runs the three phases in order.
- `demo/` holds the inner Rakefile and the file RuboCop inspects.
- `test/` checks records and ordinary output through real subprocesses.

Use Ruby 3.4. Run `bundle exec rubocop` and both files in `test/` before
committing. Pin the adapter gems to exact versions in `Gemfile` and commit
`Gemfile.lock`. When a gem releases, bump its pin, rerun the tests, and update
the README if its output changed. Preserve LICENSE verbatim.
Agent plans and designs belong in GBrain, never Git.
