require 'reek/rake/task'

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
  t.verbose = true
  t.source_files = 'app/*', 'spec/*'
  t.reek_opts = '-y'
end
