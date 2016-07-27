class List < ApplicationRecord
  belongs_to :user
  has_many :tasks
  has_many :tags, through: :tasks
end
