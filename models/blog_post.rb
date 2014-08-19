class BlogPost < ContentfulModel
  CONTENT_TYPE_ID = "C33dJh6k804WqGci0Kyuk"

  def self.slugify(s)
    s.gsub(" ", "-")
  end

  def self.unslugify(s)
    s.gsub("-", " ")
  end

  def self.from_slug(slug)
    find_by_headline(unslugify(slug))
  end

  def slug
    BlogPost.slugify(fields[:headline])
  end

  def tags
    fields[:tags]
  end
end
