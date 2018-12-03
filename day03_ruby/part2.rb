grid = Hash.new

File.foreach("input.txt") do |line|
	id, claim_data = line.split(" @ ")
	start, size = claim_data.split(": ")

  	start_x, start_y = start.split(",").map { |str| str.to_i }
  	width, height    = size.split("x").map { |str| str.to_i }
  	end_x, end_y     = start_x + width, start_y + height

  	(start_x...end_x).each do |x|
	    (start_y...end_y).each do |y|
	      	key = "#{x}, #{y}"
	      	if grid[key].nil?
	      		grid[key] = [id]
	      	else
	      		grid[key].push(id)
	      	end
	    end
  	end

end

have_only_one = grid.values.select { |arr| arr.length == 1 }.flatten.uniq
have_multiple = grid.values.reject { |arr| arr.length == 1 }.flatten.uniq

puts have_only_one - have_multiple