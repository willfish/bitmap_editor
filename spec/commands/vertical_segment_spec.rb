require "spec_helper"

RSpec.describe Commands::VerticalSegment do
  subject(:command) { described_class.new(bitmap) }

  let(:bitmap) do
    Array.new(row_count) do
      Array.new(column_count) { "O" }
    end
  end

  let(:row_count) { 5 }
  let(:column_count) { 5 }

  describe "#run" do
    let(:column_index) { 2 }
    let(:row_start_index) { 2 }
    let(:row_end_index) { 3 }
    let(:colour) { "W" }

    it "colours a specific vertical segment" do
      result = command.run(
        column_index, row_start_index, row_end_index, colour
      )

      expected = [
        ["O", "O", "O", "O", "O"],
        ["O", "O", "O", "O", "O"],
        ["O", "O", "W", "O", "O"],
        ["O", "O", "W", "O", "O"],
        ["O", "O", "O", "O", "O"],
      ]

      expect(result.to_a).to eq(expected)
    end
  end
end
