class Task < ApplicationRecord
  belongs_to :list
  has_many :task_tags
  has_many :tags, through: :task_tags

  scope :overdue, -> {
    all.select(&:overdue)
  }

  def tags_attributes=(tag_attributes)
    tags << Tag.find_or_create_by(tag_attributes.values[0]) if tag_attributes.values[0]["name"].match(/[a-zA-Z]/)
  end

  def overdue
    due_date < Time.now
  end
end
