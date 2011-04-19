#encoding:utf-8

module ApplicationHelper
  def avatar_url(user, options = {})
    options[:size] ||= 48
    link_to image_tag(user.gravatar_url(:size => options[:size]), :alt => "#{user.name}'s gravatar"), user_url(user.name), :title => "#{user.name}的主页"
  end
end
