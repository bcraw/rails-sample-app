class JobPost < ActiveRecord::Base

  belongs_to :company

  validates :title, :presence => true
  validates :salary, :presence => true
  validates :description, :presence => true

end
