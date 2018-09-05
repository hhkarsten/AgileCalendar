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
	while done.include?(r) do
		r = rand(lines.size)
	end
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
		[d.mday.to_s + "</br></br>" + lines[done[d.mday]].to_s]
	else
		[d.mday.to_s + "</br></br>&nbsp;&nbsp;Slacktime&nbsp;&nbsp;"]
	end
end

puts "Content-Type: text/html\n\n" +
     "<html><body>" + 
     '<link rel="stylesheet" type="text/css" href="blue.css"></style>' +
     c + 
     "</body></html>\n\n"
