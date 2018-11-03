namespace :sync do
  desc 'Sync ynab and sources'
  task :all => :environment do
    User.all.each do |user|
      user.sync
    end
  end
end

