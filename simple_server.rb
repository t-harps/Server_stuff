require 'socket'
require 'json'


server = TCPServer.open(2000)

loop {
	client = server.accept
  
  header = ''
  while line = client.gets
    header << line
    break if header =~ /\r\n\r\n$/
  end

	req = header.split
	verb = req[0]
	path = req[1][1..-1]

	if File.exist?(path)
		client.puts "HTTP/1.0 200 OK\r\n\r\n"
		contents = File.read(path)
		case verb
			when "GET"
				client.puts contents
			when "POST"
				body = ""
    		while line = client.gets
      		body << line
      		break if body =~ /\r\n\r\n$/
    		end
    		body = body.chomp.chomp
				params = JSON.parse(body)
				user_data = "<li>name: #{params['person']['name']}</li><li>e-mail: #{params['person']['email']}</li>"
        client.puts contents.gsub('<%= yield %>', user_data)
			else
				puts "not sure what's going on"	
		end
	else
		client.puts "HTTP/1.0 404 NOT FOUND\r\n\r\n"
		client.puts "404 Error, File could not be found"
	end
	client.close
}

