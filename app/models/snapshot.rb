class Snapshot < ApplicationRecord
  has_many :user_snapshots, dependent: :destroy
  has_many :users, through: :user_snapshots

  def self.check_duplicate_snapshot(snapshot1, snapshot2)
    if self.identical_data(snapshot1, snapshot2) && self.times_are_within_window(snapshot1, snapshot2)
      10.times do puts "deleting duplicate snapshot" end
      snapshot2.destroy()
    end
  end

  def self.identical_data(snapshot1, snapshot2)
    unless snapshot1.user_snapshots.length == snapshot2.user_snapshots.length
      return false
    end

    snapshot1.user_snapshots.each do |user_snapshot|
      unless snapshot2.user_snapshots.find_by(user_id: user_snapshot.user_id).labs == user_snapshot.labs
        return false
      end
    end

    true
  end

  def self.times_are_within_window(snapshot1, snapshot2)
    arbitrary_time = 60 * 15
    snapshot2.created_at - snapshot1.created_at < arbitrary_time
  end
end
