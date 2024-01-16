RSpec.configure do |c|
  c.before(:suite) do
    Sequel.extension :migration
    Sequel::Migration.run(DB, 'db/migrations')
    DB[:expenses].trancate
  end
end
