#This ruby file will solve a sudoku
#
#When constructing the solver, the values in all the rows must be provided
#in a 2D Array containing strings. Unknown values must be "0"
#Eg. [["0","6","0","0","1","2","3","0","0"],["0","1",........]]



# Validate uniqueness of rows, cols and blocks
# Attempt to solve the puzzle
#############################################################################
class Solver
  attr_reader :valid, :rows
  
  #Get all the rows and create a solution string
  #Solution: The output for the solved puzzle
  #=================================================================================
  def initialize(rows)
    @rows = rows  
    @cols = []
    @blks = []
    adjust_values
    @solution = ""
    @valid = validate_all
    @solved = false
    @value_changed = true
  end
  
  #Adjust the value of columns and blocks based on rows. Called every time
  #a block is solved
  #================================================================================= 
  def adjust_values
    @cols = @rows.transpose
    @blks[0] = [@rows[0][0], @rows[0][1], @rows[0][2], @rows[1][0], @rows[1][1], @rows[1][2], @rows[2][0], @rows[2][1], @rows[2][2]] #1
    @blks[1] = [@rows[0][3], @rows[0][4], @rows[0][5], @rows[1][3], @rows[1][4], @rows[1][5], @rows[2][3], @rows[2][4], @rows[2][5]] #2
    @blks[2] = [@rows[0][6], @rows[0][7], @rows[0][8], @rows[1][6], @rows[1][7], @rows[1][8], @rows[2][6], @rows[2][7], @rows[2][8]] #3
    @blks[3] = [@rows[3][0], @rows[3][1], @rows[3][2], @rows[4][0], @rows[4][1], @rows[4][2], @rows[5][0], @rows[5][1], @rows[5][2]] #4 
    @blks[4] = [@rows[3][3], @rows[3][4], @rows[3][5], @rows[4][3], @rows[4][4], @rows[4][5], @rows[5][3], @rows[5][4], @rows[5][5]] #5
    @blks[5] = [@rows[3][6], @rows[3][7], @rows[3][8], @rows[4][6], @rows[4][7], @rows[4][8], @rows[5][6], @rows[5][7], @rows[5][8]] #6
    @blks[6] = [@rows[6][0], @rows[6][1], @rows[6][2], @rows[7][0], @rows[7][1], @rows[7][2], @rows[8][0], @rows[8][1], @rows[8][2]] #7
    @blks[7] = [@rows[6][3], @rows[6][4], @rows[6][5], @rows[7][3], @rows[7][4], @rows[7][5], @rows[8][3], @rows[8][4], @rows[8][5]] #8
    @blks[8] = [@rows[6][6], @rows[6][7], @rows[6][8], @rows[7][6], @rows[7][7], @rows[7][8], @rows[8][6], @rows[8][7], @rows[8][8]] #9   
    solved
  end
  
  #Validate that the provided puzzle has unique rows,columns and blocks
  #=================================================================================  
  def validate_all    
    valid = true
    valid = validate(@rows)? valid : false
    valid = validate(@cols)? valid : false
    valid = validate(@blks)? valid : false
  end
  
  #Validate one section for uniqueness
  #=================================================================================
  def validate(section)
    
    #Rows, Columns or Blocks
    #--------------------------------------------------
    section.each do |i|
      check = i.sort.join.squeeze("0")
      if check.length > check.split("").uniq.length
	puts "***************************************************"
	puts "Failed Validation, Values did not meet sudoku rules"
	puts "***************************************************"
	return false
      end
    end 
    
    #Return true if all validations passed
    #--------------------------------------------------
    return true
  end
  
  #Determine if the puzzle is solved and set instance variable
  #=================================================================================
  def solved
    @solved = @rows.flatten.include?("0") ? false : true
  end
  
  #Loop through solve techniques until solved
  #=================================================================================
  def solve

    #Loop until the puzzle is solved or until one
    #loop didn't change any values
    #--------------------------------------------------
    puzzle_check
    
    #If the puzzle wasn't solved, try one more time
    if !@value_changed
      @value_changed = true
      puzzle_check
    end
     
    puts "Solved: #{@solved}, Unable to solve:#{!@value_changed}"
  end
  
  def puzzle_check
    
    while @solved == false and @value_changed == true
    
    #Reset value changed flag
    #-----------------------------------------------
    @value_changed = false
    
    #Check entire grid
    #------------------------------------------------
    9.times do |row|
      9.times do |col|
	if @rows[row][col] == "0"
	  @value_changed = internal_check?(row,col) ? true : @value_changed
	end
	if @rows[row][col] == "0"
	  @value_changed = external_check?(row,col) ? true : @value_changed
	end
      end
    end
   end #end while 
  end
  
  #Check a block to see if it is solvable, looking at the rows columns and the 
  #3x3 Block it belongs to for uniqueness. If the block is only able to have one
  #Value, it will be solved.
  #=================================================================================
  def internal_check?(row, col)

    values = [@rows[row], @cols[col], @blks[find_block(row,col)]] #Values related to the section
    
    #Check for a missing value
    #-------------------------------         
    values = values.flatten.uniq.join.gsub("0","")
    values = "123456789".tr(values,"")
    if values.length == 1
      @rows[row][col] = values.to_s
      adjust_values
      return true
    else
      return false
    end
  end
  
  #Check a block to see if it is solvable, looking at the rows columns and the 
  #3x3 Block it belongs to for uniqueness. If the block is the only block from either
  #its row, column, or 3x3 block that can have a certain value, it will be solved.
  #=================================================================================
  def external_check?(row,col)
    
    #Get values available in this block
    #------------------------------------------------------------------
    values = [@rows[row], @cols[col], @blks[find_block(row,col)]] #Values related to the section
    values = values.flatten.uniq.join.gsub("0","")
    values = "123456789".tr(values,"")
    
    section = []
    
    #Check row
    #Get values available in the other blocks in the current row
    #---------------------------------------------------------------------------------------------------
    9.times do |i|
      if @rows[row][i] == "0"
	section << internal_check(row,i) unless col==i
      end
    end
    
    section = section.join.split("").sort.uniq.join.gsub("0","")
    values_row = values.tr(section,"")
    
    if values_row.length == 1
      @rows[row][col] = values_row.to_s
      adjust_values
      return true
    else
      return false
    end    
    #Check column
    #Get values available in the other blocks in the current column
    #---------------------------------------------------------------------------------------------------
    9.times do |i|
      if @rows[row][i] == "0"
	section << internal_check(i,col) unless row==i
      end
    end
    
    section = section.join.split("").sort.uniq.join.gsub("0","")
    
    values_col = values.tr(section,"")
    if values_col.length == 1
      @rows[row][col] = values_col.to_s
      adjust_values
      return true
    else
      return false
    end    
    
    #Check block
    #Get values available in the other blocks in the current block
    #---------------------------------------------------------------------------------------------------
    blk = find_block(row,col)
    case blk
    when 0
      3.times do |r|
	3.times do |c|
	  section << internal_check(r-1,c-1) unless r=row and c=col
	end
      end
    when 1
      3.times do |r|
	3.times do |c|
	  section << internal_check(r-1,c+2) unless r=row and c=col
	end
      end
    when 2
      3.times do |r|
	3.times do |c|
	  section << internal_check(r-1,c+5) unless r=row and c=col
	end
      end
    when 3
      3.times do |r|
	3.times do |c|
	  section << internal_check(r+2,c-1) unless r=row and c=col
	end
      end
    when 4
      3.times do |r|
	3.times do |c|
	  section << internal_check(r+2,c+2) unless r=row and c=col
	end
      end
    when 5
      3.times do |r|
	3.times do |c|
	  section << internal_check(r+2,c+5) unless r=row and c=col
	end
      end
    when 6
      3.times do |r|
	3.times do |c|
	  section << internal_check(r+5,c-1) unless r=row and c=col
	end
      end
    when 7
      3.times do |r|
	3.times do |c|
	  section << internal_check(r+5,c+2) unless r=row and c=col
	end
      end
    else  
      3.times do |r|
	3.times do |c|
	  section << internal_check(r+5,c+5) unless r=row and c=col
	end
      end
    end 
    
    @blks[blk].each do |i|
      if @rows[row][i] == "0"
	section << internal_check(row,i) unless col==i
      end
    end
    
    section = section.join.split("").sort.uniq.join.gsub("0","")
    
    values_block = values.tr(section,"")   
    if values_block.length == 1
      @rows[row][col] = values_block.to_s
      adjust_values
      return true
    else
      return false
    end        
  end
  
  #Check a block for values it cannot be and return them
  #=================================================================================
  def internal_check(row, col)
  
    values = [@rows[row], @cols[col], @blks[find_block(row,col)]] #Values related to the section   
    values = values.flatten.uniq.join.gsub("0","")
    values = "123456789".tr(values,"")
    values
    
  end  
  
  #Find what block the given Row,Col coordinates is at
  #=================================================================================
  def find_block(row,col)
    
    #Find block
    #--------------------------------
    case row
    when 0,1,2
      if col < 3
	return 0
      elsif col < 6
	return 1
      else 
	return 2
      end
    when 3,4,5
      if col < 3
	return 3
      elsif col < 6
	return 4
      else 
	return 5
      end      
    else
      if col < 3
	return 6
      elsif col < 6
	return 7
      else 
	return 8
      end      
    end    
  end
end


