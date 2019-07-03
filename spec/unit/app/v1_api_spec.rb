require_relative '../../../app/v1_api'
require 'rack/test'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message) # packages up the status info in a new class 'RecordResult'

  RSpec.describe API do
    include Rack::Test::Methods  # used to route HTTP requests to the API class

    def app
     API.new(ledger: ledger)
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

          parsed = JSON.parse(last_response.body)
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

        it 'returns and error message' do
          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('error' => 'Expense Incomplete')
        end

        it 'responds with a 422 (Unprocessable Entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq 422          
        end
      end

    end
  end
end
