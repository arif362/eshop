require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  test "requires item in cart" do
    get :new
    assert_redirected_to root_path
    assert_equal false[:notice], 'Your cart is empty'
  end
  test "should get new" do
    cart=Cart.create
    session[:cart_id]= cart.id
    LineItem.create(:cart => cart, :product => products(:ruby))
    get :new
    assert_success :success
  end

  test "should create order" do
    assert_difference ('Order.count') do
      post :create, :order => @order.attributes
    end
    assert_redirected_to root_path
  end

end
