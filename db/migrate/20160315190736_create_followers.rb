class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :uid
      t.string :name
      t.string :handle
      t.string :followers_count
      t.string :picture

      t.timestamps null: false
    end
  end
end
