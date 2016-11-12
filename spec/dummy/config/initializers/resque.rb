require 'resque/server'
Resque.after_fork = proc { ActiveRecord::Base.establish_connection }
