require 'rack/test'
require_relative '../../../app/api'

module ExpenseTracker
  RSpec.describe 'API' do
    describe 'POST /expenses' do
      context 'when the expese successfully recorded' do
        it 'returns the expense id'
        it 'responds with a 200 (OK)'
      end

      context 'when the expense fails validation' do
        it 'returns an error message'
        it 'response with a 422 (Unprocessable entity)'
      end
    end
  end
end
