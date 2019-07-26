ABTROOT = ENV['ABT']
require ABTROOT + '/src/lib/config.rb'
require ABTROOT + '/src/lib/compile.rb'

class Test
  def initialize
    @config = Config.new
  end

  def test(task, lang)
    input_files_length = Dir.glob('./test/' + task + '/' +  'in/*').length
    cmp = Compile.new
    cmp.compile_of(task, lang)

    exec_command = @config.make_exec_command(lang)

    input_files_length.times do |i|
      input_data = File.read('./test/' + task + "/in/#{i}")
      out, err, ww = Open3.capture3(exec_command, :stdin_data=>input_data)
      if ww.exitstatus != 0
        puts '[info] complete'
        puts err
        files = Dir.glob('./bin/*')
        files.each { |e| File.delete(e) }
        exit 1
      else
        f = File.open('./result/' + task + "/#{i}", "w")
        f.puts out
        f.close
      end
      puts "[info] \e[32msucess!!\e[m  #{input}"
    end

    puts '[info] complete'
    puts err
    files = Dir.glob('./bin/*')
    files.each { |e| File.delete(e) }
  end
end
