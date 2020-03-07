server '36.255.222.206', user: 'deploy', roles: %w{app db resque_worker}
server '107.150.124.184', user: 'deploy', roles: %w{app db resque_worker}
set :workers, {send_email_sms: 1, send_mobile_sms: 1}

set :ssh_options, {
  user: 'deploy', # overrides user setting above
  keys: %w(~/.ssh/id_rsa),
  port: 5022,
  forward_agent: false,
  auth_methods: %w(publickey password)
  # password: 'please use keys'
}

set :deploy_to, '/deploy/production/dpapi'
set :branch, ENV.fetch('REVISION', ENV.fetch('BRANCH', 'production'))
set :rails_env, 'production'
set :bundle_without, %w{tools}.join(' ')

# puma
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_env, fetch(:rails_env, 'production')
set :puma_threads, [0, 16]
set :puma_workers, 2

set :project_url, 'https://api.deshpro.com'
