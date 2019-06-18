module Commands
  # Re initializes all values of an existing matrix
  class Clear
    def initialize(matrix)
      @matrix = matrix
    end

    def run
      row_count = @matrix.row_count
      column_count = @matrix.column_count

      Initialize.new(row_count, column_count).run
    end
  end
end
