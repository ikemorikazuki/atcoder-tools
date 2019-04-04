require 'open3'
require 'shellwords'

module Exec
  # DEBUG: exec_c, exec_py, exec_scalaの実装が残っている

  def save(content, task, name)
    f = File.open('./result/' + task + '/' + name, "w")
    f.puts content
    f.close
  end

  def exec_rb(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' +  'in/*')

    input_files_path.each  do |input|
      name = input[-1]

      input = File.read('./test/' + task + '/in/' + name)
      o, e, _ = Open3.capture3("ruby " + "./src/#{Shellwords.escape(file)}" , :stdin_data=>input)

      if e != ""
        puts "[info] FAILED"
        puts e
        exit 1
      else
        printf("\e[36mSAMPLE[%s]\e[m >>>>> %s", name, o) if rt
        save(o, task, name)
      end
    end
  end



  def exec_hs(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' +  'in/*')

    input_files_path.each_with_index  do |input, i|
      name = input[-1]
      e = ""

      input = File.read('./test/' + task + '/in/' + name)
      if i == 0
        printf("[info] compile now ...\n")
        o, e, _ = Open3.capture3("stack ghc -- " + "./src/#{Shellwords.escape(file)}" +  " -outputdir ./bin -o ./bin/Main")
        printf("[info] comiled!!\n") 
      end

      if e != ""
        puts "[info] FAILED"
        puts e
        exit 1
      else
        puts o
        out, err, _ = Open3.capture3('./bin/Main', :stdin_data=>input)
        if err != ""
          puts "[info] FAILED"
          puts e
          exit 1
        else
          printf("\e[36mSAMPLE[%s]\e[m >>>>> %s", name, out) if rt
          save(out, task, name)
        end
      end
    end
  end

  def exec_scala(file, rt)
    # fileはrubyプログラム
    task = File.basename(file, ".*")

    input_files_path = Dir.glob('./test/' + task + '/' +  'in/*')

    input_files_path.each_with_index  do |input, i|
      name = input[-1]
      e = ""

      input = File.read('./test/' + task + '/in/' + name)

      if i == 0
        printf("[info] compile now ...")
        o, e, _ = Open3.capture3("scalac -d" + " ./bin"+ " ./src/#{Shellwords.escape(file)}")
        printf("[info] compiled!!\n")
      end

      if e != ""
        puts "[info] FAILED"
        puts e
        exit 1
      else
        puts o
        out, err, _ = Open3.capture3('scala -cp ./bin Main', :stdin_data=>input)
        if err != ""
          puts "[info] FAILED"
          puts e
          exit 1
        else
          printf("\e[36mSAMPLE[%s]\e[m >>>>> %s", name, out) if rt
          save(out, task, name)
        end
      end
    end
  end

  module_function :save, :exec_rb, :exec_hs, :exec_scala
end


# Exec.exec_rb("A - Double Helix.rb", true)
