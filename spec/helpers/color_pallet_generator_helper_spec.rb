require "rails_helper"

# Specs in this file have access to a helper object that includes
# the ColorPalletGeneratorHelper. For example:
#
# describe ColorPalletGeneratorHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ColorPalletGeneratorHelper, type: :helper do
  describe "#color_table" do
    it "is a Hash" do
      expect(helper.color_table).to be_a Hash
    end

    specify "all keys are String" do
      expect(helper.color_table.keys).to all(be_a String)
    end

    specify "all values are String and begin with '#'" do
      expect(helper.color_table.values).to all(be_a String).and all(start_with("#"))
    end

    specify "all values are hex" do
      expect(helper.color_table.values).to all(match(/\A#[0-9a-f]{6}\z/))
    end
  end

  describe "#color_values" do
    it "accepts name and returns all colors of that name" do
      expect(helper.color_values("red")).to be_an Array
    end

    it "returns value in hex" do
      expect(helper.color_values("red")).to all(start_with("#"))
    end

    it "accepts optional from: and to: arguments" do
      expect { helper.color_values("red", from: 50, to: 100) }.not_to raise_error
    end

    it "returns all 11 colors" do
      expect(helper.color_values("red").count).to eq 11
    end

    context "when from is given" do
      it "returns a higher range of values" do
        expect(helper.color_values("red", from: 900)).to contain_exactly("#82181a", "#460809")
      end
    end

    context "when to is given" do
      it "returns a lower range of values" do
        expect(helper.color_values("red", to: 100)).to contain_exactly("#fef2f2", "#ffe2e2")
      end
    end

    context "when from is smaller than to" do
      it "returns sorted values" do
        expect(helper.color_values("red", from: 50, to: 100)).to contain_exactly("#fef2f2", "#ffe2e2")
      end
    end

    context "when to is smaller than from" do
      it "returns reverse-sorted values" do
        expect(helper.color_values("red", from: 100, to: 50)).to contain_exactly("#ffe2e2", "#fef2f2")
      end
    end

    context "when number is given" do
      it "returns a single value" do
        expect(helper.color_values("red", number: 100)).to eq ["#ffe2e2"]
      end
    end

    context "when numbers is given" do
      it "returns specified numbers" do
        expect(helper.color_values("red", numbers: [100, 200])).to contain_exactly("#ffe2e2", "#ffc9c9")
      end
    end
  end

  describe "#color_names" do
    it "returns an array of color names" do
      expect(helper.color_names).to all(be_a String)
    end

    context "when a color name that does not exist in the table is given" do
      it "does not raise error" do
        expect { helper.color_names(except: ["white"]) }.not_to raise_error
      end
    end

    context "when except is given" do
      it "returns names except the given color name" do
        expect(helper.color_names(except: %w[red sky])).not_to include("red", "sky")
      end
    end
  end
end
