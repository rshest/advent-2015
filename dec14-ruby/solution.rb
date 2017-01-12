
DESCR_PATTERN = /(\S+)[^\d]*(\d+)[^\d]*(\d+)[^\d]*(\d+)/i

class Participant 
  attr_accessor :name 
  attr_accessor :speed_kms
  attr_accessor :fly_s
  attr_accessor :rest_s

  def self.parse(line)
    name, speed_kms, fly_s, rest_s = DESCR_PATTERN.match(line).captures
    new(name, Integer(speed_kms), Integer(fly_s), Integer(rest_s))
  end
 
  def initialize(name, speed_kms, fly_s, rest_s)
    @name = name
    @speed_kms = speed_kms
    @fly_s = fly_s 
    @rest_s = rest_s 
  end

  def to_s
    "#{@name} can fly #{@speed_kms} km/s for #{@fly_s} seconds,"\
    " but then must rest for #{@rest_s} seconds."
  end

  def get_distance(time)
    period_s = @fly_s + @rest_s
    rem = time % period_s
    @speed_kms*((time/period_s)*@fly_s + [rem, @fly_s].min)    
  end
end

def find_winner1(participants, time)
  distances = participants.map {|p| p.get_distance(time)}
  max_dist = distances.max
  idx = distances.index(max_dist)
  [participants[idx].name, max_dist]
end

def find_winner2(participants, time)
  n = participants.length
  scores = Array.new(n, 0)

  for t in 1..time
    distances = participants.map {|p| p.get_distance(t)}
    lead_dist = distances.max
    for i in 0..(n - 1)
      if distances[i] == lead_dist
        scores[i] += 1
      end
    end
  end
  
  max_score = scores.max
  idx = scores.index(max_score)
  [participants[idx].name, max_score]
end

participants = File
  .readlines(ARGV[0] || "input.txt")
  .map {|s| Participant.parse(s)}

time = Integer(ARGV[1] || "2503")

(winner1, dist) = find_winner1(participants, time)
puts "Winner 1: #{winner1}, distance: #{dist}." 

(winner2, score) = find_winner2(participants, time)
puts "Winner 2: #{winner2}, score: #{score}." 

