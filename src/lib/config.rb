require 'toml-rb'

# 言語設定のconfigファイルから要素を抜き出すライブラリ


class Config
  attr_reader :config_file
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

    # compile_command を取得する
    def get_compile_command(lang)
      if need_compile_for(lang)
        return @config_file['languages'][lang]['compile_command'], true
      else
        puts "[error]  \e[31m #{lang} is not compile language.\e[0m"
        return "", false
      end
    end

    # 実行コマンドを取得する
    def get_exec_command(lang)
      @config_file['languages'][lang]['exec_command']
    end


    # 問題名と言語名から実行ファイルを生成するコマンドを作成
    def make_compile_command(task, lang)
      ext = self.get_extension(lang)
      cmd, s = self.get_compile_command(lang)
      left  = 0
      right = 0
      for i in 0..cmd.length-1 do
        if cmd[i] == '{'
          left = i
        elsif cmd[i] == '}'
          right = i
        end
      end
      file_path = './src/' + lang + '/' + task + ext
      cmd[0..left - 1] + file_path + cmd[right + 1..-1]
    end

    # 実行コマンドを取得しかつ作成する
    def make_exec_command(task, lang)
      if need_compile_for(lang)
        get_exec_command(lang)
      else
        ext = get_extension(lang)
        cmd = get_exec_command(lang)
        left  = 0
        right = 0

        for i in 0..cmd.length-1 do
          if cmd[i] == '{'
            left = i
          elsif cmd[i] == '}'
            right = i
          end
        end
        file_path = './src/' + lang + '/' + task + ext
        cmd[0..left - 1] + file_path + cmd[right + 1..-1]
      end
    end
end


=begin
config = Config.new
puts config.config_file
puts "username = #{config.get_username}"
puts "password = #{config.get_password}"
puts "mainlanguage = #{config.get_main_lang}"
puts "list_of_lang = #{config.get_list_of_lang}"
puts "extension of Rust = #{config.get_extension('Rust')}"
puts "exec_command = #{config.get_exec_command('Rust')}"
puts "need compile for Rust = #{config.need_compile_for('Rust')}"
puts "compile command of Rust = #{config.get_compile_command('Rust')}"
puts "compile commmand of rust = #{config.make_compile_command("A", 'Rust')}"
puts "exec_command of rust = #{config.make_exec_command("A", 'Rust')}"
=end
