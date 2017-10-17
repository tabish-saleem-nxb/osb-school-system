class Grade < ActiveRecord::Base
  has_many :clients #use for student
  has_many :items

  validates_presence_of :title, :description
  validates_uniqueness_of :title
end
