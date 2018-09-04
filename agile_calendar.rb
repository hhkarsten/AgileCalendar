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

31.times do
	while ! done.include?(r) do
		r = rand(lines.size)
	end
	r = rand(lines.size)
	index += 1
	done[index] = r
end

c = MyCal.new.calendar(:year => 2018,
                       :month => 10,
                       :table_class => "calendar_helper",
                       :first_day_of_week => 1,
                       :show_today => false,
                       :calendar_title => "Agile calendar" )  do |d|
	if ! d.saturday? && ! d.sunday? then
		content = d.mday.to_s + "</br></br>" + lines[d.mday].to_s
		[content]
	end
end

puts "<html><body>" + 
     '<link rel="stylesheet" type="text/css" href="blue.css"></style>' +
     c + 
     "</body></html>"
