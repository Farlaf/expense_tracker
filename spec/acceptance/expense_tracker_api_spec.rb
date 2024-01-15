require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracke API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    it 'records sublimited expenses' do
      pending 'Need to persist expenses'

      coffee = post_expense(
        'payee' => 'Starbuks',
        'amount' => 5.75,
        'date' => '2024-01-11'
      )
      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2024-01-11'
      )
      groceries = post_expense(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2024-01-12'
      )

      get 'expenses/2024-01-11'
      expect(last_response.status).to eq(200)

      expense = JSON.parse(last_response.body)
      expect(expense).to contain_exactly(coffee, zoo)
    end
  end
end
