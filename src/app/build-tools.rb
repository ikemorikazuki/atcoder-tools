


require ENV['ABT'] + '/src/lib/project.rb'
require ENV['ABT'] + '/src/lib/atcoder.rb'
require ENV['ABT'] + '/src/lib/task_config.rb'


if ARGV.length > 2 || ARGV.length <= 0
  puts '[info] error'
  exit 1
end

arg = ARGV[0]

project = Project.new


case arg
when "new"
  project.init()

when "sample"
  puts "[info] please URL of Atcoder tasks"
  url = $stdin.gets.chomp
  puts url

  usr = User.new
  usr.login
  usr.get_samples(url)
  usr.save_sample

  task_config = TaskConfig.new
  task_list = usr.task_list_href.keys
  task_config.add_list_of_task(task_list)

  task_config.update_now_task(task_list[0])

  project.source(task_config.get_now_lang)
when "run"
  project.run

when "test"
  project.test

when "source"
  project.add_new_lang

when "lang"
  project.select_now_lang

when "task"
  project.select_now_task

when "add"
  project.add_new_lang

when "now"
  project.now

end
