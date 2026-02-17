class CreateOutcomes < ActiveRecord::Migration[8.1]
  def change
    create_table :outcomes do |t|
      t.references :mou, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.date :target_date, null: false
      t.string :responsible_person, null: false
      t.integer :status, null: false, default: 0
      t.date :completion_date

      t.timestamps
    end

    add_index :outcomes, :status
    add_index :outcomes, :target_date
  end
end
