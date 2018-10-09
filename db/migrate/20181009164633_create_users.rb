class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :score
      t.integer :max_score

      t.timestamps
    end
  end
end
