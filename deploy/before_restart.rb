#rails_env = new_resource.environment["RAILS_ENV"]
#Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")
#execute "rake assets:precompile" do
#  cwd release_path
#  command "bundle exec rake assets:precompile"
#  environment "RAILS_ENV" => rails_env
#end
Chef::Log.info("Running deploy/before_migrate.rb...")

Chef::Log.info("Symlinking #{release_path}/public/assets to #{new_resource.deploy_to}/shared/assets")

link "#{release_path}/config/application.yml" do
  to "#{new_resource.deploy_to}/config/application.yml"
end

rails_env = new_resource.environment["RAILS_ENV"]
Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end