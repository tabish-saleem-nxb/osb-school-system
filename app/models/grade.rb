class Grade < ActiveRecord::Base
  has_many :clients #use for student
  has_many :items
end
