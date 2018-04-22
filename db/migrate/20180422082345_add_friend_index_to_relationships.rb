class AddFriendIndexToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_index :relationships, [:requestor, :friend]
  end
end
