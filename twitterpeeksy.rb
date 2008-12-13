#!/usr/bin/env ruby
#
# twitterpeeksy.rb - View recent tweets in your friends timeline from
# Twitter
#
# Brian Tanaka, brian@briantanaka.com
#
# note: this is the kludgey, pre-refactored version

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'optparse'

# set the line below to the filepath of your config if not standard
configfile = File.expand_path('~/.twitterpeeksy')

def print_tweet(index, rss)
  print "> ", rss.items[index].title, "\n\n"
  #print "(", rss.items[index].date, ")\n\n"
end

def get_credentials(configfile)
  inputarray = []
  configarray = []
  File.open(configfile).each { |line|
    inputarray = line.split(' ')
	  configarray.push(inputarray[1])
  }
  return configarray
end

begin
  configarray = get_credentials(configfile)
  user = configarray[0]
  password = configarray[1]
  source = configarray[2]
  content = "" # raw content of rss feed will be loaded here
  open(source, :http_basic_authentication=> [user, password] ) do
  	|s| content = s.read end
  rss = RSS::Parser.parse(content, false)
  print "\n", rss.channel.title, " "
  print "(", rss.channel.link, ")\n"
  70.times {print "-"}
  print "\n"
  (0..5).each { |i| print_tweet(i, rss) }
end

#################################################################
# todo:
# config file depends on order. uncouple from order.
# refactor so it's proper (oo) (pretty kludgey right now)
# add method that exits if no ~/.twitterpeeksy
# implement getopts
# option for public timeline
# option for number of items
# show only new tweets option
# wordwrap
#
# done:
# support config file for url and prefs and credentials (~/.twitterpeeksy)
