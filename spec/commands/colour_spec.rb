require "spec_helper"

RSpec.describe Commands::Colour do
  subject(:command) { described_class.new(matrix) }

  let(:matrix) { Matrix.build(row_count, column_count) { "O" } }
  let(:row_count) { 2 }
  let(:column_count) { 3 }
  let(:row_index) { 1 }
  let(:column_index) { 2 }
  let(:colour) { "W" }

  describe "#run" do
    it "colours a specific pixel" do
      result = subject.run(row_index, column_index, colour)
      expected = [
        ["O", "O", "O"],
        ["O", "O", "W"]
      ]
      expect(result.to_a).to eq(expected)
    end
  end
end
