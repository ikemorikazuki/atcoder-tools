require "mechanize"
require 'open-uri'
require 'fileutils'
# TEMP: 提出用のメソッドを作成する余地あり

class Atcoder
  attr_reader :in_and_out, :task_list_href, :submit_links   # アクセスメソッドを定義

  def initialize
    @agent = Mechanize.new
    @task_list_href = {} # 問題名と問題ページのURLを保存
    @in_and_out = {}  # Test_caseをここに保存
    @submit_links = {} # 提出用のURLをここに保存
  end

  def login
    puts "[info] login ..."
    login_url = "https://atcoder.jp/login?lang=ja"
    begin
      @agent.get(login_url).form_with(class: "form-horizontal") do |form|
        form.field_with(name: "username").value = ""
        form.field_with(name: "password").value = ""
      end.submit
    rescue => e
      puts "[info] FAILED login"
      puts e
      puts 1
    end
    puts "[info] logined !!!"
  end

  def get_taskslist(tasks_url)
    # tasks_url: コンテストの問題一覧ページ
    begin
      task_page = @agent.get(tasks_url)
      links = task_page.search('//*[@id="main-container"]/div[1]/div[2]/div/table/tbody/tr/td/a')
      links.each_with_index do |link, i|
        if (i+1) % 3 == 0
          name = links[i-2].text + "_" +  links[i-1].text
          name = name.gsub("/", ":")
          name = name.gsub(" ","_")
          @task_list_href.store(name, links[i-1].get_attribute(:href))
          @submit_links.store(name, link.get_attribute(:href))
        end
      end
    rescue => e
        puts "[info] FAILED get_taskslist method"
        puts e
        exit 1
    end
  end

  def get_in_and_out(task_url, task_name)
    # task_url: 問題ページのURL
    # task_name: 問題名
    task_name = task_name.gsub("/", ":")
    task_name = task_name.gsub(" ","_")
    @in_and_out.store(task_name, {}) # 問題のサンプルの保存祭
    @in_and_out[task_name].store("in", {}) # 入力の保存先
    @in_and_out[task_name].store("out",{}) # 出力の保存先

    begin
      page = @agent.get(task_url)
      samples = page.search('pre')
      leng = samples.length
      samples = samples[1..(leng / 2 - 1)].map { |e| e.text.gsub("\r", "") } # BUG: 英語圏向けのコンテストと同時開催じゃないと正しくサンプルを取得できない

      samples.each_with_index do |sample, i|
        count = i / 2 + 1
        if i % 2 == 0
          @in_and_out[task_name]["in"].store(count.to_s, sample)
        else
          @in_and_out[task_name]["out"].store(count.to_s, sample)
        end
      end
    rescue => e
      puts "[info] FAILED get_in_and_out method"
      puts e
    end
  end

  def get_samples(tasks_url)

    puts "[info] taking samples..."

    # tasks_url : 問題一覧ページのURL
    get_taskslist(tasks_url)
    @task_list_href.each do |name, url|
      baseurl = "https://atcoder.jp"
      get_in_and_out(baseurl + url, name)
    end

    puts "[info] taked samples !!!"

  end

end


class User < Atcoder

  def save_sample
    test_save = "./test"  # 入力を保存するディレクトリ
    result_save = "./result" # 結果を保存するディレクトリ

    puts "[info] saving samples..."

    if @in_and_out != {} && @in_and_out != nil
      @in_and_out.each do |name, task|
            FileUtils.mkdir_p(result_save + "/" + name)
        # puts "ERROR"; exit 1 if task.length != 2
        task.each_with_index do |(in_or_out, samples), i|
          FileUtils.mkdir_p(test_save +  "/" + name +  "/" + in_or_out)
          samples.each do |number, content|
            f = File.open(test_save + "/" + name + "/" + in_or_out + "/" +  number, "w")
            f.puts content
            f.close
            File.open(result_save + "/" + name + "/" + number, "w") if i == 0
          end
        end
      end
    else
      puts "[info] FAILED. No sample case"
      exit 1
    end
    puts "[info] saved samples !!!"
  end
end


=begin
my = Atcoder.new
my.login
my.get_samples("https://atcoder.jp/contests/abc122/tasks")
puts my.in_and_out
# puts my.submit_links
user = User.new
user.login
user.get_samples("https://atcoder.jp/contests/abc122/tasks")
puts user.in_and_out
user.save_sample


=end
