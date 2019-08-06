require ENV['ABT'] + '/src/lib/project.rb'
require ENV['ABT'] + '/src/lib/atcoder.rb'
require ENV['ABT'] + '/src/lib/task_config.rb'



puts '    #      # # # # #    # # #     # # #    # # #    # # # #   # # #   '
puts '   # #         #       #         #     #   #    #   #         #     # '
puts '  #   #        #      #         #       #  #     #  # # # #   # # #   '
puts ' # # # #       #       #         #     #   #    #   #         #    #  '
puts '#       #      #        # # #     # # #    # # #    # # # #   #     # '
puts 'wellcome atcoder build tools'


loop {
  project = Project.new
  print "abt::\e[38;5;118m#{project.get_now_lang}\e[m::\e[38;5;122m#{project.get_now_task}\e[m:> "
  arg = gets.chomp.to_s



  case arg
  when "new"
    project.init()

  when "sample"
    puts "[info] please URL of Atcoder tasks\n :=>"
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

  when "quit"
    exit 0

  end
 }
