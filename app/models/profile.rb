class Profile < ApplicationRecord
  # Userとの関連付け（Profileは必ず1つのUserに属する）
  belongs_to :user

  # バリデーション例
  validates :bio, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
end
