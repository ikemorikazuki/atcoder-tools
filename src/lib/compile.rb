ABTROOT = ENV['ABT']
require ABTROOT + '/src/lib/config.rb'
require 'open-uri'
require 'fileutils'

# コンパイルするクラス
class Compile

  # 設定ファイルを読み込み
  def initialize
    @config = Config.new
  end

  def comile_of(lang, )

  end
end
