require 'socket'

server = TCPServer.open(2000)

loop {
	client = server.accept

	request = client.gets
	request_header, request_body = request.split("\r\n\r\n", 2)
	req = request_header.split(" ")
	verb = req[0]
	path = req[1][1..-1]
	if File.exist?(path)
		case verb
			when "GET"
				contents = File.read(path)
				client.puts "HTTP/1.0 200 OK\r\n\r\n"
				client.puts contents
			else
				puts "not sure what's going on"	
		end
	else
		client.puts "HTTP/1.0 404 NOT FOUND\r\n\r\n"
		client.puts "404 Error, File could not be found"
	end
	client.close
}

