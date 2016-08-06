class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.string :status
      t.datetime :due_date
      t.belongs_to :list, foreign_key: true

      t.timestamps
    end
  end
end
