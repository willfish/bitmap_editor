require "pry"

module Commands
  class Show
    def initialize(bitmap)
      @bitmap = bitmap
    end

    def run
      output = @bitmap.map do |row|
        row.join("")
      end.join("\n")

      puts output
    end
  end
end
