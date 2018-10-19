class User < ApplicationRecord
  has_many :user_snapshots
  has_many :snapshots, through: :user_snapshots
end
