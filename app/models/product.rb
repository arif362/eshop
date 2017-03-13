class Product < ActiveRecord::Base
  mount_uploader :image_url, ImageUrlUploader
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true
  validates :price, :numericality => {greater_than_or_equal_to: 0.01}
  validates :image_url, :format =>  {
                :with => %r{\.(gif|jpg|png)}i,
                :message =>  'Image must be gif or jpg or png.'
                      }
end
