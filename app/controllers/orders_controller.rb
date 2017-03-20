class OrdersController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  def index
    @orders=Order.all
    @orders=Order.paginate(:page => params[:page], :per_page => 2)
  end

  def new
    @cart=current_cart
    if @cart.line_items.empty?
      redirect_to root_path, notice: 'Your cart is empty'
      return
    end
    @order=Order.new
    respond_to do |format|
      format.html #new.html.erb
      format.xml { render :xml => @order }
    end
  end

  def edit
    @order=Order.find(params[:id])
  end

  def update
    @order=Order.find(params[:id])
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_path, notice: 'Order updated successfully.' }
      end
    end
  end

  def show
    @order=Order.find(params[:id])
  end

  def destroy
    @order=Order.find(params[:id])
    respond_to do |format|
      if @order.destroy
        format.html {redirect_to orders_path, notice: 'Order successfully deleted'}
      end
    end

  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id]=nil
        Notifier.order_received(@order).deliver
        format.html { redirect_to root_path, notice: 'Thank you for your order' }
        format.xml { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => new }
        format.xml { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def order_params
    params.require(:order).permit(:name, :address, :email, :pay_type)
  end
end
