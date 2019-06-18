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

  end
end
