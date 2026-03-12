module Concerns
  # A concern to provide unique component id and testid.
  #
  # Override uniq_key with something unique, such as dom_id(model_instance).
  module IdentifiableComponent
    extend ActiveSupport::Concern

    class_methods do
      def id_prefix
        class_name = name || ""
        class_name.gsub("::", "_").underscore
      end

      def testid_prefix
        id_prefix
      end
    end

    def id_prefix
      @id_prefix ||= self.class.id_prefix
    end

    def testid_prefix
      id_prefix
    end

    def id
      return @id if @id

      @id = "#{id_prefix}_#{uniq_key}"
      if Rails.env.local?
        raise "invalid character in id: `#{@id}`" if @id =~ /[.#:\[\]()\s]/
        raise "id starts with number: `#{@id}`" if @id =~ /^[0-9]/
      end
      @id
    end

    def testid
      id
    end

    private

    def uniq_key
      random_hex
    end

    def random_hex
      @random_hex ||= SecureRandom.hex(10)
    end
  end
end
