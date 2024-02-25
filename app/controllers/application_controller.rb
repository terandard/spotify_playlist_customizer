# frozen_string_literal: true

class ApplicationController < ActionController::Base
  class NotLoggedIn < StandardError; end

  rescue_from NotLoggedIn do
    redirect_to login_path
  end

  # @return [User] 現在ログイン中のユーザ
  def current_user
    User.find_by!(identifier: session[:user_identifier])
  rescue ActiveRecord::RecordNotFound
    raise NotLoggedIn
  end
end
