Before("@create-code_buddy_rails2_test-gemset") do
  puts "possible Rails2 test gemset cleanup: "
  cmd = Kernel.open("|rvm gemset delete code_buddy_rails2_test", "w+")
  Kernel.sleep 5
  cmd.puts "yes"
  cmd.close
end

Before("@create-code_buddy_rails3_test-gemset") do
  puts "possible Rails3 test gemset cleanup: "
  cmd = Kernel.open("|rvm gemset delete code_buddy_rails3_test", "w+")
  Kernel.sleep 5
  cmd.puts "yes"
  cmd.close
end

