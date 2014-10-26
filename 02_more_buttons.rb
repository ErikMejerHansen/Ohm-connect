require 'serialport'
require 'net/http'
 
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

uri = URI.parse(ENV['OHM_SERVER'])
http = Net::HTTP.new(uri.hostname, uri.port)

puts "Started"

request = Net::HTTP::Put.new("/api/teams/#{ENV['TEAM_ID']}/morebuttons/connected")
http.request(request)

puts "Connected"
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
while true do 
	line = sp.first
	if(line) 
		puts "Got: #{line}. Sending to server. Please wait."
		
		request = Net::HTTP::Put.new("/api/teams/#{ENV['TEAM_ID']}/morebuttons/sequence/#{line.chop }")
		http.request(request)
		puts "#{line} Was sent to server"
	end
end