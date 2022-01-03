class StocksController < ApplicationController
  def search
    # check if the get param stock is defined
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      # check if it found the stock in the api
      if @stock
        # repond to format for APIs where you return json or ajax to go to JavaScript
        respond_to do |format|
          # the result javascript file to refresh content with the stock result
          format.js { render partial: 'users/result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.js { render partial: 'users/result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        format.js { render partial: 'users/result' }
      end
    end

  end # search
end
