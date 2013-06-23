namespace :db do
  desc "Drop, create, migrate and seed database"
  task all: [:drop, :create, :migrate, :seed] do
    puts "New database ready!"
  end
end