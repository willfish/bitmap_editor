require "spec_helper"

RSpec.describe Commands::Show do
  subject(:command) { described_class.new(matrix) }

  let(:matrix) { Matrix.build(row_count, column_count) { "O" } }

  let(:column_count) { 3 }
  let(:row_count) { 2 }

  describe "#run" do
    it "outputs the correct matrix" do
      expected = <<~EXPECTED
        OOO
        OOO
      EXPECTED

      expect { command.run }.to output(expected).to_stdout
    end
  end
end
