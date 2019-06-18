module Commands
  # Draw a vertical line through a specific column
  # with a specific colour between two rows inclusive
  # of the last row.
  class VerticalSegment
    def initialize(matrix)
      @matrix = matrix
    end

    def run(column_index, row_start_index, row_end_index, colour)
      row_range = row_start_index..row_end_index

      row_range.each do |row_index|
        @matrix[row_index, column_index] = colour
      end

      @matrix
    end
  end
end
