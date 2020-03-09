class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save!
      redirect_to root_path, notice: '商品を出品しました'
    else
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :condition, :shipping_charges, :shipping_area, :days_to_delivery, :price)
  end

  def show
    @product = Product.find(params[:id])
  end
end
