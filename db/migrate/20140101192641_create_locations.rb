class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :lat
      t.float :lng
      t.string :slug, index: true
      t.string :name
      t.string :location_type
      t.integer :parent_id, index: true
      t.integer :lft, index: true
      t.integer :rgt, index: true
      t.integer :depth, index: true

      t.timestamps
    end
  end
end
