class TimelineController < ApplicationController
  
  before_filter :redirect_guest

  def index
    # authorize! :read, :timeline
    @audits = Audit.recent.all
    @maximum_ideas = 10
    @recent_liked_ideas = []
    @recent_commented_ideas = []
  end
  
end