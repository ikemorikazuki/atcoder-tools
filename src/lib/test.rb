
require ENV['ABT'] + '/src/lib/config.rb'
require ENV['ABT'] + '/src/lib/compile.rb'

class Test
  def initialize
    @config = Config.new
  end

  def test(task, lang)
    input_files_length = Dir.glob('./test/' + task + '/' +  'in/*').length

    exec_command = @config.make_exec_command(task, lang)

    input_files_length.times do |i|
      input_data = File.read('./test/' + task + "/in/#{i+1}")
      out, err, ww = Open3.capture3(exec_command, :stdin_data=>input_data)
      if ww.exitstatus != 0
        puts '[info] complete'
        puts err
        files = Dir.glob('./bin/*')
        files.each { |e| File.delete(e) }
        exit 1
      else
        f = File.open('./result/' + task + "/#{i+1}", "w")
        f.puts out
        f.close
      end
      puts "[info] \e[32mtest sucess!!\e[m\n"
    end

    puts '[info] complete'
    files = Dir.glob('./bin/*')
    files.each { |e| File.delete(e) }
  end
end
