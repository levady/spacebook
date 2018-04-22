class AddBlockToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :block, :boolean, default: false, null: false
  end
end
