ABTROOT = ENV['ABT']
require ABTROOT + '/src/lib/config.rb'
require 'fileutils'
require 'open3'

# コンパイルするクラス
class Compile

  # 設定ファイルを読み込み
  def initialize
    @config = Config.new
  end

  # 問題と言語を渡されてその問題をコンパイルする
  def comile_of(task, lang)
    cmd = @config.make_compile_command(task, lang)

    printf("[info] compile now ...\n")
    _, e, w = Open3.capture3(cmd)

    if w.exitstatus != 0
      puts "[info] " + text
      puts e
      files = Dir.glob('./bin/*')
      files.each { |f| File.delete(f) }
      exit 1
    else
      puts '[info] sucess compile.'
      puts e
    end
  end
end
