#!/usr/bin/env ruby

$LOAD_PATH << '.'
require "calendar_helper"

class MyCal
	include CalendarHelper
end


lines = File.readlines("agile_topics.txt")
r = rand(lines.size)
index = 0
done = Array.new
done[index] = r

25.times do
	while ! done.include?(r) do
		r = rand(lines.size)
	end
	r = rand(lines.size)
#	puts lines[r]
	index += 1
	done[index] = r
end

c = MyCal.new.calendar(:year => 2018, :month => 9, :table_class => "calendar_helper", :abbrev => true, :first_day_of_week => 1, :show_today => false)
puts c
