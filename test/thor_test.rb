# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'

class ThorTest < Minitest::Test
  def test_prompt_reports_blocked_then_done
    output, status = Open3.capture2e({ 'THOR_OSC7501' => 'force' }, 'bundle', 'exec', 'thor', 'demo:prompt',
                                     stdin_data: "Ruby\n")
    assert status.success?, output
    assert_includes output, 'Hello, Ruby!'
    assert_match(/app=thor:.*state=blocked/, output)
    assert_match(/app=thor:.*state=done/, output)
  end

  def test_failure_reports_error_and_exits_nonzero
    output, status = Open3.capture2e({ 'THOR_OSC7501' => 'force' }, 'bundle', 'exec', 'thor', 'demo:failure')
    refute status.success?, output
    assert_includes output, 'Intentional failure'
    assert_match(/app=thor:.*state=error/, output)
  end
end
