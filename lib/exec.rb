require 'open3'
require 'shellwords'

module Exec
  # DEBUG: exec_c, exec_pyの実装が残っている

  def save(content, task, name)
    f = File.open('./result/' + task + '/' + name, "w")
    f.puts content
    f.close
  end

  def finish(text, err)
    puts "[info] " + text
    print err
    files = Dir.glob('./bin/*')
    files.each { |e| File.delete(e) }
  end

  def exec_rb(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' +  'in/*').sort

    input_files_path.each  do |input|
      name = input[-1]

      input_data = File.read('./test/' + task + '/in/' + name)
      o, e, w = Open3.capture3("ruby " + "./src/Ruby/#{Shellwords.escape(file)}" , :stdin_data=>input_data)

      if w.exitstatus != 0

        puts e
        return false
      else
        printf("\e[36mSAMPLE[%s]\e[m >>>>> %s", name, o) if rt
        save(o, task, name)
      end
    end
  end



  def exec_hs(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' +  'in/*').sort

    printf("[info] compile now ...\n")
    o, e, w = Open3.capture3("stack ghc -- " + "./src/Haskell/#{Shellwords.escape(file)}" +  " -outputdir ./bin -o ./bin/Main")

    if w.exitstatus != 0
      finish("\e[31mFAILED comlied :(\e[m", e + "\n")
      return false
    end

    puts "[info] comiled!!!"
    puts o


    input_files_path.each  do |input|
      name = input[-1]
      input_data = File.read('./test/' + task + '/in/' + name)
      out, err, ww = Open3.capture3('./bin/Main', :stdin_data=>input_data)

      if ww.exitstatus != 0
        finish("\e[31mFAILED :(\e[m", err + "\n")
        return false
      else
        printf("\e[36mSAMPLE[%s]\e[m >>>>> %s\n", name, out) if rt
        save(out, task, name)
      end
      puts "[info] \e[32msucess!!\e[m  #{input}"
    end
    finish("complete","")
    return true
  end


  def exec_rs(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' +  'in/*').sort

    printf("[info] compile now ...\n")
    o, e, w = Open3.capture3("rustc -O ./src/Rust/#{Shellwords.escape(file)}  -o ./bin/Main")

    if w.exitstatus != 0
      finish("\e[31mFAILED comiled :(\e[m", e + "\n")
      o, e, _ = Open3.capture3("rustc --explain E0573")
      puts e
      return false
    end

    puts "[info] \e[32mcomiled!!!\e[m "
    puts e
    #puts o


    input_files_path.each  do |input|
      name = input[-1]
      input_data = File.read('./test/' + task + '/in/' + name)
      out, err, ww = Open3.capture3('RUST_BACKTRACE=1 ./bin/Main', :stdin_data=>input_data)

      if ww.exitstatus != 0
        finish("\e[31mFAILED :(\e[m", err + "\n")
        return false
      else
        printf("\e[36mSAMPLE[%s]\e[m >>>>> %s\n", name, out) if rt
        save(out, task, name)
      end
      puts "[info] \e[32msucess!!\e[m  #{input}"
    end
    finish("complete","")
    return true
  end

  def exec_scala(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' + 'in/*').sort

    printf("[info] compile now ...\n")
    _, e, w = Open3.capture3("scalac -d" + " ./bin" + " ./src/Scala/#{Shellwords.escape(file)}")

    if w.exitstatus != 0
      finish("FAILED comiled", e + "\n")
      return false
    end
    printf("[info] compiled!!\n")

    input_files_path.each  do |input|

      name = input[-1]
      input_data = File.read('./test/' + task + '/in/' + name)
      out, err, ww = Open3.capture3('scala -cp ./bin Main', :stdin_data=>input_data)
      if ww.exitstatus == 1
        finish("FAILED", err + "\n")
        return false
      else
        printf("\e[36mSAMPLE[%s]\e[m >>>>> %s", name, out) if rt
        save(out, task, name)
      end
      puts "[info] sucess!! #{input}"
    end
    finish("sucess!!!", "")
    return true
  end


  def exec_go(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' + 'in/*').sort

    printf("[info] compile now ...\n")
    _, e, w = Open3.capture3("go build -o" + " ./bin/Main" + " ./src/Go/#{Shellwords.escape(file)}")

    if w.exitstatus != 0
      finish("FAILED comiled", e + "\n")
      return false
    end
    printf("[info] compiled!!\n")

    input_files_path.each  do |input|

      name = input[-1]
      input_data = File.read('./test/' + task + '/in/' + name)
      out, err, ww = Open3.capture3('./bin/Main', :stdin_data=>input_data)
      if ww.exitstatus != 0
        finish("FAILED", err + "\n")
        return false
      else
        printf("\e[36mSAMPLE[%s]\e[m >>>>> %s", name, out) if rt
        save(out, task, name)
      end
      puts "[info] sucess!! #{input}"
    end
    finish("sucess!!!", "")
    return true
  end



  module_function :save, :finish, :exec_rb, :exec_hs, :exec_scala, :exec_rs, :exec_go
end


# Exec.exec_rb("A - Double Helix.rb", true)
