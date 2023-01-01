class Base < ApplicationRecord
  validates :base_num, presence: true, uniqueness: true
  validates :base_name, presence: true
  validates :kinds, presence: true
end
