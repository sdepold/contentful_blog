module Content
  class BlogPost < Base
    def self.from_slug(slug)
      find_by_headline(slug.gsub("-", " "))
    end

    def slug
      fields[:headline].gsub(" ", "-")
    end

    def tags
      fields[:tags]
    end
  end
end
