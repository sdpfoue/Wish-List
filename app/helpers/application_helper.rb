#encoding:utf-8

module ApplicationHelper
  def avatar_url(user, options = {})
    options[:size] ||= 48
    link_to image_tag(user.gravatar_url(:size => options[:size]), :alt => "#{user.name}'s gravatar"), user_url(user.name), :title => "#{user.name}的主页"
  end
  
  def print_timeline(t)
    case t
    when Timeline::Wish
      link_to(t.user_name, user_url(t.user_id))+' 添加了新愿望 '+
        link_to(t.wish_name,wish_url(t.wish_id))+
        ' 到空间 '+link_to(t.space_name,space_url(t.space_id))
    when Timeline::Space
      link_to(t.user_name, user_url(t.user_id))+' 创建了新空间 '+
        link_to(t.space_name,space_url(t.space_id))
    when Timeline::Spacecomment
      link_to(t.user_name, user_url(t.user_id))+' 添加了评论到空间 '+
        link_to(t.space_name,space_url(t.space_id))
    end
    
  end
  
end
