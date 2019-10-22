require 'socket'


def open_multicast_socket
  sock = UDPSocket.open
  sock.setsockopt Socket::Option.ipv4_multicast_ttl(1)
  sock
end

def notify_all(addrs, sock, notification)
  addrs.each do |dest|
    sock.send notification, 0, dest['address'], dest['port']
  end
  puts notification
end

