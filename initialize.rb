require 'serialport'
require 'net/http'
 
#params for serial port
port_str = '/dev/tty.usbmodem1421'
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
	sleep 5
	sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

	line = sp.first
	if(line) 
		uri = URI.parse(ENV['OHM_SERVER'])
		http = Net::HTTP.new(uri.hostname, uri.port)
		request = Net::HTTP::Put.new("/api/teams/#{ENV['TEAM_ID']}")
		http.request(request)
		exit
	end
 	sp.flush_input
	sp.close 
end