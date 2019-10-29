require_relative "commands"

class BitmapEditor
  # The bitmap protocol specifies that the first element (row or column) of
  # the bitmap starts at 1 whereas a ruby Array starts at 0
  #
  # We therefore subtract 1 from the row and column indexes to transparently
  # match the bitmap protocol.
  BITMAP_TO_ARRAY_OFFSET = 1
  MIN_BITMAP_COLUMN_AND_ROW_SIZE = 1
  MAX_BITMAP_COLUMN_AND_ROW_SIZE = 250

  def initialize
    @bitmap = nil
  end

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    File.open(file).each do |line|
      line = line.chomp
      case line
      when /^I (\d+) (\d+)$/
        initialize_bitmap($1, $2)
      when "C"
        clear_bitmap
      when /^L (\d+) (\d+) ([A-Z])$/
        colour_pixel($1, $2, $3)
      when /^V (\d+) (\d+) (\d+) ([A-Z])$/
        colour_vertical_segment($1, $2, $3, $4)
      when /^H (\d+) (\d+) (\d+) ([A-Z])$/
        colour_horizontal_segment($1, $2, $3, $4)
      when /^U (\d+) (\d+) ([A-Z])$/
        surround_pixel($1, $2, $3)
      when "S"
        show
      else
        puts 'unrecognised command :('
      end
    end
  end

  private

  def initialize_bitmap(column_count, row_count)
    column_count = Integer(column_count)
    row_count = Integer(row_count)

    if valid_matrice?(column_count, row_count)
      puts "Initializing image too large"
    else
      @bitmap = Commands::Initialize.new(row_count, column_count).run
    end
  end

  def clear_bitmap
    if @bitmap
      @bitmap = Commands::Clear.new(@bitmap).run
    else
      puts "image bitmap not initialized"
    end
  end

  def colour_pixel(row_index, column_index, colour)
    if @bitmap
      row_index = Integer(row_index)
      column_index = Integer(column_index)

      if out_of_bounds?(row_index, column_index)
        puts "can't colour elements which are out of bounds"
      else
        row_index = Integer(row_index) - BITMAP_TO_ARRAY_OFFSET
        column_index = Integer(column_index) - BITMAP_TO_ARRAY_OFFSET

        Commands::Colour.new(@bitmap).run(row_index, column_index, colour)
      end
    else
      puts "image bitmap not initialized"
    end
  end

  def colour_vertical_segment(column_index, row_start_index, row_end_index, colour)
    column_index = Integer(column_index)
    row_start_index = Integer(row_start_index)
    row_end_index = Integer(row_end_index)

    if @bitmap
      out_of_bounds =
        out_of_bounds?(row_start_index, column_index) ||
        out_of_bounds?(row_end_index, column_index)

      if out_of_bounds
        puts "can't colour elements which are out of bounds"
      else
        column_index = column_index - BITMAP_TO_ARRAY_OFFSET
        row_start_index = row_start_index - BITMAP_TO_ARRAY_OFFSET
        row_end_index = row_end_index - BITMAP_TO_ARRAY_OFFSET

        Commands::VerticalSegment.new(@bitmap).run(
          column_index,
          row_start_index,
          row_end_index,
          colour,
        )
      end
    else
      puts "image bitmap not initialized"
    end
  end

  def colour_horizontal_segment(column_start_index, column_end_index, row_index, colour)
    row_index = Integer(row_index)
    column_start_index = Integer(column_start_index)
    column_end_index = Integer(column_end_index)

    if @bitmap
      out_of_bounds =
        out_of_bounds?(row_index, column_start_index) ||
        out_of_bounds?(row_index, column_end_index)

      if out_of_bounds
        puts "can't colour elements which are out of bounds"
      else
        row_index = row_index - BITMAP_TO_ARRAY_OFFSET
        column_start_index = column_start_index - BITMAP_TO_ARRAY_OFFSET
        column_end_index = column_end_index - BITMAP_TO_ARRAY_OFFSET

        Commands::HorizontalSegment.new(@bitmap).run(
          row_index,
          column_start_index,
          column_end_index,
          colour,
        )
      end
    else
      puts "image bitmap not initialized"
    end
  end

  def surround_pixel(row_index, column_index, colour)
    row_index = Integer(row_index)
    column_index = Integer(column_index)

    if @bitmap
      if out_of_bounds?(row_index, column_index)
        puts "can't colour elements which are out of bounds"
      else
        row_index = Integer(row_index) - BITMAP_TO_ARRAY_OFFSET
        column_index = Integer(column_index) - BITMAP_TO_ARRAY_OFFSET

        Commands::SurroundPixel.new(@bitmap).run(row_index, column_index, colour)
      end
    else
      puts "There is no image"
    end
  end

  def show
    if @bitmap
      Commands::Show.new(@bitmap).run
    else
      puts "There is no image"
    end
  end

  def valid_matrice?(column_count, row_count)
    [column_count, row_count].any? do |count|
      count > MAX_BITMAP_COLUMN_AND_ROW_SIZE
    end
  end

  def out_of_bounds?(row_index, column_index)
    row_count = @bitmap.size
    column_count = @bitmap[0].size

    row_index > row_count ||
      column_index > column_count ||
      row_index < MIN_BITMAP_COLUMN_AND_ROW_SIZE ||
      column_index < MIN_BITMAP_COLUMN_AND_ROW_SIZE
  end
end
