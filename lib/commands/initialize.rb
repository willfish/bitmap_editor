module Commands
  # Initializes a new bitmap with the default colour
  class Initialize
    DEFAULT_COLOUR = "O".freeze

    def initialize(row_count, column_count)
      @row_count = row_count
      @column_count = column_count
    end

    def run
      Array.new(@row_count) do
        Array.new(@column_count) { DEFAULT_COLOUR }
      end
    end
  end
end
