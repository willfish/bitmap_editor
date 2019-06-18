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
  end
end
