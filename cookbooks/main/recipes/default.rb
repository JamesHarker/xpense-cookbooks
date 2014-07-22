#execute "testing" do
#  command %Q{
#    echo "i ran at #{Time.now}" >> /root/cheftime
#  }
#end

# xpense
include_recipe "xpense"

# Sidekiq
include_recipe "sidekiq"

# NewRelic server monitoring
include_recipe "newrelic"

# Environment variables
include_recipe "env-vars"