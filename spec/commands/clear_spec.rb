require "spec_helper"

RSpec.describe Commands::Clear do
  subject(:command) { described_class.new(bitmap) }

  let(:bitmap) do
    Array.new(row_count) do
      Array.new(column_count) { "O" }
    end
  end

  let(:column_count) { 3 }
  let(:row_count) { 2 }

  describe "#run" do
    it "returns a Bitmap populated with the correct values" do
      expect(command.run.to_a).to eq([["O", "O", "O"], ["O", "O", "O"]])
    end
  end
end
