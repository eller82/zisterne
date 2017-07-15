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
    if params[:dauer].nil?
      dauer = "7 DAY"
    else
      dauer = "#{params[:dauer]} HOUR"
    end

    volumen = Volumen.select("messdatum, volumen").where("messdatum >= DATE_SUB(NOW( ),INTERVAL #{dauer})").order("messdatum")
    @data = create_graph_data(volumen)
  end

  protected

  def create_graph_data(volumen)
    data = {}
    volumen.each do |t|
      data[t.messdatum] = t.volumen
    end

    return data
  end


end
