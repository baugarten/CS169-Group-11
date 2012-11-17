class TracksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_owner, :except=>[:new]

  def show

  end

end
