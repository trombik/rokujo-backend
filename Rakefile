# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

require "rubocop/rake_task"
RuboCop::RakeTask.new

def html_files
  Rails.root.glob("app/**/*.html.erb") +
    Rails.root.glob("spec/**/*.html.erb")
end

task default: [:spec, :rubocop, :brakeman, :htmlbeautifier]

desc "Run htmlbeautifier with lint only"
task htmlbeautifier: :environment do
  cmd = "htmlbeautifier -b1 -l #{html_files.join(" ")}"
  _stdout, stderr, status = Open3.capture3(cmd)
  raise "htmlbeautifier failed with #{stderr}\nTo fix run `rake htmlbeautifier-fix`" unless status.success?
end

desc "Run htmlbeautifier and fix"
task "htmlbeautifier-fix": :environment do
  cmd = "htmlbeautifier -b1 #{html_files.join(" ")}"
  _stdout, stderr, status = Open3.capture3(cmd)
  raise "htmlbeautifier failed with #{stderr}" unless status.success?
end

desc "Run brakeman"
task brakeman: :environment do
  sh "brakeman"
end
