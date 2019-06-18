module Commands
  class Show
    def initialize(matrix)
      @matrix = matrix
    end

    def run
      output = @matrix.to_a.map do |row|
        row.join("")
      end.join("\n")

      puts output
    end
  end
end
