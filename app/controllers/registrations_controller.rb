# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  def new
    @registration_form = RegistrationForm.new
  end

  def create
    @registration_form = RegistrationForm.new(registration_form_params)
    if @registration_form.save
      redirect_to root_path, notice: "登録に成功しました"
    else
      render :new
    end
  end

  private

  def registration_form_params
    params.require(:registration_form).permit(:user_name, :email, :password, :bio, :age)
  end
end
