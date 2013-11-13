namespace :popularity do

  task :calculate => :environment do
    puts 'Popularity calculating...'
    Need.each do |n|
      n.attending_count = n.attendances.count
    end
  end
	
end