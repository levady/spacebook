class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.string :requestor, null: false
      t.string :target, null: false
      t.boolean :friend, default: true

      t.timestamps
    end
    add_index :relationships, [:requestor, :target], unique: true
  end
end
