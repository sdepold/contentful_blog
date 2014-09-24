module Content
  class BlogPost < Base
    has_fields :headline, :published_at, :content, :tags

    def self.from_slug(slug)
      find_by_headline(slug.gsub("-", " "))
    end

    def slug
      headline.gsub(" ", "-")
    end
  end
end
