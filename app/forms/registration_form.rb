# app/forms/registration_form.rb
class RegistrationForm
  include ActiveModel::Model

  # Userに関する属性
  attr_accessor :user_name, :email, :password
  # Profileに関する属性
  attr_accessor :bio, :age

  # バリデーション例
  validates :user_name, :email, :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :bio, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }

  # コンストラクタで既存の値をセット
  def initialize(user, attributes = {})
    @user = user
    # 既存のUser/Profileから初期値を設定し、引数の属性で上書きする
    super({
      user_name: user.user_name,
      email: user.email,
      bio: user.profile.bio,
      age: user.profile.age,
      password: "" # パスワードは空文字（変更しない場合は未入力）として扱う
    }.merge(attributes))
  end

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      # Userモデルの生成
      user = User.create!(user_name: user_name, email: email, password: password)
      # Userに紐づくProfileの生成（Userがhas_one :profileを持っている前提）
      user.create_profile!(bio: bio, age: age)
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  # 更新処理
  def update(params)
    self.attributes = params
    return false unless valid?
    ActiveRecord::Base.transaction do
      # パスワードは入力があった場合のみ更新（入力がなければ既存値を維持）
      if password.present?
        @user.update!(user_name: user_name, email: email, password: password)
      else
        @user.update!(user_name: user_name, email: email)
      end
      @user.profile.update!(bio: bio, age: age)
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  # パラメータの一括セット用メソッド
  def attributes=(params)
    params.each do |key, value|
      public_send("#{key}=", value)
    end
  end
end
