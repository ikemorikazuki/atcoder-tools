require 'toml-rb'

class TaskConfig

  # 問題設定ファイルを読み込む
  def initialize
    @config_file = TomlRB.load_file('./config.toml')
  end

  # 変更結果を新たに書き込む
  def save_config
    config = TomlRB.dump(@config_file)
    file = File.open('./config.toml', 'w')
    file.puts config
    file.close
  end

  # 問題一覧を取得する
  def get_task_list
    @config_file['tasks']
  end

  # 使用中の言語一覧を取得する
  def get_lang_list
    @config_file['languages']
  end

  # 問題を新しく追加する
  def add_task(task_name)
    task_list = self.get_task_list

    if task_list.include?(task_name)
      puts "[warn] #{task_name} is already exist."
      exit 1
    else
      @config_file['tasks'].push(task_name)
      save_config
    end
  end

  # 問題のリストを追加する
  def add_list_of_task(task_list)
    task_list.each do |task|
      @config_file['tasks'].push(task)
    end
    save_config
  end

  # 使用言語を追加する
  def add_lang(lang_name)
    lang_list = self.get_lang_list

    if lang_list.include?(lang_name)
      puts "[warn] #{lang_name} is already exist."
      exit 1
    else
      @config_file['languages'].push(lang_name)
      save_config
    end
  end

  # 現在指定されている問題を取得する
  def get_now_task
    @config_file['task']['now_task']
  end

  # 現在指定されている言語を取得する
  def get_now_lang
    @config_file['task']['now_language']
  end

  # 現在指定されている問題を更新する
  def update_now_task(task_name)
    @config_file['task']['now_task'] = task_name
    save_config
  end

  # 現在指定されている言語を更新する
  def update_now_lang(lang_name)
    @config_file['task']['now_language'] = lang_name
    save_config
  end

end
