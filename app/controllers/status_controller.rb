class StatusController < ApplicationController

  before_action :authenticate_user!

  def index

    @volumen = Volumen.order(messdatum: :desc).first

    #Calculate percentage of luid level
    if @volumen.volumen > 4500
      @fluid = 0
      @percentage = 100
    else
      @percentage = @volumen.volumen / 4500 * 100
      @fluid = 100 - @percentage
    end

  end


end
