
require ENV['ABT'] + '/src/lib/config.rb'

# 実行ファイルを実行するクラス
class Exec

  # 設定ファイルを読み込む
  def initialize
    @config = Config.new
  end

  # 実行ファイルを実行する
  def exec(task, lang)
    exec_command = @config.make_exec_command(task, lang)
    out = `#{exec_command}`
    puts '================{OUT PUT}==================='
    puts out
  end
end
