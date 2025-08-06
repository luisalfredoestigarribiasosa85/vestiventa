require "test_helper"

class ClothingItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clothing_item = clothing_items(:one)
  end

  test "should get index" do
    get clothing_items_url
    assert_response :success
  end

  test "should get new" do
    get new_clothing_item_url
    assert_response :success
  end

  test "should create clothing_item" do
    assert_difference("ClothingItem.count") do
      post clothing_items_url, params: { clothing_item: { color: @clothing_item.color, name: @clothing_item.name, price: @clothing_item.price, size: @clothing_item.size, sold: @clothing_item.sold, user_id: @clothing_item.user_id } }
    end

    assert_redirected_to clothing_item_url(ClothingItem.last)
  end

  test "should show clothing_item" do
    get clothing_item_url(@clothing_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_clothing_item_url(@clothing_item)
    assert_response :success
  end

  test "should update clothing_item" do
    patch clothing_item_url(@clothing_item), params: { clothing_item: { color: @clothing_item.color, name: @clothing_item.name, price: @clothing_item.price, size: @clothing_item.size, sold: @clothing_item.sold, user_id: @clothing_item.user_id } }
    assert_redirected_to clothing_item_url(@clothing_item)
  end

  test "should destroy clothing_item" do
    assert_difference("ClothingItem.count", -1) do
      delete clothing_item_url(@clothing_item)
    end

    assert_redirected_to clothing_items_url
  end
end
