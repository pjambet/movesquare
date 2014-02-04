class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :segment_type
      t.string :activity_type
      t.integer :steps, default: 0
      t.integer :duration, default: 0
      t.float :distance, default: 0
      t.float :lat
      t.float :lng
      t.boolean :processed
      t.references :user, index: true
      t.references :neighborhood, index: true
      t.references :city, index: true
      t.references :state, index: true
      t.references :country, index: true

      t.timestamps
    end
  end
end
