ABTROOT = ENV['ABT']

require "fileutils"
require 'open-uri'
require 'fssm'
require 'shellwords'
require ABTROOT + '/src/lib/config.rb'

# コンテストの初期ディレクトリを作成する


class Project

  # configファイルを読み込む
  def initialize
    @config = Config.new()
  end

  # Projectの初期ディレクトリを生成する
  def init
    puts '[info] make directory...  ./src, ./test, ./bin, ./result'
    FileUtils.mkdir_p(['./src', './test', './bin','./result'])
    puts '[info] make file... config'
    File.open('config.toml', 'w')
  end

end


project = Project.new
project.init
