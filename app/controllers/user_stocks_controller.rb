class UserStocksController < ApplicationController

  def create
    # check if the stock is already in the database
    stock = Stock.check_db(params[:ticker].upcase)
    # look up the stock with the API
    stock_api = Stock.new_lookup(params[:ticker].upcase)
    # byebug()
    if stock.blank?
      # if not then it in BD
      stock_api.save
      stock = stock_api
    else
      # if yes then update the price in BD for the current in api
      stock.last_price = stock_api.last_price
      stock.save
    end

    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    redirect_to my_portfolio_path
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end

end
