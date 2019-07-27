require ENV['ABT'] + '/src/lib/config.rb'
require 'fileutils'
require 'open3'

# コンパイルするクラス
class Compile

  # 設定ファイルを読み込み
  def initialize
    @config = Config.new
  end

  # 問題と言語を渡されてその問題をコンパイルする
  def compile(task, lang)
    cmd = @config.make_compile_command(task, lang)

    printf("[info] compile now ...\n")
    _, e, w = Open3.capture3(cmd)

    if w.exitstatus != 0
      puts "[error] \e[31mfailed compile.\e[0m"
      puts e
      files = Dir.glob('./bin/*')
      files.each { |f| File.delete(f) }
      exit 1
    else
      puts "[info] \e[32mcompile sucess.\e[0m\n"
      puts e
    end
  end
end
