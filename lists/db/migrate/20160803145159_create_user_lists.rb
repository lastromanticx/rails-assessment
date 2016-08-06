class CreateUserLists < ActiveRecord::Migration[5.0]
  def change
    create_table :user_lists do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :list, foreign_key: true
      t.string :permission

      t.timestamps
    end
  end
end
