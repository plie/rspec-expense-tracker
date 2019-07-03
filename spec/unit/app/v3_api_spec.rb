require_relative '../../../app/v3_api'
require 'rack/test'

module ExpenseTracker

  RSpec.describe API do
    include Rack::Test::Methods  # used to route HTTP requests to the API class

    def app
     API.new(ledger: ledger)
    end

    def parsed
      JSON.parse(last_response.body)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') } # binds the name 'ledger' to the evaluation of the block, which will be run the first time only

    describe 'POST /expenses' do
      let(:expense) { {'some' => 'data'} }

      context 'when the expense is successfully recorded' do
        before do
          allow(ledger).to receive(:record)
          .with(expense)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense ID' do
          post '/expenses', JSON.generate(expense)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq 200
        end

      end

      context 'when the response fails validation' do
          before do
            allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense Incomplete'))
          end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          expect(parsed).to include('error' => 'Expense Incomplete')
        end

        it 'responds with a 422 (Unprocessable Entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq 422          
        end
      end

    end

    # in response to this endpoint: get '/expenses/2019-06-12'

    describe 'GET /expenses/:date' do

      context 'when expenses exist on a given date' do
        before do
          allow(ledger).to receive(:expenses_on)
          .with('2019-06-12')
          .and_return(['expense_1', 'expense_2'])
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2019-06-12'
          expect(parsed).to eq(['expense_1', 'expense_2'])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2019-06-12'
          expect(last_response.status).to eq 200
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
          .with('2019-06-10')
          .and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2019-06-10'
          expect(parsed).to eq([])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2019-06-10'
          expect(last_response.status).to eq 200
        end

      end
    end
  end
end
