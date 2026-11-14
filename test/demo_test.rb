require "minitest/autorun"
require "open3"
require "fileutils"
require "tmpdir"

class DemoTest < Minitest::Test
  FORCE = %w[RAKE RSPEC THOR RUBOCOP].to_h { |name| ["#{name}_OSC7501", "force"] }.freeze

  def run_demo(env = {})
    Open3.capture2e(FORCE.merge(env), "bundle", "exec", "rake")
  end

  def frames(output)
    output.scan(/\e\]7501;([^\e]*)\e\\/).flatten.map do |frame|
      frame.split(":").to_h { |field| field.split("=", 2) }
    end
  end

  def in_copy
    Dir.mktmpdir do |dir|
      FileUtils.cp_r(%w[Gemfile Gemfile.lock Rakefile Thorfile .rubocop.yml demo spec], dir)
      Dir.chdir(dir) { yield }
    end
  end

  def test_default_reports_each_phase_and_keeps_ordinary_output
    output, status = run_demo
    assert status.success?, output
    assert_includes output, "1 example, 0 failures"
    assert_includes output, "Thor demo complete"
    assert_includes output, "1 file inspected, no offenses detected"

    records = frames(output)
    completed = records.select { |frame| frame["state"] == "done" }
    assert_equal %w[rspec rake thor rubocop], completed.map { |frame| frame["app"] }
    assert_match(%r{\Arake-.+/rspec-1\z}, completed.first.fetch("id"))
    assert_equal %w[rake rspec thor rubocop], records.map { |frame| frame["app"] }.uniq
  end

  def test_failing_spec_stops_later_phases
    in_copy do
      File.write("spec/failure_spec.rb", "RSpec.describe('failure') { it('fails') { expect(1).to eq(2) } }\n")
      output, status = run_demo
      refute status.success?, output
      assert_includes output, "1 failure"
      assert_equal %w[rspec rake], frames(output).select { |frame| frame["state"] == "error" }.map { |frame| frame["app"] }
      refute_includes output, "Thor demo complete"
      refute_includes output, "Inspecting 1 file"
    end
  end

  def test_failing_thor_stops_rubocop
    in_copy do
      File.write("Thorfile", File.read("Thorfile").sub('say "Thor demo complete"', 'raise "Thor failure"'))
      output, status = run_demo
      refute status.success?, output
      assert_includes output, "Thor failure"
      assert frames(output).any? { |frame| frame["app"] == "thor" && frame["state"] == "error" }
      refute_includes output, "Inspecting 1 file"
    end
  end

  def test_auto_mode_is_silent_on_a_dumb_terminal
    env = FORCE.transform_values { "auto" }.merge("TERM" => "dumb")
    output, status = Open3.capture2e(env, "script", "-q", "-e", "-c", "bundle exec rake", "/dev/null")
    assert status.success?, output
    assert_empty frames(output)
    assert_includes output, "Thor demo complete"
  end

  def test_auto_mode_is_silent_when_redirected
    output, status = run_demo(FORCE.transform_values { "auto" }.merge("TERM" => "xterm"))
    assert status.success?, output
    assert_empty frames(output)
    assert_includes output, "Thor demo complete"
  end
end
