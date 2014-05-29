require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

desc 'Test'
task :test do
  exec 'guard --force_polling'
end

namespace :scrap do
  desc 'Scrap the games list to get new games, prices, and stuff'
  task :games_list do
    require_relative './init'
    scrapper = ScrappingOverlord.new
    scrapper.scrap_games_list(true)
  end

  desc 'Scrap each game to get the categories and other stuff'
  task :games do
    require_relative './init'
    scrapper = ScrappingOverlord.new
    scrapper.scrap_games(true)
  end

  desc 'Scrap the reviews for each game'
  task :reviews do
    require_relative './init'
    scrapper = ScrappingOverlord.new
    scrapper.scrap_reviews(true)
  end
end

namespace :log do
  task :test do
    dirs = Dir.glob 'log/test.*.log'
    exec "tail -f #{dirs.last}" unless dirs.empty?
  end

  task :dev do
    dirs = Dir.glob 'log/development.*.log'
    exec "tail -f #{dirs.last}" unless dirs.empty?
  end

  task :prod do
    dirs = Dir.glob 'log/production.*.log'
    exec "tail -f #{dirs.last}" unless dirs.empty?
  end
end

task default: :test