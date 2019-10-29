require "spec_helper"

RSpec.describe Commands::HorizontalSegment do
  subject(:command) { described_class.new(bitmap) }

  let(:bitmap) do
    Array.new(row_count) do
      Array.new(column_count) { "O" }
    end
  end

  let(:row_count) { 5 }
  let(:column_count) { 5 }

  describe "#run" do
    let(:row_index) { 2 }
    let(:column_start_index) { 1 }
    let(:column_end_index) { 3 }
    let(:colour) { "W" }

    it "colours a specific horizontal segment" do
      result = command.run(
        row_index, column_start_index, column_end_index, colour
      )

      expected = [
        ["O", "O", "O", "O", "O"],
        ["O", "O", "O", "O", "O"],
        ["O", "W", "W", "W", "O"],
        ["O", "O", "O", "O", "O"],
        ["O", "O", "O", "O", "O"],
      ]

      expect(result.to_a).to eq(expected)
    end
  end
end
