module Commands
  # Colours a specific pixel in a matrix
  class Colour
    def initialize(matrix)
      @matrix = matrix
    end

    def run(row_index, column_index, colour)
      @matrix[row_index, column_index] = colour
      @matrix
    end
  end
end
