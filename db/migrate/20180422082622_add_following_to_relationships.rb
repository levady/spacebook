class AddFollowingToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :following, :boolean, default: true, null: false
  end
end
