require "spec_helper"

RSpec.describe Commands::Initialize do
  subject(:command) { described_class.new(row_size, column_size) }

  let(:row_size) { 3 }
  let(:column_size) { 2 }

  describe "#run" do
    it "returns a Matrix populated with the correct values" do
      expected = [
        ["O", "O"],
        ["O", "O"],
        ["O", "O"],
      ]

      expect(command.run.to_a).to eq(expected)
    end
  end
end
