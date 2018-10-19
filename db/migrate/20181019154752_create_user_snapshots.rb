class CreateUserSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :user_snapshots do |t|
      t.integer :user_id
      t.integer :snapshot_id
      t.integer :labs

      t.timestamps
    end
  end
end
