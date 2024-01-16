require_relative '../../../app/ledger'
require_relative '../../../config/sequel'
require_relative '../../support/db'

module ExpenseTracker
  RSpec.describe 'Ledger', :aggregate_failures do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        'payee' => 'Starbuks',
        'amount' => 5.75,
        'date' => '2024-01-11'
      }
    end

    describe '#record' do
      context 'with a valid expense' do
        it 'successfully saves the expense in the DB' do
          result = ledger.record(expense)

          expect(result).to be_success
          expect(DB[:expenses].all).to match [a_hash_including(
            id: result.expense_id,
            payee: 'Starbuks',
            amount: 5.75,
            date: Date.iso8601('2024-01-11')
          )]
        end
      end
    end
  end
end
