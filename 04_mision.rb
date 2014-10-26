require 'serialport'
require 'net/http'
require 'json'
 
#params for serial port
port_str = ENV['ARDUINO_PORT']
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE


if !ENV['OHM_SERVER']
	puts 'OHM_SERVER env. variable not set!'
	exit -1
end

if !ENV['TEAM_ID']
	puts 'TEAM_ID env. variable not set!'
	exit -1
end

if ARGV.first == "accept"
	puts "Browse to: #{ENV['OHM_SERVER']}/challenge_04/completed/#{ENV['TEAM_ID']}"
	exit
end

if ARGV.first != "accept"
	puts "I'm sorry but I don't understand"
	exit
end


uri = URI.parse("#{ENV['OHM_SERVER']}/api/teams/#{ENV['TEAM_ID']}/sensorReading")
http = Net::HTTP.new(uri.hostname, uri.port)

puts "Started"
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
sp.write("Good afternoon, Mr. Phelps. Your mission Jim, should you decide to accept it is to run 'ruby 04_mission.rb accept'. Hopefully this device will not self-destruct in five seconds.");

