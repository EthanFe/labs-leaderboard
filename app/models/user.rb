class User < ApplicationRecord
  has_many :user_snapshots
  has_many :snapshots, through: :user_snapshots

  def self.get_data_per_day
    users = []
    self.get_final_snapshots_per_day.each do |snapshot|
      snapshot.user_snapshots.each do |user_snapshot|
        username = user_snapshot.user.name
        user = users.find { |user_entry|
          user_entry[:username] == username
        }
        if !user
          user = {username: username, data: []}
          users << user
        end
        date = snapshot.created_at
        user[:data] << {date: date, score: user_snapshot.labs}
      end
    end
    users
  end

  def self.get_final_snapshots_per_day
    dates_included = {}
    final_snapshots = []
    sorted_snapshots = (Snapshot.all.sort_by { |snapshot| snapshot.created_at}).reverse
    sorted_snapshots.each do |snapshot|
      date = snapshot.created_at.strftime("%Y%m%d")
      # date = snapshot.created_at
      if !dates_included[date]
        dates_included[date] = true
        final_snapshots << snapshot
      end
    end
    final_snapshots.reverse
  end
end
