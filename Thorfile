require "thor/osc7501"

class Demo < Thor
  desc "perform", "Run the Thor demo"
  def perform
    sleep 0.5
    say "Thor demo complete"
  end
  desc "prompt", "Ask for a name"
  def prompt
    name = ask("Name?")
    say "Hello, #{name}!"
  end

  desc "failure", "Raise an intentional error"
  def failure
    raise "Intentional failure"
  end
end
