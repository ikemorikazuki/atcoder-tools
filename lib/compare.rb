require '/Users/ikemorikaduki/Documents/Myprograming/atcoder-tools/lib/exec.rb'
require 'shellwords'



module Compare

  def print_aclist(list)
    list.each_with_index do |bool, i|
      if bool
        printf("%d:=> \e[32;1mAC\e[m  ", i+1)
      else
        printf("%d:=> \e[31;1mWA\e[m  ", i+1)
      end
    end
    puts
    printf("--------------------------------------\n\n")
  end

  def print_AC_WA(out, result, number)
    # TEMP: まだ装飾する余地あり
    printf("\e[36mSAMPLE[%d]\e[m >>>>>  ", number + 1)
    if out == result
      printf("\e[32;1mAC\e[m\n")
      printf("CORRECT: \n%s\n", out)
      printf("ANSWER: \n\e[32;1m%s\e[m\n", result)
    else
      printf("\e[31;1mWA\e[m \n")
      printf("CORRECT: \n%s\n", out)
      printf("ANSWER: \n\e[31;1m%s\e[m\n", result)
    end
    printf("--------------------------------------\n")
  end

  def compare(file)

    task = File.basename(file, '.*')

    out_paths = Dir.glob('./test/' + task + '/out/*').sort
    ac_list = []

    out_paths.each_with_index do |path, i|
      name = File.basename(path, '.*')
      out = File.read(path)
      result = File.read('./result/' + task + '/' + name )
      print_AC_WA(out, result, i)
      ac_list[i] = out == result ? true : false
    end
    print_aclist(ac_list)
  end

  module_function :print_aclist, :print_AC_WA, :compare
end

# Compare.compare("A - Double Helix.rb")
