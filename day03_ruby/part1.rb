grid = Hash.new

File.foreach("input.txt") do |line|
  start, size = line.split(" @ ").last.split(": ")

  start_x, start_y = start.split(",").map { |str| str.to_i }
  width, height    = size.split("x").map { |str| str.to_i }

  end_x, end_y = (start_x + width - 1), (start_y + height - 1)

  (start_x..end_x).each do |x|
  	(start_y..end_y).each do |y|
  	  key = "#{x}, #{y}"
  	  if grid.has_key?(key)
  	  	grid[key] += 1
  	  else
  	  	grid[key] = 1
  	  end
  	end
  end
end

puts grid.values.reject { |coord| coord == 1 }.length