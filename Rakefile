require "rake"

task :default do
  sh "bundle", "exec", "rake", "--rakefile", "demo/Rakefile"
  sh "bundle", "exec", "thor", "demo:perform"
  sh "bundle", "exec", "rubocop", "--no-server", "--require", "rubocop/osc7501",
     "--format", "progress", "--format", "RuboCop::OSC7501::Formatter", "demo/example.rb"
end
