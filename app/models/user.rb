class User < ApplicationRecord
  # Profileモデルとの1対1の関連付け
  has_one :profile, dependent: :destroy

  # バリデーション例
  validates :user_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  # パスワードを暗号化するためにhas_secure_passwordを利用する場合
  # has_secure_password
end
