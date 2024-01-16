require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RSpec.describe 'API' do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    def parsed
      JSON.parse(last_response.body)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST /expenses' do
      context 'when the expese successfully recorded' do
        expense = { 'some' => 'data' }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)

          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        expense = { 'some' => 'data' }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'response with a 422 (Unprocessable entity)' do
          post 'expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      before do
        allow(ledger).to receive(:expenses_on)
          .with('2024-01-12')
          .and_return(%w[expense_1 expense_2])
      end

      context 'when expenses exist on the given date' do
        it 'returns the expense records as JSON' do
          get '/expenses/2024-01-12'
          expect(parsed).to eq(%w[expense_1 expense_2])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2024-01-12'
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2024-01-10')
            .and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2024-01-10'
          expect(parsed).to eq([])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2024-01-10'
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
