require "rails_helper"

RSpec.describe Concerns::IdentifiableComponent do
  let(:test_class) do
    Class.new do
      include Concerns::IdentifiableComponent

      def self.name
        "Test::MockComponent"
      end
    end
  end

  let(:instance) { test_class.new }

  describe ".id_prefix" do
    it "generates prefix for id from class name" do
      expect(test_class.id_prefix).to eq "test_mock_component"
    end
  end

  describe ".testid_prefix" do
    it "is identical with id_prefix" do
      expect(test_class.testid_prefix).to eq test_class.id_prefix
    end
  end

  describe "#id" do
    it "starts with the class name" do
      expect(instance.id).to start_with("test_mock_component")
    end

    it "generates the same id when called multiple times" do
      id = instance.id

      expect(instance.id).to eq id
    end

    context "when id includes invalid character" do
      before do
        allow(instance).to receive(:uniq_key).and_return("[")
      end

      it "raises RuntimeError" do
        expect do
          instance.id
        end.to raise_error RuntimeError
      end
    end

    context "when id starts with number" do
      before do
        allow(instance).to receive(:id_prefix).and_return("0")
      end

      it "raises RuntimeError" do
        expect do
          instance.id
        end.to raise_error RuntimeError
      end
    end

    context "when Rails.env is not local" do
      before do
        allow(Rails.env).to receive(:local?).and_return(false)
        allow(instance).to receive(:id_prefix).and_return("0")
      end

      it "does not raise error" do
        expect do
          instance.id
        end.not_to raise_error
      end
    end

    context "when creating multiple instances" do
      it "generates unique ids" do
        one = test_class.new
        another = test_class.new

        expect(one).not_to eq another
      end
    end
  end

  describe "#testid" do
    it "is identical with id" do
      id = instance.id

      expect(instance.testid).to eq id
    end
  end

  context "when uniq_key is overridden" do
    let(:test_class) do
      Class.new do
        include Concerns::IdentifiableComponent

        def uniq_key
          "foo"
        end
      end
    end

    it "ends with the uniq_key" do
      expect(instance.id).to end_with "foo"
    end
  end
end
