class UsersController < ApplicationController
  def my_portfolio
    # defferent than in alpha_blog with devise gem the current_user is already defined
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
   if params[:friend].present?
     # calls the search method in the model
     @friends = User.search(params[:friend])
     # from the friends list remove the current logged in user (i can't friend myself)
     @friends = current_user.except_current_user(@friends)
     # the format.js is to handle the search result with javascript for ajax
     if @friends
       respond_to do |format|
         format.js { render partial: 'users/friend_result' }
       end
     else
       respond_to do |format|
         flash.now[:alert] = "Couldn't find user"
         format.js { render partial: 'users/friend_result' }
       end
     end
   else
     respond_to do |format|
       flash.now[:alert] = "Please enter a friend name or email to search"
       format.js { render partial: 'users/friend_result' }
     end # else
   end # if present
 end # search
end
