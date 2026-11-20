# Accessibility

Read the demo's output without relying on terminal status indicators. RSpec,
Thor and RuboCop keep their ordinary output and errors available as text.

## Plain text output

Turn off status reporting for every phase:

```sh
RAKE_OSC7501=off RSPEC_OSC7501=off THOR_OSC7501=off RUBOCOP_OSC7501=off bundle exec rake
```

Each variable turns off one adapter. By default, the adapters send no status
records to pipes, files, or terminals with `TERM=dumb`.

## Environments and limits

CI tests the demo with Ruby 3.4. Terminal status requires an OSC 7501-capable terminal.
The adapters check for a TTY and honor `TERM=dumb` but do not detect OSC support.

Your terminal controls display and announcements. I have not tested the status
display with screen readers. Your screen reader may need additional settings.

## Report a barrier

Open an [issue](https://github.com/cosgroveb/ruby-osc7501-demo/issues) describing
what you tried, what prevented you from using it, and what would help. Include
your terminal, operating system, and assistive technology versions when
relevant. You do not need to disclose a disability or other medical information.
