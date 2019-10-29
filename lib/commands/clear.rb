module Commands
  # Re initializes all values of an existing bitmap
  class Clear
    def initialize(bitmap)
      @bitmap = bitmap
    end

    def run
      row_count = @bitmap.size
      column_count = @bitmap.first.size

      Initialize.new(row_count, column_count).run
    end
  end
end
