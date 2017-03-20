class StoresController < ApplicationController
  skip_before_filter :authorize
  def index
    @products=Product.all
    @products=Product.paginate(:page => params[:page], :per_page => 3)
    @cart=current_cart

  end
end
