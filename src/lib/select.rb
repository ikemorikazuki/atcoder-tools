
# 課題や言語を設定する

class Select
  # コンテスト設定ファイルを読み込む
  def initialize
    @config = TaskConfig.new
  end

  # 問題を設定する
  def select_task
    task_list = @config.get_task_list

    if task_list.length.zero?
      puts "[error] \e[31m no task.\e[0m"
      return false
    end

    task_list.each_with_index do |task, i|
      puts "[#{i + 1}] #{task}"
    end

    puts '[info] select task => '
    n = $stdin.gets.chomp.to_i
    @config.update_now_task(task_list[n - 1])
    return true
  end

  # 言語を設定する
  def select_lang
    lang_list = @config.get_lang_list

    if lang_list.length.zero?
      puts "[error] \e[31m no language.\e[0m"
      return false
    end

    lang_list.each_with_index do |lang, i|
      puts "[#{i + 1}] #{lang}"
    end

    puts '[info] select lang => '
    n = $stdin.gets.chomp.to_i
    @config.update_now_task(lang_list[n - 1])
    return true
  end
end
