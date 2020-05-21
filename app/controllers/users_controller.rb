class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :show, :edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :logged_in_user, only: [:destory, :index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def index                                                                                                                                                                                                                                                                                                                                                                                                            
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規作成に成功しました"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success]="更新成功"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    #beforeフィルター
    def logged_in_user
      unless logged_in?
      store_location
       flash[:danger] ="ログインしてください"
       redirect_to login_url
      end
    end
    
    #アクセスしたユーザーが現在のログインユーザーか確認
    def correct_user
      redirect_to root_url unless current_user?(@user)
    end
    
    #管理者かチェック
    def admin_user
      redirect_to root_url unless current_user.admin? 
    end
end
