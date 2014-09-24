class BlogPost < ContentModel
  CONTENT_TYPE_ID = "5FPTMiJ7R6uycIcC4EiCYc"

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
