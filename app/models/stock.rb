class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  # self.method_name is to be able to call it from the class without instiatate it
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
                                  publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
                                  secret_token: Rails.application.credentials.iex_client[:secret_token],
                                  endpoint: 'https://sandbox.iexapis.com/v1'
                                )
    # if the symbol/ticker is not found then rescue to send a null since the api throws an exception
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
