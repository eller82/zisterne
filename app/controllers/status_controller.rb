class StatusController < ApplicationController

  before_action :authenticate_user!

  #show current fluid level of Zisterne
  def index

    #extract last volumen data from database
    @volumen = Volumen.order(messdatum: :desc).first

    #Calculate percentage of fluid level
    if @volumen.volumen > 4500
      @fluid = 0
      @percentage = 100
    else
      @percentage = @volumen.volumen / 4500 * 100
      @fluid = 100 - @percentage
    end
  end

  #show history graph of fluid level 
  def chart
  end


end
