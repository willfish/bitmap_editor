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
      when /^L (\d+) (\d+) ([A-Z])$/
        colour_pixel($1, $2, $3)
      when /^V (\d+) (\d+) (\d+) ([A-Z])$/
        colour_vertical_segment($1, $2, $3, $4)
      when /^H (\d+) (\d+) (\d+) ([A-Z])$/
        colour_horizontal_segment($1, $2, $3, $4)
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

  def colour_pixel(row_index, column_index, colour)
    if @matrix
      row_index = Integer(row_index)
      column_index = Integer(column_index)

      if out_of_bounds?(row_index, column_index)
        puts "can't colour elements which are out of bounds"
      else
        row_index = Integer(row_index) - BITMAP_TO_ARRAY_OFFSET
        column_index = Integer(column_index) - BITMAP_TO_ARRAY_OFFSET

        Commands::Colour.new(@matrix).run(row_index, column_index, colour)
      end
    else
      puts "image matrix not initialized"
    end
  end

  def colour_vertical_segment(column_index, row_start_index, row_end_index, colour)
    column_index = Integer(column_index)
    row_start_index = Integer(row_start_index)
    row_end_index = Integer(row_end_index)

    if @matrix
      out_of_bounds =
        out_of_bounds?(row_start_index, column_index) ||
        out_of_bounds?(row_end_index, column_index)

      if out_of_bounds
        puts "can't colour elements which are out of bounds"
      else
        column_index = column_index - BITMAP_TO_ARRAY_OFFSET
        row_start_index = row_start_index - BITMAP_TO_ARRAY_OFFSET
        row_end_index = row_end_index - BITMAP_TO_ARRAY_OFFSET

        Commands::VerticalSegment.new(@matrix).run(
          column_index,
          row_start_index,
          row_end_index,
          colour,
        )
      end
    else
      puts "image matrix not initialized"
    end
  end

  def colour_horizontal_segment(column_start_index, column_end_index, row_index, colour)
    row_index = Integer(row_index)
    column_start_index = Integer(column_start_index)
    column_end_index = Integer(column_end_index)

    if @matrix
      out_of_bounds =
        out_of_bounds?(row_index, column_start_index) ||
        out_of_bounds?(row_index, column_end_index)

      if out_of_bounds
        puts "can't colour elements which are out of bounds"
      else
        row_index = row_index - BITMAP_TO_ARRAY_OFFSET
        column_start_index = column_start_index - BITMAP_TO_ARRAY_OFFSET
        column_end_index = column_end_index - BITMAP_TO_ARRAY_OFFSET

        Commands::HorizontalSegment.new(@matrix).run(
          row_index,
          column_start_index,
          column_end_index,
          colour,
        )
      end
    else
      puts "image matrix not initialized"
    end
  end

  def valid_matrice?(column_count, row_count)
    [column_count, row_count].any? do |count|
      count > MAX_BITMAP_COLUMN_AND_ROW_SIZE
    end
  end

  def out_of_bounds?(row_index, column_index)
    row_count = @matrix.row_count
    column_count = @matrix.column_count

    row_index > row_count ||
      column_index > column_count ||
      row_index < MIN_BITMAP_COLUMN_AND_ROW_SIZE ||
      column_index < MIN_BITMAP_COLUMN_AND_ROW_SIZE
  end
end

class Matrix
  # Having to Monkey patch the matrix class as it doesn't
  # provide public interface for setting the value of specific column values
  # in specific rows.
  #
  # https://github.com/ruby/ruby/blob/ruby_2_3/lib/matrix.rb#L379-L384
  def []=(i, j, v)
    @rows[i][j] = v
  end
end
