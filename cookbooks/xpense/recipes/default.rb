if ["app_master", "app", "util", "solo"].include?(node[:instance_role])
  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/env.custom"do
      source "env.custom"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0655
      backup 0
    end
  end
end

if ["app_master", "app", "solo"].include?(node[:instance_role])
  node[:applications].each do |app, data|

    execute "Update Puma for zero downtime deploys" do
      command <<-EOF
        sed -i 's#pumactl -S ${pid_directory}/puma.$PORT.state restart#pumactl -S ${pid_directory}/puma.$PORT.state phased-restart#g' /engineyard/bin/app_#{app}
      EOF
    end

    ruby_block "Check Puma has been setup for zero downtime deploys" do
      block do
        if File.readlines("/engineyard/bin/app_#{app}").grep(/phased-restart/).size == 1
          Chef::Log.info("Puma setup for zero downtime deploys")
        else
          raise "Could not setup Puma for zero downtime deploys"
        end
      end
    end
  end
end