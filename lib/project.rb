require "fileutils"
require 'open-uri'
require 'fssm'
require 'shellwords'
require #'compare.rb'の絶対パス


module Project
  include Compare
  include Exec

  def init
    # 初期ディレクトリとconfigファイルの作成
    puts "make directory...  ./src, ./test, ./bin, ./result"
    FileUtils.mkdir_p(['./src', './test', './bin','./result'])

    puts 'make file... config'
    File.open('config.txt', "w")
  end

  def make_source(list)
    puts "[info] waht languages ? please select"
    list.each_with_index { |(lang, _), i| puts "#{i+1}: #{lang}" }
    print "select number =>"
    n = $stdin.gets.chomp.to_i

    language = list.keys[n-1]
    ext = list[language]

    templete = File.read("/Users/ikemorikaduki/Documents/Myprograming/atcoder-tools/templete/" + language + ext)

    task_list = []
    File.foreach("./config.txt"){ |line|
      task_list.push(line.chomp)
    }

    task_list.each do |task|
      source = File.open("./src/" + task + ext, "w")
      source.puts templete
      source.close
    end
  end


  def run(file, rt)
    ext = File.extname(Shellwords.escape(file)) # fileの拡張子
    case ext
    when ".rb" then
      Exec.exec_rb(file, rt)
    when ".py" then
      Exec.exec_py(file, rt)
    when ".hs" then
      Exec.exec_hs(file, rt)
    when ".scala"
      Exec.exec_scala(file, rt)
    when ".c" then
      Exec.exec_c(file, rt)
    else
      puts "no enviroment #{file}"
      exit 1
    end
  end

  def test(file)
    run(file, false)
    Compare.compare(file)
  end

  def watching_test
    count = 1
    FSSM.monitor('./src', '**/*') do
      update do |_, file|
        printf("=============\e[33m{NUMBER : %s}\e[m=============\n", count)
        Project.test(file)
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
