#!/usr/bin/env ruby

$LOAD_PATH << '.'
require "calendar_helper"
require 'getoptlong'
require 'date'

opts = GetoptLong.new(
	[ '--file', '-f', GetoptLong::REQUIRED_ARGUMENT ],          
	[ '--month', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--year', '-y', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--title', '-t', GetoptLong::OPTIONAL_ARGUMENT ] 
)

class MyCal
	include CalendarHelper
end

file  = "agile_topics.txt"
month = Date.today.month
year  = Date.today.year
title = "Agile calendar for #{month}"

opts.each do |opt, arg|
    case opt
	when '--file'
		file = arg
	when '--month'
		month = arg.to_i
	when '--year'
		year = arg.to_i
	when '--title'
		title = arg
	end
end


if ! lines = File.readlines(file)
then
	exit "Unable to open file #{file}"
end

lines.reject! { |c| c.chomp!; c.empty? }

r = rand(lines.size)
index = 0
done = Array.new
done[index] = r

repeat = lines.size > 31 ? 31 : lines.size
repeat.times do
   abrt = 0
	while done.include?(r)  && abrt < lines.size do
		r = rand(lines.size)
		abrt += 1
	end
	index += 1
	done[index] = r
end

c = MyCal.new.calendar(:year => year,
                       :month => month,
                       :abbrev => false,
                       :table_class => "calendar_helper",
                       :first_day_of_week => 1,
                       :show_today => false,
                       :calendar_title => title )  do |d|
	if ! d.saturday? && ! d.sunday? then
		[d.mday.to_s + "</br></br><b>" + lines[done[d.mday]].to_s + "</b>"]
	else
		[d.mday.to_s + "</br></br>&nbsp;&nbsp;Slack time&nbsp;&nbsp;"]
	end
end

puts "Content-Type: text/html\n\n" +
     "<html><body>" + 
     '<link rel="stylesheet" type="text/css" href="blue.css"></style>' +
     c + 
     "</body></html>\n\n"
