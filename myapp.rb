require 'sinatra'
require 'sinatra/reloader'
 
get '/' do
@card = ""
@judge = "..."
erb :index
end


post '/' do
    @card = params[:card]
    input_card = @card
arr_card = input_card.split(" ").sort.join


# flash の判定。５つ同じスートであればflashを返す。
def is_flash? arr_card
flash = arr_card.
		scan(/[SDHC]/).
		group_by{ |i| i }.
        values.
        map( &:size )
	if flash == [5]
		return true
	end
end



int_sorted_card = arr_card.
			  scan(/\d+/).
			  map(&:to_i).
			  sort

def	is_straight? int_sorted_card
	if int_sorted_card[0] == 1 && 
	   int_sorted_card[1] == 10 &&
	   int_sorted_card[2] == 11 &&
	   int_sorted_card[3] == 12 &&
	   int_sorted_card[4] == 13 

		return true
	end

	int_sorted_card.
	each_with_index do | e, i |
		unless i == 0
			unless e - 1 == int_sorted_card[i-1] 
				return false
			end
		end
	end
	return false if int_sorted_card.length != 5
	return true
end

# それ以外の判定
def is_hand? int_sorted_card
	key = int_sorted_card.
	      group_by{ |i| i }.
	      values.
	      map( &:size ). # [4,1]
	      sort.
	      join.
	      to_i

	result = {14=>'four of a kind',
			  23=>'full house', 
			  113=>'three of a kind', 
			  122=>'two pair', 
			  1112=>'one pair', 
			  11111=>'high card' }
	return result[key]
end

	# 判定
	a = is_flash? arr_card 
	b = is_straight? int_sorted_card
	c = is_hand? int_sorted_card

@judge = 
	if a && b == true
		"straight flash"
	elsif a == true
		"flash"
	elsif b == true
		"straight"
	else 
		c
	end

    erb :index
end


