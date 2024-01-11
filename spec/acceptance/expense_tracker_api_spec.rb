require 'rack/test'
require 'json'

module ExpenseTracker
    describe 'Expense Tracke API' do
      include Rack::Test::Methods

      it 'records sublimited expenses' do
        coffee = {
            'payee' => 'Starbuks',
            'amount' => 5.75,
            'date' => '2017-06-10'
        }
        post '/expenses', JSON.generate(coffee)
      end
    end
end
