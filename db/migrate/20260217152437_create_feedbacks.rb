class CreateFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feedbacks do |t|
      t.references :outcome, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comments
      t.string :reviewed_by, null: false
      t.date :review_date, null: false
      t.integer :achievement_status, null: false

      t.timestamps
    end

    add_index :feedbacks, :rating
    add_index :feedbacks, :achievement_status
  end
end
