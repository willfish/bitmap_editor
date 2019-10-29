module Commands
  # Re initializes all values of an existing bitmap
  class Clear
    def initialize(bitmap)
      @bitmap = bitmap
    end

    def run
      row_count = @bitmap.row_count
      column_count = @bitmap.column_count

      Initialize.new(row_count, column_count).run
    end
  end
end
