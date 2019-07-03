require 'sinatra/base'
require_relative 'v2_ledger'
require 'json'



module ExpenseTracker

  class API < Sinatra::Base

    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super() # rest of initialize from Sinatra
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do 
      JSON.generate(@ledger.expenses_on(params[:date]))
    end

  end
end
