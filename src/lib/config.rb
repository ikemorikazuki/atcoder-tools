require 'toml-rb'

# 言語設定のconfigファイルから要素を抜き出すライブラリ


class Config
  ABTROOT = ENV['ABT']
    # 設定ファイルを読み込む
    def initialize
      @config_file = TomlRB.load_file(ABTROOT + '/config.toml')
    end

    # user名を取得
    def get_username
      @config_file['user']['username']
    end

    # パスワードを取得
    def get_password
      @config_file['user']['password']
    end

    # main 言語の取得
    def get_main_lang
      @config_file['mainlanguage']['language']
    end

    # 使用可能言語一覧を取得
    def get_list_of_lang
      @config_file['languages'].keys
    end

    # 言語の拡張子を取得
    def get_extension(lang)
      @config_file['languages'][lang]['extension']
    end

    # コンパル言語かどうかを取得する
    def need_compile_for(lang)
      @config_file['languages'][lang]['compile']
    end

    # command を取得する
    def get_command(lang)
      @config_file['languages'][lang]['command']
    end

    # 問題名と言語名から実行ファイルを生成するコマンドを作成
    def make_command(task, lang)
      ext = self.get_extension(lang)
      cmd = self.get_command(lang)
      left  = 0
      right = 0
      for i in 0..cmd.length-1 do
        if cmd[i] == '{'
          left = i
        elsif cmd[i] == '}'
          right = i
        end
      end

      cmd[0..left - 1] + task + ext + cmd[right + 1..-1]
    end
end



config = Config.new
puts "username = #{config.get_username}"
puts "password = #{config.get_password}"
puts "mainlanguage = #{config.get_main_lang}"
puts "list_of_lang = #{config.get_list_of_lang}"
puts "extension of Rust = #{config.get_extension('Rust')}"
puts "need compile for Rust = #{config.need_compile_for('Rust')}"
puts "command of Rust = #{config.get_command('Rust')}"
puts "commmand of rust = #{config.make_command("A", 'Rust')}"
