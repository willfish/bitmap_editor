require "spec_helper"

RSpec.describe Commands::SurroundPixel do
  subject(:command) { described_class.new(bitmap) }

  let(:bitmap) do
    Array.new(row_count) do
      Array.new(column_count) { "O" }
    end
  end

  let(:row_count) { 5 }
  let(:column_count) { 5 }

  describe "#run" do
    let(:colour) { "W" }

    context "when some of the pixels being coloured are below the minimum boundary condition" do
      let(:row_index) { 1 }
      let(:column_index) { 0 }

      it "colours the correct surrounding pixels" do
        result = command.run(row_index, column_index, colour)

        expected = [
          %w[W W O O O],
          %w[O W O O O],
          %w[W W O O O],
          %w[O O O O O],
          %w[O O O O O]
        ]

        expect(result.to_a).to eq(expected)
      end
    end

    context "when some of the pixels being coloured are above the maximum boundary condition" do
      let(:row_index) { 4 }
      let(:column_index) { 2 }

      it "colours the correct surrounding pixels" do
        result = command.run(row_index, column_index, colour)

        expected = [
          %w[O O O O O],
          %w[O O O O O],
          %w[O O O O O],
          %w[O W W W O],
          %w[O W O W O]
        ]

        expect(result.to_a).to eq(expected)
      end
    end

    context "when all pixels being coloured are within our boundaries" do
      let(:column_index) { 2 }
      let(:row_index) { 2 }

      it "colours the correct surrounding pixels" do
        result = command.run(row_index, column_index, colour)

        expected = [
          %w[O O O O O],
          %w[O W W W O],
          %w[O W O W O],
          %w[O W W W O],
          %w[O O O O O]
        ]

        expect(result.to_a).to eq(expected)
      end
    end
  end
end
