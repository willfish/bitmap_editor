require "spec_helper"

RSpec.describe BitmapEditor do
  subject(:bitmap_editor) { described_class.new }

  let(:file) { fixture_path("commands_provided.txt") }

  it "returns the correct output" do
    expected = <<~EXPECTED
      OOAOO
      OOZZZ
      OWOOO
      OWOOO
      OWOSS
      OWOSO
    EXPECTED

    expect { bitmap_editor.run(file) }.to output(expected).to_stdout
  end
end
