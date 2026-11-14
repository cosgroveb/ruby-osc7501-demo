require_relative "../demo/example"

RSpec.describe Example do
  it "greets by name" do
    sleep 0.5
    expect(Example.greeting("Ruby")).to eq("Hello, Ruby!")
  end
end
