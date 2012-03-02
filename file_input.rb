
# Load the puzzle from 'problem' file
# Grab the Rows and organize into arrays
#############################################################################
class SudokuFile
  attr_accessor :rows
  
  def initialize
    
    #variables
    @rows = []
    
    #input file
    File.open('/home/rik/Documents/Sudoku/problem').each_line do |c|
      @rows << c.gsub("-","").gsub("[","").gsub("]","").gsub("|","").gsub("_","0").gsub(" ","").chomp unless c.include?"-"
    end
    
    #Setup
    #  rows[row][column]
    #  
    9.times {|n| @rows[n] = @rows[n].split("")}
           
  end
end