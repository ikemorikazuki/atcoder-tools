require "fileutils"
require 'open-uri'
require 'fssm'
require 'shellwords'
require 'compare.rbの絶対パス'


module Project
  include Compare
  include Exec

  def init
    # 初期ディレクトリとconfigファイルの作成
    puts "[info] make directory...  ./src, ./test, ./bin, ./result"
    FileUtils.mkdir_p(['./src', './test', './bin','./result'])

    puts '[info] make file... config'
    File.open('config.txt', "w")
  end

  def make_source(list)
    puts "[info] waht languages ? please select"
    list.each_with_index { |(lang, _), i| puts "#{i+1}: #{lang}" }
    print "select number =>"
    n = $stdin.gets.chomp.to_i

    language = list.keys[n-1]
    ext = list[language]

    FileUtils.mkdir_p("./src/" + language)

    templete = File.read("/Users/ikemorikaduki/Documents/Myprograming/atcoder-tools/templete/" + language + ext)

    task_list = []
    File.foreach("./config.txt"){ |line|
      task_list.push(line.chomp)
    }

    language_file = File.open("./language.txt", "a")
    language_file.puts language
    language_file.close


    task_list.each do |task|
      source = File.open("./src/" + language + "/" + task + ext, "w")
      source.puts templete
      source.close
    end
  end


  def run(file, rt)
    ext = File.extname(Shellwords.escape(file)) # fileの拡張子
    case ext
    when ".rb" then
      return Exec.exec_rb(file, rt)
    when ".py" then
      return Exec.exec_py(file, rt)
    when ".hs" then
      return Exec.exec_hs(file, rt)
    when ".rs" then
      return Exec.exec_rs(file, rt)
    when ".scala"
      return Exec.exec_scala(file, rt)
    when ".c" then
      return Exec.exec_c(file, rt)
    when ".go" then
      return Exec.exec_go(file, rt)
    else
      puts "no enviroment #{file}"
      exit 1
    end
  end

  def test(file)
    state = run(file, false)
    Compare.compare(file) if state
  end

  def watching_test
    count = 1
    FSSM.monitor('./src', '**/*') do
      update do |_, file|
        printf("=============\e[33m{NUMBER : %s}\e[m=============\n", count)
        f = File.basename(file)
        Project.test(f)
        count += 1
      end

      create do |_, file|
        printf("[info] creat %s\n", file)
      end

      delete do |_, file|
        printf("[info] deleat %s\n", file)
      end
    end
  end

  module_function :init, :run, :test, :watching_test, :make_source

end


# test
=begin

Project.run("A - Double Helix.rb", true)
Project.test("A - Double Helix.rb")
Project.watching_test
=end
