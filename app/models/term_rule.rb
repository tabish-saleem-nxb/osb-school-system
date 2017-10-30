class TermRule < ActiveRecord::Base
  validates_uniqueness_of :frequency
end
