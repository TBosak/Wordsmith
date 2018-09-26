module Wordsmith
require 'ruby-dictionary'
require 'colorize'
require 'yaml'

Vowels = {A:1, E:1, I:1, O:1}
Commonconsonants = {T:1, R:1, S:1, L:1, N:1, D:2, G:2}
Rareconsonants = {K:5, J:8, X:8, Q:10, Z:10}
Mids = {U:1, C:3, M:3, B:3, P:3, H:4, F:4, W:4, Y:4, V:4}
Pool = []
All={}
RoundTotal=[]
GameTotal=[]
dictionary = Dictionary.from_file('words.txt')

puts "Welcome to Wordsmith!\nRules of the Game: Use letters provided in the pool however many times necessary in any combination to score points.\nEach letter has a point value, the sum of which is multiplied by your word length.\nThere are 10 rounds. Enjoy!\n".yellow
x = 10
while x > 0 do
  x -= 1
  puts "Round #{10-x}\n\n"
vowel1 = Vowels.keys.sample
vowel2 = Vowels.keys.sample
cons1 = Commonconsonants.keys.sample
cons2 = Commonconsonants.keys.sample
mids1 = Mids.keys.sample
mids2 = Mids.keys.sample
rare = Rareconsonants.keys.sample
while vowel1 == vowel2 do
vowel2 = Vowels.keys.sample
end
while cons1 == cons2 do
  cons2 = Commonconsonants.keys.sample
end
while mids1 == mids2 do
  mids2 = Mids.keys.sample
end
Pool.push(vowel1, vowel2, cons1, cons2, mids1, mids2, rare)
puts "Use only the following letters to create a word:\n#{Pool}\n\n".green
puts "#{vowel1} is worth #{Vowels[vowel1]} point(s), #{vowel2} is worth #{Vowels[vowel2]} point(s),\n#{cons1} is worth #{Commonconsonants[cons1]} point(s), #{cons2} is worth #{Commonconsonants[cons2]} point(s),\n #{mids1} is worth #{Mids[mids1]} point(s), #{mids2} is worth #{Mids[mids2]} point(s), and #{rare} is worth #{Rareconsonants[rare]} point(s).\n\n".green
input=gets.chomp.upcase
answer=[(input.split"")]
answer[0].map!{|x| x.to_sym}
y = 0
z = 0
answer[0].each do |x|
  if Pool.include?(x) == true
  y += 1
  #x = x.to_s.to_i
  #Pool.delete_at(x)
  #puts Pool
end
end
answer[0].each{|x| if dictionary.exists?(input) == true && y == input.length && input.length > 1
 if Vowels.key?(x) == true
  puts "#{x} is worth #{Vowels[x]} points".blue
  RoundTotal << Vowels[x].to_i
elsif Commonconsonants.key?(x) == true
  puts "#{x} is worth #{Commonconsonants[x]} points".blue
  RoundTotal << Commonconsonants[x].to_i
elsif Rareconsonants.key?(x) == true
  puts "#{x} is worth #{Rareconsonants[x]} points".blue
  RoundTotal << Rareconsonants[x].to_i
elsif Mids.key?(x) == true
  puts "#{x} is worth #{Mids[x]} points".blue
  RoundTotal << Mids[x].to_i
end
else
z += 1
if z == input.length
puts "Sorry, your word is not recognized. 0 Points\n\n".red end end}
sleep 1
puts "Length Multiplier: x#{input.length}\n".blue
puts "Round Total: #{RoundTotal.sum * input.length}\n".blue
GameTotal << (RoundTotal.sum * input.length)
RoundTotal.clear
Pool.clear
sleep 1
end

while x == 0
  puts "Your final score is #{GameTotal.sum}\nEnter your name:".blue
  name = gets.chomp
  scores = YAML.load_file("highscores.yml")
  scores[name] = GameTotal.sum
  File.open('highscores.yml', 'w') {|f| f.write(scores.to_yaml) }
  puts "High Scores:\n".yellow
  sortedscores = scores.sort_by {|k,v| -v}[0..4]
  sortedscores.each {|key, value| puts "#{key}...................................#{value}".yellow}
x -= 1
end
end
