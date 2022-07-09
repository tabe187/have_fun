class Public::HomesController < ApplicationController
  skip_before_action :require_sign_in!, only: [:top, :about]
  
  def top
  end
  
  def about
  end  
  
end

