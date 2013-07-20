# encoding: UTF-8
require 'flog'
require 'flog_task'
require 'flog_cli'
require 'flay'
require 'roodi'
require 'roodi_task'

desc "Analisis de complejidad de codigo"
task :flog do
  threshold = 40
  flog = FlogCLI.new
  flog.flog 'app/', 'spec/'
  
  puts flog.report
end
#--
desc "Analisis de codigo duplicado"
task :flay do
  threshold = 25
  flay = Flay.new({:fuzzy => false, :verbose => false, :mass => threshold})
  flay.process(*Flay.expand_dirs_to_files(['app', 'spec']))

  flay.report

  raise "#{flay.masses.size} trozos de codigo duplicados > #{threshold}" unless flay.masses.empty?
end 

#--
RoodiTask.new 'roodi', ['app/**/*.rb', 'spec/**/*.rb'], 'roodi.yml'

task :quality => [:flog, :flay, :roodi]
