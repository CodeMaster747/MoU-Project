class CreateMous < ActiveRecord::Migration[8.1]
  def change
    create_table :mous do |t|
      t.string :title, null: false
      t.string :organization_one, null: false
      t.string :organization_two, null: false
      t.string :department, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :objective, null: false
      t.text :terms, null: false
      t.text :contact_details, null: false

      t.timestamps
    end

    add_index :mous, :title
    add_index :mous, :organization_one
    add_index :mous, :organization_two
    add_index :mous, :start_date
    add_index :mous, :end_date
  end
end
