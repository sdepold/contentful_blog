class BlogPost < ContentfulModel
  CONTENT_TYPE_ID = "C33dJh6k804WqGci0Kyuk"

  def tags
    fields[:tags]
  end
end
