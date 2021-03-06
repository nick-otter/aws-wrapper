#!/usr/bin/env ruby

require_relative '../lib/util/destroyer'
require_relative '../lib/script_helper'
require 'optparse'

config = {}
ScriptHelper.read_defaults(config)

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)}"
  ScriptHelper.one_arg_opts(
    opts, config,
    name: 'Name to be used for PK, EBS, DNS, etc.',
    availability_zone: 'Availability Zone'
  )
  ScriptHelper.no_arg_opts(
    opts, config,
    debug: 'Turn on debug logging',
    unsafe: 'Delete based on name conventions, rather than dependency tree'
  )
  opts.separator('When run you are prompted to confirm,')
  opts.separator('and then everything relating to the name is deleted.')
end

ScriptHelper.read_args(config, opt_parser, [:availability_zone, :name])

print "Really destroy everything relating to #{config[:name]}? Reenter to confirm: "
unless gets.strip == config[:name]
  warn 'Quit without touching anything.'
  exit 1
end

Destroyer.new(debug: config[:debug], availability_zone: config[:availability_zone])
  .destroy(config[:name], config[:unsafe])
