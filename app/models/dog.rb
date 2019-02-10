class Dog < ApplicationRecord
  belongs_to :user, optional: true

  has_many :likes, dependent: :destroy

  has_many_attached :images

  # Most likes for the past hour
  def self.sorted
    select("dogs.*, count(dog_id) as likes_count")
      .joins("left join likes as likes on likes.dog_id = dogs.id")
      .where("likes.created_at >= ?", Time.now.utc - 1.hour)
      .group("likes.dog_id")
      .order("likes_count desc, id asc")
  end
end
