#!/usr/bin/env ruby

lines = File.readlines("AgileTopics.txt")
r = rand(lines.size)
index = 0
done = Array.new
done[index] = r

puts "---------------------------------------------------------------------------------\n\n"

25.times do
	while ! done.include?(r) do
		r = rand(lines.size)
	end
	r = rand(lines.size)
	puts lines[r]
	index += 1
	done[index] = r
end

puts "\n\n---------------------------------------------------------------------------------\n\n"

