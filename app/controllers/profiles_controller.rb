# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :set_user

  def edit
    @user_profile_form = UserProfileForm.new(@user)
  end

  def update
    @user_profile_form = UserProfileForm.new(@user, user_profile_form_params)
    if @user_profile_form.update(user_profile_form_params)
      redirect_to root_path, notice: "更新に成功しました"
    else
      render :edit
    end
  end

  private

  def set_user
    # 例としてparams[:id]からUserを取得（通常はcurrent_userを利用するケースが多い）
    @user = User.find(params[:id])
  end

  def user_profile_form_params
    params.require(:user_profile_form).permit(:user_name, :email, :password, :bio, :age)
  end
end
