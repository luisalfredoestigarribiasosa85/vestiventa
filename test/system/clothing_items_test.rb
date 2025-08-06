require "application_system_test_case"

class ClothingItemsTest < ApplicationSystemTestCase
  setup do
    @clothing_item = clothing_items(:one)
  end

  test "visiting the index" do
    visit clothing_items_url
    assert_selector "h1", text: "Clothing items"
  end

  test "should create clothing item" do
    visit clothing_items_url
    click_on "New clothing item"

    fill_in "Color", with: @clothing_item.color
    fill_in "Name", with: @clothing_item.name
    fill_in "Price", with: @clothing_item.price
    fill_in "Size", with: @clothing_item.size
    check "Sold" if @clothing_item.sold
    fill_in "User", with: @clothing_item.user_id
    click_on "Create Clothing item"

    assert_text "Clothing item was successfully created"
    click_on "Back"
  end

  test "should update Clothing item" do
    visit clothing_item_url(@clothing_item)
    click_on "Edit this clothing item", match: :first

    fill_in "Color", with: @clothing_item.color
    fill_in "Name", with: @clothing_item.name
    fill_in "Price", with: @clothing_item.price
    fill_in "Size", with: @clothing_item.size
    check "Sold" if @clothing_item.sold
    fill_in "User", with: @clothing_item.user_id
    click_on "Update Clothing item"

    assert_text "Clothing item was successfully updated"
    click_on "Back"
  end

  test "should destroy Clothing item" do
    visit clothing_item_url(@clothing_item)
    accept_confirm { click_on "Destroy this clothing item", match: :first }

    assert_text "Clothing item was successfully destroyed"
  end
end
