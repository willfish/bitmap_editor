require "spec_helper"

RSpec.describe Commands::Show do
  subject(:command) { described_class.new(bitmap) }

  let(:bitmap) do
    Array.new(row_count) do
      Array.new(column_count) { "O" }
    end
  end

  let(:column_count) { 3 }
  let(:row_count) { 2 }

  describe "#run" do
    it "outputs the correct bitmap" do
      expected = <<~EXPECTED
        OOO
        OOO
      EXPECTED

      expect { command.run }.to output(expected).to_stdout
    end
  end
end
