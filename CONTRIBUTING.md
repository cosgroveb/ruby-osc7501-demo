# Contributing

Follow the [code of conduct](CODE_OF_CONDUCT.md). Report vulnerabilities through
the private channel in [SECURITY.md](SECURITY.md).

AI-assisted contributions are welcome. Before requesting review, understand
the changes, run relevant checks, and verify claims in code, documentation,
and reports. State what you tested and what remains uncertain. Be prepared to
explain your choices and address feedback. When using an agent to help answer
a reviewer, check the answer and send only what is relevant.

Use MRI Ruby 3.4, then run the checks CI runs:

```sh
bundle install
bundle exec rubocop
bundle exec ruby test/demo_test.rb
bundle exec ruby test/thor_test.rb
```

The tests run the demo in subprocesses and check the bytes each adapter writes.
Keep `Gemfile.lock` committed. It pins the gem versions the README describes.
Behavior changes in an adapter belong in that gem's repository.
