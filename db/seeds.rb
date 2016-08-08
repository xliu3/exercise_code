# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'

rss_feeds = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'rss_url.yml'))

rss_feeds.each do |feed|
  puts ''
  puts "Loading the #{feed['site']} xml file from internet"
  doc = Nokogiri::XML(open(feed["url"]))

  puts "Creating new site"

  #store search site [/[a-zA-Z0-9]+/]
  site_name = doc.xpath("//channel//title").first.content.split().first[/[a-zA-Z]+/]
  site_title = doc.xpath("//channel//title").first.content
  site = Site.where(name: site_name, title: site_title).first_or_create

  puts "Finished #{site.name} site creation"

  puts "Creating #{site.name} items"

  #inserting items information
  (0..(doc.xpath("//item").length-1)).each do |i|
    title = doc.xpath("//item//title")[i].content
    link = doc.xpath("//item//link")[i].content
    description = doc.xpath("//item//description")[i].content
    author = doc.xpath("//item//author")[i].content
    pubDate = DateTime.parse(doc.xpath("//item//pubDate")[i].content)
    Item.where(title: title, link: link, description: description, author: author, pubDate: pubDate, site: site).first_or_create
  end

  puts "Finished #{site.name} items' creation"

end

puts "Date Creation Finished!!"
