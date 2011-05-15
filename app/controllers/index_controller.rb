class IndexController < ApplicationController
  def index
    @timeline=Timeline::Base.get_following_timeline(session[:user_id]).paginate :page=>params[:page],:per_page => 10
  end
  
  def publictimeline
    @timeline=Timeline::Base.get_public_timeline.paginate :page=>params[:page],:per_page => 10
  end

end
