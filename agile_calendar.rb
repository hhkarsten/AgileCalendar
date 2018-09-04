#!/usr/bin/env ruby

$LOAD_PATH << '.'
require "calendar_helper"

class MyCal
	include CalendarHelper
end


def put_line
	puts "---------------------------------------------------------------------------------\n\n"
end

lines = File.readlines("agile_topics.txt")
r = rand(lines.size)
index = 0
done = Array.new
done[index] = r

#put_line

25.times do
	while ! done.include?(r) do
		r = rand(lines.size)
	end
	r = rand(lines.size)
#	puts lines[r]
	index += 1
	done[index] = r
end

#put_line


c = MyCal.new.calendar(:year => 2018, :month => 9, :table_class => "calendar_helper", :abbrev => true, :first_day_of_week => 1)
puts c
