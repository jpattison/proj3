class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :author
      t.string :title
      t.string :summary
      t.string :images
      t.string :source
      t.date :date
      t.string :link

      t.timestamps null: false
    end
  end
end
