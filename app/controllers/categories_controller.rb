class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Category updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: "Category deleted successfully."
  end

  def pricing_details
    category = Category.find(params[:id])
    render json: { base_price: category.base_price, additional_cost: category.additional_cost_per_gram, fee_percentage: category.fee_percentage, minimum_cost: category.minimum_cost }
  end
  

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :base_price, :minimum_cost, :additional_cost_per_gram, :fee_percentage)
  end
end
