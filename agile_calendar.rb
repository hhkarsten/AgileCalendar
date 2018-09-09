#!/usr/bin/env ruby

$LOAD_PATH << '.'
require "calendar_helper"
require 'getoptlong'
require 'date'
require 'pp'

opts = GetoptLong.new(
	[ '--input', '-i', GetoptLong::OPTIONAL_ARGUMENT ],          
	[ '--month', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--output','-o', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--title', '-t', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--year',  '-y', GetoptLong::OPTIONAL_ARGUMENT ]
)

class MyCal
	include CalendarHelper
end

def header ()
	puts <<-EOF
Content-Type: text/html

<html><body>
<link rel="stylesheet" type="text/css" href="blue.css"></style>
EOF
end

def footer()
	puts <<-EOF
</body></html>

EOF
end

def print_it (content)
	puts "<!-- "
	pp ENV
	puts " -->"
	puts content
end


file  = "agile_topics.txt"
month = Date.today.month
year  = Date.today.year
title = "Agile calendar for #{month} / #{year}"

opts.each do |opt, arg|
	case opt
		when '--input'
			file = arg
		when '--month'
			month = arg.to_i
		when '--year'
			year = arg.to_i
		when '--title'
			title = arg
		when '--output'
			output = arg
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

content = MyCal.new.calendar(:year => year,
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

header
print_it(content)
footer
