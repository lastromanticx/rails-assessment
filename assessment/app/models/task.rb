class Task < ApplicationRecord
  belongs_to :list
  has_many :task_tags
  has_many :tags, through: :task_tags

  validates_presence_of :name, :due_date

  scope :overdue, -> {
    all.select(&:overdue)
  }

  def tags_attributes=(tag_attributes)
    tag = Tag.find_or_create_by(tag_attributes.values[0]) if tag_attributes.values[0]["name"].match(/[a-zA-Z]/)
    tags << tag if tag and not tags.include?(tag)
  end

  def overdue
    due_date < Time.now
  end
end
