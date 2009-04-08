require 'test_helper'

class GallariesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gallaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gallary" do
    assert_difference('Gallary.count') do
      post :create, :gallary => { }
    end

    assert_redirected_to gallary_path(assigns(:gallary))
  end

  test "should show gallary" do
    get :show, :id => gallaries(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => gallaries(:one).id
    assert_response :success
  end

  test "should update gallary" do
    put :update, :id => gallaries(:one).id, :gallary => { }
    assert_redirected_to gallary_path(assigns(:gallary))
  end

  test "should destroy gallary" do
    assert_difference('Gallary.count', -1) do
      delete :destroy, :id => gallaries(:one).id
    end

    assert_redirected_to gallaries_path
  end
end
