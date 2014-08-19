require "contentful"

class ContentfulModel < Contentful::Entry
  class << self
    def entry_mapping
      @entry_mapping ||= superclass.descendants.map do |klass|
        [klass::CONTENT_TYPE_ID, klass]
      end.to_h
    end

    def delivery_client
      @delivery_client ||= Contentful::Client.new(
        access_token:    ENV.fetch("CONTENTFUL_ACCESS_TOKEN"),
        space:           ENV.fetch("CONTENTFUL_SPACE_ID"),
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
      all(options).first
    end

    def full_text_search(needle)
      first("query" => needle)
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
