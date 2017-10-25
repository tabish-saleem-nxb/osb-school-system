class Grade < ActiveRecord::Base
  has_many :clients #use for student
  has_many :items

  validates_presence_of :title, :description
  validates_uniqueness_of :title


  def self.is_exists? title, company_id = nil
    # company = Company.find company_id if company_id.present?
    #company.present? ? company.grades.where(title: title).present? : where(title: title).present?
    where(title: title).present?
  end

end
