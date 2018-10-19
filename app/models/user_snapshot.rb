class UserSnapshot < ApplicationRecord
  belongs_to :user
  belongs_to :snapshot
end
