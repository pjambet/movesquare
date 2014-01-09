class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.references :user, index: true
      t.float :distance, default: 0
      t.integer :steps, default: 0
      t.integer :duration, default: 0
      t.float :lat
      t.float :lng
      t.boolean :processed
      t.references :neighborhood, index: true
      t.references :city, index: true
      t.references :state, index: true
      t.references :country, index: true

      t.timestamps
    end
  end
end
