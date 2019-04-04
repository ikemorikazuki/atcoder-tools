require #"atcoder.rb"の絶対パス
require #"project.rb"の絶対パス

# DEBUG: python, scala, kotlin, などのコンパイルの設定がまだできていない

def take_task(text)
  puts text
  tasks = Dir.glob("./src/*")

  if tasks.length < 1
    puts "[info] no source file"
    exit 1
  end

  tasks = tasks.map { |e| File.basename(e) }.sort

  tasks.each_with_index do |task, i|
    puts "[#{i+1}]-> #{task}"
  end

  print "select number :=> "
  n = $stdin.gets.chomp.to_i
  if n > tasks.length
    puts "larger number"
    exit 1
  end

  return tasks[n-1]

end


def save_task(list)
  f = File.open("./config.txt", "w")
  f.puts list
  f.close
end





#########################################################################
#
# プログラム本文
#
########################################################################


languages = {"Ruby"=>".rb", "Python"=>".py", "Haskell"=>".hs", "Scala"=>".scala", "C"=>".c"}

if ARGV.length < 1
  puts "number of arguments is 1."
  exit 1
elsif ARGV.length > 2
  puts "number of arguments is 1."
  exit 1
end

arg = ARGV[0]


case arg

when "new" then
  Project.init

when "sample" then
  puts "[info] please URL of Atcoder tasks"
  url = $stdin.gets.chomp
  puts url

  usr = User.new
  usr.login
  usr.get_samples(url)
  usr.save_sample
  save_task(usr.task_list_href.keys)

when "source" then
  Project.make_source(languages)

when "run"
  task = take_task("[info] task run  ?")
  Project.run(task, true)

when  "test"
  task = take_task("[info] which task test ?")
  printf("===============\e[33m{ TEST }\e[m===============\n")
  Project.test(task)

when "~test"
  Project.watching_test
else
  puts "no comand"
  exit 1
end
