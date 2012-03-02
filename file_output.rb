
class SolutionOutput
  
  def initialize(rows)
    @rows=rows
  end
  
  def output
    
    #Output to console  and file 'solution'
      
    line = 0
    puts "*********************************"
    puts "********* SOLUTION **************"
    puts "*********************************"
    @rows.each do |i|
      puts "[#{i[0]}][#{i[1]}][#{i[2]}] | [#{i[3]}][#{i[4]}][#{i[5]}] | [#{i[6]}][#{i[7]}][#{i[8]}]"
      line = line+1
      puts "---------------------------------" if line%3==0
    end  
    File.open("test","w") do |f|
      @rows.each do |i|
	f.write("[#{i[0]}][#{i[1]}][#{i[2]}] | [#{i[3]}][#{i[4]}][#{i[5]}] | [#{i[6]}][#{i[7]}][#{i[8]}]\n")
	line = line+1
	f.write("---------------------------------\n") if line%3==0
      end       
    end
  end  #End output
end