require "matrix"
require_relative "commands"

class BitmapEditor
  # The bitmap protocol specifies that the first element (row or column) of
  # the matrix starts at 1 whereas a ruby matrix starts at 0
  #
  # We therefore subtract 1 from the row and column indexes to transparently
  # match the matrix standard.
  BITMAP_TO_ARRAY_OFFSET = 1
  MIN_BITMAP_COLUMN_AND_ROW_SIZE = 1
  MAX_BITMAP_COLUMN_AND_ROW_SIZE = 250

  def initialize
    @matrix = nil
  end

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    File.open(file).each do |line|
      line = line.chomp
      case line
      when /^I (\d+) (\d+)$/
        initialize_matrix($1, $2)
      when "C"
        clear_matrix
      when 'S'
        puts "There is no image"
      else
        puts 'unrecognised command :('
      end
    end
  end

  private

  def initialize_matrix(column_count, row_count)
    column_count = Integer(column_count)
    row_count = Integer(row_count)

    if valid_matrice?(column_count, row_count)
      puts "Initializing image too large"
    else
      @matrix = Commands::Initialize.new(row_count, column_count).run
    end
  end

  def clear_matrix
    if @matrix
      @matrix = Commands::Clear.new(@matrix).run
    else
      puts "image matrix not initialized"
    end
  end

  def valid_matrice?(column_count, row_count)
    [column_count, row_count].any? do |count|
      count > MAX_BITMAP_COLUMN_AND_ROW_SIZE
    end
  end
end
