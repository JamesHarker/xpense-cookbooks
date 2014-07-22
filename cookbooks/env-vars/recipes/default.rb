if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/env_vars.env" do
      source "xpense.env"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0655
      backup 0
    end

    execute "Add git SHA to .env" do
      command "echo '\nREVISION=#{data[:revision]}' >> /data/#{app}/shared/config/env_vars.env"
    end
  end
end
