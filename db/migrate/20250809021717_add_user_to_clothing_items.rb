class AddUserToClothingItems < ActiveRecord::Migration[8.0]
  def up
    # First, add the column as nullable
    add_reference :clothing_items, :user, foreign_key: true
    
    # Set a default user for existing records (using the first user or create one)
    default_user = User.first_or_create!(
      email: 'default@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    
    # Update all existing records to use the default user
    ClothingItem.update_all(user_id: default_user.id)
    
    # Now add the not-null constraint
    change_column_null :clothing_items, :user_id, false
  end
  
  def down
    remove_reference :clothing_items, :user, foreign_key: true
  end
end
