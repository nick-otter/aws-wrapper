require_relative '../lib/util/group_adder'
require 'optparse'

user = nil
group = nil
debug = nil

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)}"
  opts.on('--user USER', 'AWS user name') do |u|
    user = u
  end
  opts.on('--group GROUP', 'AWS group name') do |g|
    group = g
  end
  opts.on('--debug', 'Turn on debugging') do
    debug = true
  end
  opts.separator('Adds user to group.')
end

opt_parser.parse!(ARGV)
unless user && group
  puts '--user and --group are required'
  puts opt_parser
  exit 1
end

GroupAdder.new(debug: debug).add_user_to_group(user, group)