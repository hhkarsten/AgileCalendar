#!/usr/bin/env ruby
# encoding: UTF-8

$LOAD_PATH << '.'
require "calendar_helper"
require 'getoptlong'
require 'date'
require 'pp'
require 'cgi'

class MyCal
	include CalendarHelper
end

$myglobal = ""
$month   = Date.today.month
$year    = Date.today.year
$overall = ""
$title   = ""

def is_http ()

	if ENV["QUERY_STRING"]
	then
		[true]
	end
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
	puts content
	puts "<!-- "
	puts "\n\n\n- "
	puts $myglobal
	puts " -\n\n\n"
	puts "\ninput: "
	puts $file
	puts "\nmonth:"
	puts $month
	puts "\ntitle: "
	puts $title
	puts "\nyear: "
	puts $year
	puts "\n\n\n"
	puts "OVERALL\n"
	puts $overall
	puts " -->"
end


if is_http() then
	params = CGI::parse(ENV["QUERY_STRING"])

	params.each_pair { |key, value|
		case key
			when "month"
				$month = value[0].to_i
			when "title"
				$title = value[0].to_s
			when "year"
				$year = value[0].to_i
		end
	}
	opts = []
else
	opts = GetoptLong.new(
		[ '--input', '-i', GetoptLong::OPTIONAL_ARGUMENT ],          
		[ '--month', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
		[ '--output','-o', GetoptLong::OPTIONAL_ARGUMENT ],
		[ '--title', '-t', GetoptLong::OPTIONAL_ARGUMENT ],
		[ '--year',  '-y', GetoptLong::OPTIONAL_ARGUMENT ]
	)
end



opts.each do |opt, arg|
	case opt
		when '--input'
			$file = arg
		when '--month'
			$month = arg.to_s
		when '--year'
			$year = arg.to_s
		when '--title'
			$title = arg
		when '--output'
			$output = arg
	end
end

$file  = "agile_topics.txt"

if $year.to_i < Date.today.year.to_i then
	$year = Date.today.year
end

if $month.to_i < 1 || $month.to_i > 12 then
	$month = Date.today.month
end

if $title == "" then
	$title = "My Agile calendar for #{Date::MONTHNAMES[$month]} #{$year}"
end

if ! lines = File.readlines($file)
then
	exit "Unable to open file #{$file}"
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

content = MyCal.new.calendar(:year => $year,
                       :month => $month,
                       :abbrev => false,
                       :table_class => "calendar_helper",
                       :first_day_of_week => 1,
                       :show_today => false,
                       :calendar_title => $title )  do |d|
	if ! d.saturday? && ! d.sunday? then
		[d.mday.to_s + "</br></br><b>" + lines[done[d.mday]].to_s + "</b>"]
	else
		[d.mday.to_s + "</br></br>&nbsp;&nbsp;Slack time&nbsp;&nbsp;"]
	end
end

header
print_it(content)
footer


