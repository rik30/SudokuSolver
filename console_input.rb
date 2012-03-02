# Load the puzzle from console
# Take in lines of numbers, 9 characters long
#############################################################################
class ConsoleInput
  attr_accessor :rows
  
  def initialize
    
    #variables
    @rows = []
    
    puts "Numbers only, no spaces. Press enter to seperate lines. Unknown numbers should be 0"
    puts "Input:"    
    #grab a row
    9.times do |row|

      print "Row ##{row+1}:"
      @rows[row] = gets.chomp!
      @rows[row] = @rows[row].split("")
    end
  end
  
  #Output solution to console
  #=================================================================================
  def solution
    line = 0
    puts "*********************************"
    puts "********* SOLUTION **************"
    puts "*********************************"
    @rows.each do |i|
      puts "[#{i[0]}][#{i[1]}][#{i[2]}] | [#{i[3]}][#{i[4]}][#{i[5]}] | [#{i[6]}][#{i[7]}][#{i[8]}]"
      line = line+1
      puts "---------------------------------" if line%3==0 end
  end  
end