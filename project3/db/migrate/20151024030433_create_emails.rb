class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :user, index: true, foreign_key: true
      t.references :article, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
