class Product < ActiveRecord::Base
 # default_scope order: 'title'
  has_many :line_items

  mount_uploader :image_url, ImageUrlUploader
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true
  validates :price, :numericality => {greater_than_or_equal_to: 0.01}
  validates :image_url, :format => {
                          :with => %r{\.(gif|jpg|png)}i,
                          :message => 'Image must be gif or jpg or png.'
                      }

  before_destroy :ensure_not_referenced_by_any_line_item
  private
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

end
