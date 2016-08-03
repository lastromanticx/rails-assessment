class List < ApplicationRecord
  has_many :user_lists
  has_many :users, through: :user_lists
  has_many :tasks

  validates :name, presence: true

  def update_permission(user,permission)
    user_lists.where(user_id: user.id).first.update(permission: permission)
  end
end
