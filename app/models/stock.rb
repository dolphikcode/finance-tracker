class Stock < ApplicationRecord
	has_many :user_stocks
	has_many :users, through: :user_stocks

	def self.find_by_ticker(ticker_symbol)
		where(ticker: ticker_symbol).first
	end

	def self.new_from_lookup(ticker_symbol)
		begin
			looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
			price = strip_commas(looked_up_stock.l)		#strip_commas usuwa przecinki z liczb patrz poniżej na funkcję (amerykanie używają przecinka dla oddzielenia tysięcy)
			new(name: looked_up_stock.name, ticker: looked_up_stock.symbol, last_price: price)		#tylko new na końcu powoduje przekazanie tych wartości przez nowy obiekt do wywołującego 																																															funkcję
		rescue Exception => e			# begin+rescue Exception to złapanie wyjątku
			return nil
		end
	end
	
	def self.strip_commas(number)
		number.gsub(",", "")
	end

end
