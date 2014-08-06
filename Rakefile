desc 'Run all tests'
task :test do
  $LOAD_PATH.unshift 'test'
  Dir.glob('./test/**/*_test.rb') { |f| require f }
end

desc 'Start server'
task :server do
  system 'bundle exec rackup -p 9292 config.ru'
end

task default: :test
