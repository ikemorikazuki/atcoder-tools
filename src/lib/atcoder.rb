ABTROOT = ENV['ABT']

require "mechanize"
require 'open-uri'
require 'fileutils'
require ABTROOT + '/src/lib/config.rb'

class Atcoder
  attr_reader :in_and_out, :task_list_href, :submit_links   # アクセスメソッドを定義

  # 問題名とサンプル、を保存する空のhashを作成
  def initialize
    @agent = Mechanize.new
    @task_list_href = {} # 問題名と問題ページのURLを保存
    @in_and_out = {}  # Test_caseをここに保存
    @submit_links = {} # 提出用のURLをここに保存
    @config = Config.new
  end

  # ATcoderにログインする
  def login
    puts '[info] now login ... '
    login_url = 'https://atcoder.jp/login?lang=ja'
    username = @config.get_username
    password = @config.get_password
    begin
      @agent.get(login_url).form_with(class: 'form-horizontal') do |form|
        form.field_with(name: 'username').value = username
        form.field_with(name: 'password').value = password
      end.submit
      puts '[info] logined !!!'
    rescue => e
      puts '[info] FAILED login :('
      puts e
      exit 1
    end
  end

  def get_taskslist(tasks_url)
    # tasks_url: コンテストの問題一覧ページ
    begin
      task_page = @agent.get(tasks_url)
      links = task_page.search('//*[@id="main-container"]/div[1]/div[2]/div/table/tbody/tr/td/a')
      links.each_with_index do |link, i|
        if (i+1) % 3 == 0
          name = links[i-2].text + "_" + links[i-1].text
          name = name.gsub('/', ':').gsub(' ','_')
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

  # 指定された問題のサンプルを取得する
  def get_in_and_out(task_url, task_name)
    # task_url: 問題ページのURL
    # task_name: 問題名
    task_name = task_name.gsub("/", ":").gsub(" ","_")
    @in_and_out.store(task_name, {}) # 問題のサンプルの保存祭
    @in_and_out[task_name].store('in', {}) # 入力の保存先
    @in_and_out[task_name].store('out', {}) # 出力の保存先

    begin
      page = @agent.get(task_url)
      samples = page.search('//*[@id="task-statement"]/span/span[1]/div')[3..-1].search('pre')
      leng = samples.length
      samples = samples.map { |e| e.text.gsub("\r", '') } 
      samples.each_with_index do |sample, i|
        count = i / 2 + 1
        if i % 2 == 0
          @in_and_out[task_name]['in'].store(count.to_s, sample)
        else
          @in_and_out[task_name]['out'].store(count.to_s, sample)
        end
      end
    rescue => e
      puts '[info] FAILED get_in_and_out method'
      puts e
    end
  end

  def get_samples(tasks_url)
    puts '[info] taking samples...'
    # tasks_url : 問題一覧ページのURL
    get_taskslist(tasks_url)
    @task_list_href.each do |name, url|
      baseurl = 'https://atcoder.jp'
      get_in_and_out(baseurl + url, name)
    end
    puts '[info] taked samples !!!'
  end

end


my = Atcoder.new
my.login
my.get_samples("https://atcoder.jp/contests/abc134/tasks")
puts my.task_list_href
puts my.in_and_out