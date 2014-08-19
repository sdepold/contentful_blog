class BlogPost < ContentModel
  CONTENT_TYPE_ID = "C33dJh6k804WqGci0Kyuk"

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
