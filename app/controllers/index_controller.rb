class IndexController < ApplicationController
  def index
    @timeline=Timeline::Base.get_following_timeline(session[:user_id])
  end
  
  def publictimeline
    @timeline=Timeline::Base.get_public_timeline
  end

end
