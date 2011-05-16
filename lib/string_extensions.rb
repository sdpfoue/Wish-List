module StringExtensions
  # clear unsafe char with url slug
  def safe_slug(spliter = '-',allow_number = true)
    slug = self
    regex = /[^a-zA-Z\-0-9]/
    if not allow_number
      regex = /[^a-zA-Z\-]/
    end
    slug = slug.gsub(regex,spliter).downcase  
    slug = slug.gsub(/^\-+|\-+$/,'').gsub(/\-+/,spliter)
    slug
  end
  
  def parse_tags_from_string(string)
    return [] if string==""
    tags = string.downcase.split
    tags.map! {|tag| tag.gsub "/", ""}
    tags.delete_if {|tag| tag.size > 20 or tag.empty? or tag == '.'}
    tags.uniq
  end  
  
end

String.send :include,StringExtensions
