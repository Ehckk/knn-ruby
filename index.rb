class DataPoint
	attr_accessor :x, :y
	def initialize(x, y)
		self.x = x
		self.y = y
	end

	def point
		return [@x, @y]
	end
end

class KNN
	attr_accessor :data
	def initialize(data=[])
		self.data = data
	end

	def getPoints
		return @data
	end

	def getNearestNeighbors(x, y, k)
		distances = []
		@data.each do |point|
			d = Math.hypot((x - point.point[0]), (y - point.point[1])).round(2)
			distances.push({ :distance => d, :point => point})
		end
		sorted = distances.sort_by { |entry| entry[:distance] }
		return k > @data.length ? sorted : sorted[0,k]
	end

	def generatePoints(amount, limit)
		@data = []
		amount.times do |i|
			newPoint = DataPoint.new((rand * limit).round(2), (rand * limit).round(2))
			puts "\t(#{i}) #{newPoint.point}"
			@data.push(newPoint)
		end
		puts "Generated #{amount} points with values no greater than #{limit}!"
	end
end

def handleInput(knn, input)
	if input == 1
		print "Enter the number of points to generate: "
		n = gets.chomp.to_i
		print "Enter the maximum value of generated coordinates: "
		max = gets.chomp.to_i
		knn.generatePoints(n, max)
	elsif knn.getPoints.length > 0 and input == 2
		points = knn.getPoints.map { |point| "#{point.point}" }
		puts points.join(", ")
	elsif knn.getPoints.length > 0 and input == 3
		print "Enter x value: "
		x = gets.chomp.to_i
		print "Enter y value: "
		y = gets.chomp.to_i
		print "Enter the number of nearest points to find: "
		k = gets.chomp.to_i
		result = knn.getNearestNeighbors(x, y, k)
		puts "Nearest #{k} points of (#{x}, #{y}):"
		puts result.map { |entry| "\t#{entry[:point].point} - #{entry[:distance]}\n" }
	elsif input == 4
		puts "Goodbye!"
	else 
		puts "Invalid input! Should be option on menu"
	end
end

input = 0
knn = KNN.new()
while input != 4
	puts <<~MENU
KNN Demo - Ruby
Select an option:
	1. Generate points
	#{knn.getPoints.length > 0 ? "2. List all points" : ''}
	#{knn.getPoints.length > 0 ? "3. Find k nearest neighbors of a point" : ''}
	4. Exit
MENU
	print "Select an option: "
	begin
		input = gets.chomp.to_i
		handleInput(knn, input)	
	rescue TypeError
		puts "Invalid input! Should be whole number"
	ensure
		unless input == 4
			print "Press ENTER to continue: " 
			gets	
		end
	end
end