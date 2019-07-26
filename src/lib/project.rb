ABTROOT = ENV['ABT']

require 'toml-rb'
require "fileutils"
require 'open-uri'
require 'fssm'
require 'shellwords'
require ABTROOT + '/src/lib/config.rb'

# コンテストの初期ディレクトリを作成する
class Project

  # configファイルを読み込む
  def initialize
    @config = Config.new
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

  # 指定した言語の初期ソースコードを作成する
  def source(lang)
    ext = @config.get_extension(lang)

    FileUtils.mkdir_p("./src/#{lang}")
    templete = File.read(ABTROOT + '/templete/' + lang + ext)
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

    print 'select number => '
    n = $stdin.gets.chomp.to_i

    if languages.length < n
      printf("[info] \e[31;1mError number is longer\e[m\n")
      exit 1
    end

    lang = languages[n - 1]

    source(lang)
  end
end

=begin
project = Project.new
project.init
project.init_source
=end
