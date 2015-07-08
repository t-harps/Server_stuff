require 'socket'
require 'json'

host = 'localhost'
port = 2000
params = Hash.new { |hash, key| hash[key] = Hash.new } 

puts "What kind of request would you like to send?"
verb = gets.chomp

if verb == "GET"
	request = "GET /index.html HTTP/1.0\r\n\r\n"
elsif verb == "POST"
	puts "Name?"
	name = gets.chomp
	puts "Email?"
	email = gets.chomp
	params[:person][:name] = name
    params[:person][:email] = email
    body = params.to_json

	request = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{body.length}\r\n\r\n#{body}\r\n\r\n"
else
end

socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read
headers,body = response.split("\r\n\r\n", 2)
print body
socket.close