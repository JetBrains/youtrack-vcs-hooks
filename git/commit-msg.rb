#!/usr/bin/env ruby
require "rubygems"
require "you_track_connection"
require "you_track_entities"

puts("applying commit-msg hook...")

you_track_login = "root"
you_track_password = "root"
you_track_url = "http://localhost:8081"

message_file = ARGV[0]
message = File.read(message_file)

mentioned_issue = message[/( |^)#?(\w+-\d+)/, 2]
if !mentioned_issue.nil?
  conn = YouTrackConnection.new(you_track_url)
  conn.login(you_track_login, you_track_password)
  issue = YouTrackEntities::Issue.new(conn, mentioned_issue)
  issue.get
  if (issue.state[0].upcase != "OPEN") and (issue.state[0].upcase != "IN PROGRESS")
    puts("Issue #{mentioned_issue}, that you mentioned in commit should be in Open or In Progress state")
    puts("Commit aborted")
    exit(1)
  end
end

