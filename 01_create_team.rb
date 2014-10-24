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

puts "Started"

while true do 
	sleep 0.5
	sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

	line = sp.first
	if(line) 
		puts "Got: #{line}. Sending to server. Please wait."
		uri = URI.parse(ENV['OHM_SERVER'])
		puts "/api/teams/#{ENV['TEAM_ID']}/name/#{line}"
		http = Net::HTTP.new(uri.hostname, uri.port)
		request = Net::HTTP::Put.new("/api/teams/#{ENV['TEAM_ID']}/name/#{URI::encode line.chop }")
		http.request(request)
		puts "Completed."
		exit
	end
 	sp.flush_input
	sp.close 
end