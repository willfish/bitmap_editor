module Helpers
  def fixture_path(fixture_file)
    relative_dir = File.expand_path(__dir__)

    File.join(relative_dir, "fixtures", fixture_file)
  end
end
