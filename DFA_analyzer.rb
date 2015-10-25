#File Template
#+------------------+          ##     {w | w states and ends with a}     ##
#|a\t   b\t   c\n   | Single characters in the alphabet seporated by tabs line ends with a return
#|1\t   3\t   3,f\n | State 0 (S0): a -> S1, b -> S3, c -> S3, Accept state = false
#|2\t   1\t   1,f\n | State 1 (S1): a -> S2, b -> S1, c -> S1, Accept state = false
#|2\t   1\t   1,t\n | State 2 (S2): a -> S2, b -> S1, c -> S1, Accept state = true
#|3\t   3\t   3,f\n | State 3 (S3): a -> S3, b -> S3, c -> S3, Accept state = false
#+------------------+

class DFA
  def initialize(file_name)
    @alphabet = Array.new
    @state_table = Array.new(1) {Array.new(1)}
    @accept = Array.new	
    @word = Array.new 		#the user's string as numbers
    self.read(file_name)
  end

# Read in the file wrapper
  def read(file_name)
    i = 0  #counter
    file = File.new(file_name)
    begin
      @alphabet[i] = file.readchar
      i += 1
    end while file.readchar == "\t"
    rread(file, 0)
    return
  end
  
#read each state in the DFA recursively
##file == file object
##state == current line of the state starting at 0
  def rread(file, i)
    delim = nil           #Holds the next char for delim checking
    temp = nil            #Holds the current value being written to
    temparray = Array.new #Array for the paths of the current state
    j = 0                 #counter
  #Read in all the things from the line
    begin
    temp = file.readchar
#Loop until \t or , is found then continue as normal
#This allows for DFAs larger than 10 states
      begin
      delim = file.readchar
        if delim == "\t" || delim == ","
          break
        else
          temp = temp + delim
        end
      end while true
      temparray[j] = temp.to_i #Convert to int and write to temporary array

      if delim == ","         #',' seporates for the accept state value
        delim = file.readchar #read in the accept state value
        file.readchar         #Read in the \n
        #Recursion
        if !file.eof
          rread(file, i+1)
        else
          @accept = Array.new(i)
          @state_table= Array.new(i) {Array.new(j+1)}
        end
      #write to the state table on recursive collapse
        @state_table[i] = temparray
        if delim == "t"
          @accept[i] = true
        else 
          if delim == "f"
            @accept[i] = false
	  end
        end
      end
      j += 1 #next col in the state table
    end while !file.eof
  end

# Matches each character in the user's string to the alphabet
# and creates an array of the matching letter's indexs in
# the same order as the users string 
# EX: alphabet = [a, b, c]; user_string = cab; @word= [2, 0] 
  def convert?(user_string)
    found = false #used to detect if a letter is found in the alphabet
    @word = Array.new

    userlen = user_string.length-1  #length of the user's string
    alphalen = @alphabet.length-1   #length of the alphabet
    for i in 0..userlen               #loop through the user_string
      found = false
      for j in 0..alphalen            #loop through the alphabet
        if @alphabet[j] == user_string[i] #is this char in the alpabet?
          @word[i] = j                    #set the equivelant loc in the word to the index
          found = true                    #this letter in the word was found
          break				  #stop searching
        end                                
      end
      if found == false
        return false
      end
    end
  return true  
  end

# Run the user's string (now an array of numbers) through the DFA
# return the index of the last state in the path.
  def compute #(state_table, word, val)
    val = 0
    for i in 0..@word.length-1
      val = @state_table[val][@word[i]]
    end
    return val
  end

# Retruns true if the state entered is an accept state
  def accept?(state)
    return @accept[state]
  end
end #CLASS

# simple function to ask if the user would like to do something again
def again?
  yn = nil
  puts "again? (y or n)"
  yn = gets
  if yn[0] == "y"
    return true
  end
return false #Not a 'y' they must have meant 'n'
end


## Main Program ##
user_string = String.new
puts "\n\nEnter the name of the DFA file you would like to use:"
file_name = gets.chomp
if File.exists?(file_name)
  dfa = DFA.new(file_name)
else
  puts "File does not exist"
  exit
end

begin
  puts "Input string to test against language: "
  user_string = gets.chomp

#  dfa.convert?(user_string)
  if dfa.convert?(user_string) && dfa.accept?(dfa.compute)
    puts "#{user_string} is part of the Language"
  else 
    puts "#{user_string} is NOT part of the Language"
  end
  user_string = nil

end while again? == true
__END__
