# Ruby OSC 7501 demo

Report Rake, RSpec, Thor and RuboCop runs to the terminal status area of a
terminal that supports OSC 7501:

```sh
bundle install
bundle exec rake
```

We tested the demo with Ruby 3.4. `bundle install` needs a working C compiler
and Ruby development headers when a native gem has to build. A system Ruby
without those headers cannot build them.

`bundle exec rake` runs the default task in `Rakefile`. It needs no input and
runs each phase in the foreground, stopping on the first failure:

1. `bundle exec rake --rakefile demo/Rakefile` runs `spec/example_spec.rb`
   through RSpec's Rake task.
2. `bundle exec thor demo:perform` runs `Demo#perform` from `Thorfile`.
3. `bundle exec rubocop --no-server --require rubocop/osc7501 --format progress
   --format RuboCop::OSC7501::Formatter demo/example.rb` inspects
   `demo/example.rb`.

The inner Rakefile requires `rake/osc7501`, so it reports the only Rake root
record. The outer `Rakefile` does not, so it emits no OSC records. Thor and
RuboCop each report a root that replaces the previous one. `rspec-osc7501`
reports the RSpec child under an ID that `rake-osc7501` supplies.

Ordinary output stays visible: RSpec's progress line, the child RSpec command
line, `Thor demo complete`, and `1 file inspected, no offenses detected`. The
spec and the Thor command each sleep 0.5 seconds so readers have time to see
the status.

Run the phases individually:

```sh
bundle exec rake --rakefile demo/Rakefile
bundle exec thor demo:perform
bundle exec rubocop --no-server --require rubocop/osc7501 --format progress --format RuboCop::OSC7501::Formatter demo/example.rb
```

Two standalone Thor commands exercise other states. `bundle exec thor
demo:prompt` asks for a name and reports blocked while it waits for input.
`bundle exec thor demo:failure` raises an error and exits nonzero. Press Ctrl-C
to interrupt a run.

## Output modes

Each adapter reads its own variable: `RAKE_OSC7501`, `RSPEC_OSC7501`,
`THOR_OSC7501`, `RUBOCOP_OSC7501`. Each variable selects a mode, and all three
modes are valid for each:

- `auto` is the default. It reports only when the output is a TTY and `TERM`
  is not `dumb`.
- `force` reports even when output is redirected, which writes the escape
  sequences into ordinary output.
- `off` disables that adapter.

`RSPEC_OSC7501_TITLE` is not a mode. It sets the title on the RSpec records and
defaults to `RSpec`. `rake-osc7501` passes `RSPEC_OSC7501`, `RSPEC_OSC7501_TITLE`
and `TERM` to the RSpec child. It does not pass `RAKE_OSC7501`, so set
`RSPEC_OSC7501` directly to change the child's mode.

To inspect the records in a pipe:

```sh
RAKE_OSC7501=force RSPEC_OSC7501=force THOR_OSC7501=force RUBOCOP_OSC7501=force bundle exec rake | cat -v
```

## Verification

`test/demo_test.rb` runs the default task with every adapter forced. It checks
the emitted records and the ordinary output, that a failing spec stops later
phases, that a failing Thor command stops RuboCop, and that `auto` mode emits
nothing on a `dumb` terminal or when output is redirected. `test/thor_test.rb`
forces Thor and checks that `demo:prompt` reports blocked before its done
record and that `demo:failure` reports an error record and exits nonzero.

```sh
bundle exec ruby test/demo_test.rb
bundle exec ruby test/thor_test.rb
```

The tests assert the bytes each adapter writes. They do not observe rendering in
a terminal that supports OSC 7501.
