class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :link
      t.string :description
      t.string :author
      t.datetime :pubDate
      t.references :site

      t.timestamps null: false
    end

    add_index :items, :title
  end
end
