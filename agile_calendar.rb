#!/usr/bin/env ruby

def put_line
	puts "---------------------------------------------------------------------------------\n\n"
end

lines = File.readlines("AgileTopics.txt")
r = rand(lines.size)
index = 0
done = Array.new
done[index] = r

put_line

25.times do
	while ! done.include?(r) do
		r = rand(lines.size)
	end
	r = rand(lines.size)
	puts lines[r]
	index += 1
	done[index] = r
end

put_line

