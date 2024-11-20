class CitiesController < ApplicationController
  before_action :set_city, only: [:edit, :update, :destroy]

  def index
    @cities = City.all.order(:name) # Order cities alphabetically by name
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(city_params)
    if @city.save
      redirect_to cities_path, notice: "City created successfully."
    else
      flash.now[:alert] = "Error creating city. Please check the form."
      render :new
    end
  end

  def edit
  end

  def update
    if @city.update(city_params)
      redirect_to cities_path, notice: "City updated successfully."
    else
      flash.now[:alert] = "Error updating city. Please check the form."
      render :edit
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_path, notice: "City deleted successfully."
  end

  private

  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name, :collection_point_address)
  end
end
