#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'fog'


require './config'

options = {}

optparse = OptionParser.new do |opts|

    opts.banner = "Usage: ./build-ebs-device --zone=us-east-1b --size=1 --instance=foo --device=/dev/sdf"
 
    options[:zone] = ""
    opts.on( '-z', '--zone ZONE', 'Availability Zone' ) do |zone|
         options[:zone] = zone
    end

    options[:size] = ""
    opts.on( '-s', '--size SIZE', 'Size (GB)' ) do |size|
         options[:size] = size
    end

    options[:instance] = ""
    opts.on( '-i', '--instance INSTANCE', 'EC2 instance' ) do |instance|
         options[:instance] = instance
    end

    options[:device] = nil
    opts.on( '-d', '--device', 'Device' ) do |device|
         options[:device] = device
    end

    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end

end

optparse.parse!

if options[:zone].empty? then
    print "Error: Need a zone.\n"
    exit 1
end

if options[:size].empty? then
    print "Error: Need the size.\n"
    exit 1
end

connection = Fog::AWS::EC2.new(
    :aws_access_key_id     => @aws_key,
    :aws_secret_access_key => @aws_secret
)

volume = connection.volumes.new(
    "availability_zone" => options[:zone],
    "size"              => options[:size],
    "device"            => options[:device]
)

if !options[:instance].empty? then
    volume.attach(instance)
end

volume.save
