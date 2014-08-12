class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to #{League::NAME}!"
      redirect_to @user
    else
      render :new
    end
  end

  def index
    @users = User.all
  end

=begin
  #TODO: update??
  def change_vip_status
    @user = User.find(params[:id])
    @user.update_attribute(:vip, !@user.vip)
    redirect_to users_path
  end
=end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
