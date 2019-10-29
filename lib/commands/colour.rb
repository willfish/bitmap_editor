module Commands
  # Colours a specific pixel in a bitmap
  class Colour
    def initialize(bitmap)
      @bitmap = bitmap
    end

    def run(row_index, column_index, colour)
      @bitmap[row_index][column_index] = colour
      @bitmap
    end
  end
end
