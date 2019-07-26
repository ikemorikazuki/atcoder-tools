require 'toml-rb'

hash =  TomlRB.load_file("../config.toml")

puts hash
puts hash["languages"]["Rust"]["compile"]
