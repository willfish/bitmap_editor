require "spec_helper"

RSpec.describe Commands::Clear do
  subject(:command) { described_class.new(matrix) }

  let(:matrix) { Matrix.build(row_count, column_count) { "O" } }

  let(:column_count) { 3 }
  let(:row_count) { 2 }

  describe "#run" do
    it "returns a Matrix populated with the correct values" do
      expect(command.run.to_a).to eq([["O", "O", "O"], ["O", "O", "O"]])
    end
  end
end
