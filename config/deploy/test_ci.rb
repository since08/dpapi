server '36.255.222.190',
       user: 'deploy',
       roles: %w{app db cache},
       ssh_options: {
         user: 'deploy', # overrides user setting above
         keys: %w(~/.ssh/id_rsa),
         port: 5022,
         forward_agent: false,
         auth_methods: %w(publickey password)
         # password: 'please use keys'
       }

role :resque_worker, %w{36.255.222.190}
set :workers, {send_email_sms: 1, send_mobile_sms: 1}

set :deploy_to, '/deploy/test/frontend_ci'
set :branch, ENV.fetch('REVISION', ENV.fetch('BRANCH', 'test'))
set :rails_env, 'development'
set :bundle_without, %w{tools}.join(' ')

# puma
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_env, fetch(:rails_env, 'development')
set :puma_threads, [0, 16]
set :puma_workers, 0
