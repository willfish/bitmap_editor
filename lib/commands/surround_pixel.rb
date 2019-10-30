require_relative "colour"

module Commands
  # Surround the specified pixel with a specified colour
  class SurroundPixel
    MIN_ROW_AND_COLUMN_SIZE = 0

    def initialize(bitmap)
      @bitmap = bitmap
    end

    def run(row_index, column_index, colour)
      row_count = @bitmap.size - 1
      column_count = @bitmap.first.size - 1

      central_pixel = [row_index, column_index]
      surrounding_rows = (row_index - 1)..(row_index + 1)
      surrounding_columns = (column_index - 1)..(column_index + 1)
      surrounding_pixels = surrounding_rows.to_a.product(surrounding_columns.to_a)
      surrounding_pixels.delete(central_pixel)

      surrounding_pixels.each do |x, y|
        next if x < MIN_ROW_AND_COLUMN_SIZE || y < MIN_ROW_AND_COLUMN_SIZE
        next if x > row_count || y > column_count

        Commands::Colour.new(@bitmap).run(x, y, colour)
      end

      @bitmap
    end
  end
end
