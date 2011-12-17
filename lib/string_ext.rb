# coding: utf-8

# Required string extensions

class String
  # Removes any "not url friendly" stuff and returns "pure" url
  def to_url
    temp = self.to_slug.transliterate.to_s.downcase
    temp.gsub!(/[^a-zA-Z 0-9]/, "")
    temp.gsub!(/\s/,'-')
    temp.gsub!(/\-+$/,'')
    temp.gsub!(/^\-+/,'')
    temp
  end

  def to_url!
    self.replace self.to_url
  end

  # Change new line to html <br/>
  def nl2br
    self.gsub("\n\r","<br>").gsub("\r", "").gsub("\n", "<br />")
  end

  def nl2br!
    self.replace self.nl2br
  end

  # Trim string to required length
  def trim(length = 20, end_str = '...')
    if self.length > length
      return "#{self[0, length-end_str.length]}#{end_str}"
    end
    self
  end

  def trim!(length = 20, end_str = '...')
    self.replace self.trim(length, end_str)
    self
  end

end
