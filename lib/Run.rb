require 'open3'

module Run

    def finish(text, err)
      puts "[info] " + text
      print err
      files = Dir.glob('./bin/*')
      files.each { |e| File.delete(e) }
    end
#########################################################

    def run_rb(file)
      Open3.capture3("ruby ./src/Ruby/#{file}")
    end

    def run_hs(file)
      puts "[info] compile now ..."
      o, e, w = Open3.capture3("stack ghc -- " + "./src/Haskell/#{Shellwords.escape(file)}" +  " -outputdir ./bin -o ./bin/Main")

      if w.exitstatus != 0
        finish("\e[31mFAILED comlied :(\e[m", e + "\n")
        exit 1
      end

      puts "[info] comiled!!!"
      puts o

      Open3.capture3('./bin/Main')
    end

    module_function :finish, :run_rb, run_hs
end
