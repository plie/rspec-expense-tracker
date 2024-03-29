# require 'rack/test'
# require 'json'
# require_relative '../../app/v1_api.rb' # change to applicable version

# module ExpenseTracker
#   RSpec.describe 'Expense Tracker API' do  
#     include Rack::Test::Methods

#     def app
#       ExpenseTracker::API.new
#     end

#     def post_expense(expense)
#       post '/expenses', JSON.generate(expense)   # why is this path plural? Aren't they posted one at a time?
#       expect(last_response.status).to eq(200)

#       parsed = JSON.parse(last_response.body)
#       expect(parsed).to include('expense_id' => a_kind_of(Integer))
#       expense.merge('id' => parsed['expense_id'])
#     end

#     it 'records submitted expenses' do
#       pending 'Need to persist expenses'

#       coffee = post_expense(
#         'payee' => 'Starbucks',
#         'amount' => 5.75,
#         'date' => '2019-06-17'
#       )
#       zoo = post_expense(
#         'payee' => 'Zoo',
#         'amount' => 15.25,
#         'date' => '2019-06-17'
#       )
#       groceries = post_expense(
#         'payee' => 'Whole Foods',
#         'amount' => 95.20,
#         'date' => '2019-06-18'
#       )

#       get '/expenses/2019-06-17'
#       expect(last_response.status).to eq(200)

#       expenses = JSON.parse(last_response.body)
#       expect(expenses).to contain_exactly(coffee, zoo)
#     end

#   end
# end
