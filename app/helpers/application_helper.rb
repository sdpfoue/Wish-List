#encoding:utf-8

module ApplicationHelper
  def avatar_url(user, options = {})
    options[:size] ||= 48
    link_to image_tag(user.gravatar_url(:size => options[:size]), :alt => "#{user.name}'s gravatar"), user_url(user.id), :title => "#{user.name}的主页"
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
      link_to(t.user_name, user_url(t.user_id))+' 添加了评论到 '+ 
        link_to(t.space_owner,user_url(t.space_owner_id))+
        ' 的空间 '+
        link_to(t.space_name,space_url(t.space_id))
    when Timeline::Wishcomment
      link_to(t.user_name, user_url(t.user_id))+' 添加了评论到 '+ 
        link_to(t.wish_owner,user_url(t.wish_owner_id))+
        ' 的愿望 '+
        link_to(t.wish_name,wish_url(t.wish_id))
    when Timeline::Follow
      link_to(t.follower_name, user_url(t.user_id))+' 关注 '+
        link_to(t.following_name, user_url(t.following_id))
    end    
  end
  
  def follow_button(user)
    return if user.id==session[:user_id]
    if Follow.followed?(session[:user_id],user.id)
      raw("已关注 #{link_to( '取消', {:action=>'unfo',:controller=>'follow'},:remote=>true)}")
    else
      link_to '关注', {:action=>'fo', :controller=>'follow'},:remote=>true
    end
  end
  
end
