require "contentful"
require_relative "../../config/contentful"

module Content
  class Base < Contentful::Entry
    class << self
      def entry_mapping
        @entry_mapping ||= CONTENTFUL_CONFIG.fetch("mapping").map do |klass, content_type_id|
          require_relative(klass)
          [content_type_id, Content.const_get(klass.classify)]
        end.to_h
      end
      alias_method :populate_classes, :entry_mapping

      def delivery_client
        @delivery_client ||= Contentful::Client.new(
          access_token:    CONTENTFUL_CONFIG.fetch("access_token", ENV["CONTENTFUL_ACCESS_TOKEN"]),
          space:           CONTENTFUL_CONFIG.fetch("space_id"),
          dynamic_entries: :auto,
          entry_mapping:   entry_mapping
        )
      end

      def content_type
        entry_mapping.invert[self]
      end

      def all(options = {})
        locale  = options.delete(:locale) || I18n.locale
        options = options.reverse_merge(
          "content_type" => content_type,
          "locale"       => locale
        )

        delivery_client.entries options
      end

      def first(options = {})
        all(options.merge("limit" => 1)).first
      end

      def full_text_search(needle)
        first("query" => needle)
      end

      def has_fields(*args)
        [*args].each do |field_name|
          define_method(field_name.to_s) do
            fields.public_send(:[], field_name.to_s.camelize(:lower).to_sym)
          end
        end
      end

      def has_image(field_name)
        define_method("#{field_name}_url") do
          if public_send("#{field_name}?")
            if asset = fields[field_name]
              asset.fields[:file].url
            end
          end
        end

        define_method("#{field_name}?") do
          fields.key?(field_name)
        end
      end

      def method_missing(method_name, needle, options={})
        field_name = method_name.to_s.match(/^find_by_(.+)/)

        if field_name
          field_name = "fields.#{field_name[1].camelize(:lower)}"
          first(options.merge(field_name => needle))
        else
          super
        end
      end
    end
  end

  Base.populate_classes
end
