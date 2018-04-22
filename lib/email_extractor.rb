class EmailExtractor
  EMAIL_REGEX = /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/

  def extract(string)
    return [] if string.blank?
    string.scan(EMAIL_REGEX).flatten
  end
end
