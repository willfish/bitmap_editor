require "spec_helper"

RSpec.describe BitmapEditor do
  subject(:bitmap_editor) { described_class.new }

  describe "#run" do
    context "when the file is nil" do
      let(:file) { nil }

      it "returns a message to the user" do
        expect { bitmap_editor.run(file) }.
          to output("please provide correct file\n").to_stdout
      end
    end

    context "when the file does not exist" do
      let(:file) { "foo" }

      it "returns a message to the user" do
        expect { bitmap_editor.run(file) }.
          to output("please provide correct file\n").to_stdout
      end
    end

    context "when the command is unrecognised" do
      let(:file) { fixture_path("unrecognised.txt") }

      it "returns a message to the user" do
        expect { bitmap_editor.run(file) }.
          to output("unrecognised command :(\n").to_stdout
      end
    end

    context "when the file contains I N M" do
      context "when N or M exceed 250" do
        let(:file) { fixture_path("command_initialize_exceeds_maximum.txt") }

        it "returns a message to the user" do
          expect { bitmap_editor.run(file) }.
            to output("Initializing image too large\n").to_stdout
        end
      end

      context "when N or M do not exceed 250" do
        let(:file) { fixture_path("command_initialize.txt") }
        let(:command) { double.as_null_object }

        it "generates an Initialize command" do
          allow(Commands::Initialize).
            to receive(:new).and_return(command)

          bitmap_editor.run(file)

          expect(command).to have_received(:run)
        end
      end
    end

    context "when the file contains C" do
      context "when a matrix does not exist to clear" do
        let(:file) { fixture_path("command_clear.txt") }

        it "returns a message to the user" do
          expect { bitmap_editor.run(file) }.
            to output("image matrix not initialized\n").to_stdout
        end
      end

      context "when a matrix exists to clear" do
        let(:file) { fixture_path("commands_initialize_and_clear.txt") }
        let(:command) { double.as_null_object }

        it "generates a Clear command" do
          allow(Commands::Clear).
            to receive(:new).and_return(command)

          bitmap_editor.run(file)

          expect(command).to have_received(:run)
        end
      end
    end

    context "when the file contains L X Y C" do
      context "when the input colour is lower case" do
        let(:file) { fixture_path("command_colour_lower_case_colour.txt") }

        it "returns a message to the user" do
          expect { bitmap_editor.run(file) }.
            to output("unrecognised command :(\n").to_stdout
        end
      end

      context "when a matrix does not exist to colour" do
        let(:file) { fixture_path("command_colour.txt") }

        it "returns a message to the user" do
          expect { bitmap_editor.run(file) }.
            to output("image matrix not initialized\n").to_stdout
        end
      end

      context "when a matrix exists to colour" do
        let(:file) { fixture_path("commands_initialize_and_colour.txt") }
        let(:command) { double.as_null_object }

        it "generates a Colour command" do
          allow(Commands::Colour).
            to receive(:new).with(an_instance_of(Matrix)).and_return(command)

          bitmap_editor.run(file)

          expect(command).to have_received(:run)
        end
      end

      context "when the element we're colouring is out of bounds" do
        let(:file) do
          fixture_path("commands_initialize_and_colour_out_of_bounds.txt")
        end

        it "returns a message to the user" do
          expect { bitmap_editor.run(file) }.
            to output("can't colour elements which are out of bounds\n").to_stdout
        end
      end
    end

    context "when the file contains V X Y1 Y2 C" do
      context "when a matrix does not exist to colour vertically" do
        let(:file) { fixture_path("command_vertical_segment.txt") }

        it "returns a message to the user" do
          expect { bitmap_editor.run(file) }.
            to output("image matrix not initialized\n").to_stdout
        end
      end

      context "when a matrix exists to colour vertically" do
        let(:file) { fixture_path("commands_initialize_and_colour_vertically.txt") }
        let(:command) { double.as_null_object }

        it "generates a VerticalSegment command" do
          allow(Commands::VerticalSegment).
            to receive(:new).with(an_instance_of(Matrix)).and_return(command)

          bitmap_editor.run(file)

          expect(command).to have_received(:run)
        end
      end
    end

    context "when the file contains H X1 X2 Y C" do
      context "when the image has not yet been initialised" do
        let(:file) { fixture_path("command_horizontal_segment.txt") }

        it "returns a message to the user" do
          expect { bitmap_editor.run(file) }.
            to output("image matrix not initialized\n").to_stdout
        end
      end

      context "when a matrix exists to colour vertically" do
        let(:file) { fixture_path("commands_initialize_and_colour_horizontally.txt") }
        let(:command) { double.as_null_object }

        it "generates a VerticalSegment command" do
          allow(Commands::HorizontalSegment).
            to receive(:new).with(an_instance_of(Matrix)).and_return(command)

          bitmap_editor.run(file)

          expect(command).to have_received(:run)
        end
      end
    end

  end
end
