# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Mayors::Application.load_tasks

namespace :segments do
  task fetch_all: :environment do
    SegmentFetcher.crawl
  end
end
