
class Rule
  def initialize(@left : String, @right : String) end

  def self.parse(str : String) : Rule
    parts = str.split("=>").map &.strip
    Rule.new(parts[0], parts[1])
  end

  getter right
  setter right

  getter left
  setter left

  def apply(str : String) : Enumerable(String)
    pos = indices str, left
    n = left.size - 1
    pos.map {|k| str.sub k..(k + n), right}
  end
end

# returns all the indices of "pat"'s occurences in "str" 
def indices(str : String, pat : String) : Array(Int32)
  res = [] of Int32
  pos = 0
  loop do
    pos = str.index pat, pos
    if pos.nil? 
      break
    end
    res << pos
    pos += 1
  end
  res 
end

def apply_rules(str : String, rules : Array(Rule)) : Set(String)
  rules.map {|r| Set.new r.apply(str)}.reduce {|a, b| a|b}
end

def find_reduce_path(rules : Array(Rule), 
  str : String, target : String) : Enumerable(Int32)
  [] of Int32
end


fname = ARGV.size > 0 ? ARGV[0] : "input.txt"
lines = File.read(fname).split("\n").select {|s| s.size > 0}

rules = lines[0..-2].map {|s| Rule.parse(s)}
str = lines[-1]

res = apply_rules(str, rules)
puts "Number of derived strings: #{res.size}"

rpath = find_reduce_path(rules, "e", str)
puts "Reduce path length: #{rpath.size}"
