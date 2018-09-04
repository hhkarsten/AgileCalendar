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
#	puts lines[r]
	index += 1
	done[index] = r
end
listOfSpecialDays = Array.new()

c = MyCal.new.calendar(:year => 2018,
                       :month => 10,
                       :table_class => "calendar_helper",
                       :abbrev => 0..-1,
                       :first_day_of_week => 1,
                       :show_today => false,
                       :calendar_title => "Agile calendar")  do |d|
	if ! d.saturday? && ! d.sunday? then
		content = d.mday.to_s + "</br>" + lines[d.mday].to_s
		[content]
	end
end



#   calendar(:year => 2005, :month => 5) do |d| # This generates a simple calendar, but gives special days
#     if listOfSpecialDays.include?(d)          # (days that are in the array listOfSpecialDays) one CSS class,
#       [d.mday, {:class => "specialDay"}]      # "specialDay", and gives the rest of the days another CSS class,
#     else                                      # "normalDay". You can also use this highlight today differently
#       [d.mday, {:class => "normalDay"}]       # from the rest of the days, etc.
#     end
#   end

puts c

