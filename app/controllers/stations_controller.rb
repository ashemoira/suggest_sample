class StationsController < ApplicationController
  def new
    @table = Station.new
    @stations = Station.all# .includes(:station)
  end

  def suggest
    print("controller suggest\n")
    names = Station.suggest(params[:term])
    print(names)
    render json: names
  end
end
