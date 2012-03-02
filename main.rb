require_relative 'solver.rb'
require_relative 'file_input.rb'
require_relative 'console_input.rb'
require_relative 'file_output.rb'

###################
#       Main      #
###################

#Get input type
type = []

until type.first == "f" or type.first == "c"
  print "Input from file or console?(f/c)"
  type = gets.chomp!
  type=type.split("")
end

puzzle = ""

if type[0] == "f"
  #Load puzzle from file
  puzzle = SudokuFile.new
end

if type[0] == "c"
  #Load puzzle from console
  puzzle = ConsoleInput.new
end


#Load rows into puzzle solver
solver = Solver.new(puzzle.rows)
if solver.valid
  solver.solve
end

#Load rows for output
output = SolutionOutput.new(solver.rows)
output.output