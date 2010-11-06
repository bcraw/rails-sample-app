class Company < ActiveRecord::Base

 has_many :job_posts


  validates :zip , :presence => true, :length=>{:minimum=>5, :maximum=>5}
  validates :city, :presence => true
  validates :state, :presence => true, :length=>{:minimum=>2, :maximum=>2}
  

end
