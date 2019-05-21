require "lib/atcoder.rbの絶対パス"
require "project.rbの絶対パス"

# DEBUG: python, scala, kotlin, などのコンパイルの設定がまだできていない

def take_task(text)
  puts text

  language_list = []
  File.foreach("./language.txt"){ |line|
    language_list.push(line.chomp)
  }

  language_list = language_list.sort

  if language_list.length < 1
    puts "[Warn] no source file"
    exit 1
  end
  task_hash = {}
  language_list.each do |lang|
    task_hash[lang] = Dir.glob("./src/" + lang + "/*").map { |e| File.basename(e) }.sort
  end


  task_hash.each_with_index do |(key, value), i|
    puts "\e[30;43m<#{key}>\e[m "
    if value.length == 0
      puts "No source"
    end
    value.each_with_index do |task, j|
      puts "[#{i+1}#{j+1}] -> #{task}"
    end
  end

  print "[info] select number :=> "
  s = $stdin.gets.chomp
  a = s[0].to_i
  b = s[1..-1].to_i
  #a, b = $stdin.gets.chomp.split("").map { |e| e.to_i }  # BUG: 言語数が二桁になるとバグになる

  if a > language_list.length
    puts "[ERROR] lnoger language number"
    exit 1
  end
  if !task_hash.key?(language_list[a-1])
    puts "[ERROR] no language"
    exit 1
  end

  if b > task_hash[language_list[a-1]].length
    puts "[ERROR] longer task number"
    exit 1
  end

  return task_hash[language_list[a-1]][b-1]
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


languages = {"Ruby"=>".rb", "Python"=>".py", "Haskell"=>".hs", "Rust" => ".rs", "Scala"=>".scala", "C"=>".c", "Go"=>".go"}

if ARGV.length < 1
  puts "[Warn] number] of arguments is 1."
  exit 1
elsif ARGV.length > 2
  puts "[Warn] number of arguments is 1."
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
  save_task(usr.task_list_href.keys.map { |e| e.gsub("/", ":") })

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
