class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :show, :edit, :update, :edit_basic_info, :update_basic_info]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:destory, :index, :edit, :update, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :set_one_month, only: :show
  
  def index                                                                                                                                                                                                                                                                                                                                                                                                            
    @users = User.paginate(page: params[:page])
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
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
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] ="#{@user.name}の基本情報を更新しました"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :department)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
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
