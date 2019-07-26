

require 'toml-rb'
require "fileutils"
require 'open-uri'
require 'fssm'
require 'shellwords'
require ENV['ABT'] + '/src/lib/config.rb'
require ENV['ABT'] + '/src/lib/task_config.rb'
require ENV['ABT'] + '/src/lib/compile.rb'
require ENV['ABT'] + '/src/lib/test.rb'
require ENV['ABT'] + '/src/lib/compare.rb'
require ENV['ABT'] + '/src/lib/exec.rb'


# コンテストの初期ディレクトリを作成する
class Project

  # configファイルを読み込む
  def initialize
    @config = Config.new
    if File.exist?('config.toml')
      @task_config = TaskConfig.new
    end
  end

  # Projectの初期ディレクトリを生成する
  def init
    init_config = { 'task' => {'now_language' => '', 'now_task' => ''}, 'tasks' => [], 'languages' => [] }

    puts '[info] make directory...  ./src, ./test, ./bin, ./result'
    FileUtils.mkdir_p(['./src', './test', './bin','./result'])

    config = Config.new
    main_lang = config.get_main_lang
    init_config['task']['now_language'] = main_lang


    puts '[info] make file... config'
    config = TomlRB.dump(init_config)
    file = File.open('config.toml', 'w')
    file.puts config
    file.close
  end

  # 現在してされている問題と言語を表示する
  def now
    puts "now lang => #{@task_config.get_now_lang}"
    puts "now task => #{@task_config.get_now_task}"
  end

  # 指定した言語の初期ソースコードを作成する
  def source(lang)
    ext = @config.get_extension(lang)

    FileUtils.mkdir_p("./src/#{lang}")
    templete = File.read(ENV["ABT"] + '/templete/' + lang + ext)
    config = TomlRB.load_file('./config.toml')

    config['tasks'].each do |task|
      source = File.open("./src/#{lang}/#{task}#{ext}", "w")
      source.puts templete
      source.close
    end

    unless config['languages'].include?(lang)
      config['languages'].push(lang)
      config = TomlRB.dump(config)
      file = File.open("./config.toml", "w")
      file.puts config
      file.close
    end
  end

  # 初期ソースコードを生成
  def init_source
    languages = @config.get_list_of_lang()
    puts '[info] which languages ? please select'
    languages.each_with_index do |lang, i|
      puts "#{i + 1}: #{lang}"
    end

    print 'select number'
    print '=> '
    n = $stdin.gets.chomp.to_i

    if languages.length < n
      printf("[info] \e[31;1mError number is longer\e[m\n")
      exit 1
    end

    lang = languages[n - 1]

    source(lang)
  end


  # 問題を設定する
  def select_now_task
    task_list = @task_config.get_task_list
    if task_list.length.zero?
      puts '[error] no task'
      exit 1
    end

    task_list.each_with_index do |task, i|
      puts "[#{i + 1}] #{task}"
    end

    puts '[info] select task'
    print '=> '
    n = $stdin.gets.chomp.to_i
    @task_config.update_now_task(task_list[n - 1])
  end

  # 言語を設定する
  def select_now_lang
    lang_list = @task_config.get_lang_list

    if lang_list.length.zero?
      puts '[error] no language'
      exit 1
    end

    lang_list.each_with_index do |lang, i|
      puts "[#{i + 1}] #{lang}"
    end

    puts '[info] select lang'
    print '=> '
    n = $stdin.gets.chomp.to_i
    @task_config.update_now_lang(lang_list[n - 1])
  end


  # 新たに使う言語を選択する
  def add_new_lang
    lang_list = @config.get_list_of_lang

    if lang_list.length.zero?
      puts '[error] no language'
      exit 1
    end

    lang_list.each_with_index do |lang, i|
      puts "[#{i + 1}] #{lang}"
    end

    puts '[info] select lang => '
    n = $stdin.gets.chomp.to_i
    @task_config.add_lang(lang_list[n - 1])
    source(lang_list[n - 1])
  end

  # コンパイルして実行する
  def run
    task = @task_config.get_now_task
    lang = @task_config.get_now_lang
    cmp  = @config.need_compile_for(lang)

    if cmp
      cmplr = Compile.new
      cmplr.compile(task, lang)
    end

    execer = Exec.new
    execer.exec(task, lang)
  end

  # testを実行する
  def test
    task = @task_config.get_now_task
    lang = @task_config.get_now_lang

    if @config.need_compile_for(lang)
      cmplr = Compile.new
      cmplr.compile(task, lang)
    end

    tester = Test.new
    tester.test(task, lang)
    Compare.compare(task)
  end
end

=begin
project = Project.new
project.init
project.init_source
=end
