require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  ENV["RACK_ENV"] = "test"

  t.libs << "test"
  t.libs << "app"
  t.test_files = FileList['test/**/*_test.rb']
  t.ruby_opts += ["-W1"]  # warning level 1 is medium, ruby --help | grep warn
end

task default: :test
