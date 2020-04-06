class ProductsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  
  def index
    @product = Product.order("created_at DESC").limit 3
  end

  def new
    @product = Product.new
    @product_images = @product.product_images.build
    #セレクトボックスの初期値設定
    @parents = ["---"]
    #データベースから、親カテゴリーのみ抽出し、配列化
    Category.where(ancestry: nil).each do |parent|
      @parents << parent.category_name
    end
  end

  def create
    @product = Product.new(product_params)
    @product.status = "出品中"
    if @product.save
      redirect_to root_path, notice: '商品を出品しました'
    else
      @product.product_images.build
      render :new
    end
  end

   # 親カテゴリーが選択された後に動くアクション
  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(category_name: "#{params[:parent_name]}", ancestry: nil).children
 end

  # 子カテゴリーが選択された後に動くアクション
  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def show
    @product = Product.find(params[:id])
  end

  # 孫カテゴリーが選択された後に動くアクション
  def get_size
    selected_grandchild = Category.find("#{params[:grandchild_id]}") #孫カテゴリーを取得
    if related_size_parent = selected_grandchild.products_sizes[0] #孫カテゴリーと紐付くサイズ（親）があれば取得
      @sizes = related_size_parent.children #紐づいたサイズ（親）の子供の配列を取得
    else
      selected_child = Category.find("#{params[:grandchild_id]}").parent #孫カテゴリーの親を取得
      if related_size_parent = selected_child.products_sizes[0] #孫カテゴリーの親と紐付くサイズ（親）があれば取得
        @sizes = related_size_parent.children #紐づいたサイズ（親）の子供の配列を取得
      end
    end
 end

  private
  def product_params
    params.require(:product).permit(:name, :description, :brand, :condition, :shipping_charges, :shipping_area, :category_id, :products_size_id, :days_to_delivery, :price, [product_images_attributes: [:image]]).merge(user_id: current_user.id)
  end
end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
