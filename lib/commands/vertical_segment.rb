module Commands
  # Draw a vertical line through a specific column
  # with a specific colour between two rows inclusive
  # of the last row.
  class VerticalSegment
    def initialize(bitmap)
      @bitmap = bitmap
    end

    def run(column_index, row_start_index, row_end_index, colour)
      row_range = row_start_index..row_end_index

      row_range.each do |row_index|
        @bitmap[row_index][column_index] = colour
      end

      @bitmap
    end
  end
end
