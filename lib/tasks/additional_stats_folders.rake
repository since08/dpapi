task stats: 'dpapi:statsetup'
namespace :dpapi do
  desc 'Add more folders to stats'
  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ['Services', 'app/services']
  end
end