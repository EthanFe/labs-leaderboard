class Snapshot < ApplicationRecord
  has_many :user_snapshots
  has_many :users, through: :user_snapshots
end
