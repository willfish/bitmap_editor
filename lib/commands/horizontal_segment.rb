module Commands
  # Draw a horizontal line through a specific row
  # with a specific colour between two columns inclusive
  # of the last one.
  class HorizontalSegment
    def initialize(matrix)
      @matrix = matrix
    end

    def run(row_index, column_start_index, column_end_index, colour)
      column_range = column_start_index..column_end_index

      column_range.each do |column_index|
        @matrix[row_index, column_index] = colour
      end

      @matrix
    end
  end
end
