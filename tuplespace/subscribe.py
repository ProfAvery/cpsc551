#!/usr/bin/env python3

import sys
import struct
import socket

# per <https://en.wikipedia.org/wiki/User_Datagram_Protocol>
MAX_UDP_PAYLOAD = 65507


def main(address, port):
    # See <https://pymotw.com/3/socket/multicast.html> for details

    server_address = ('', int(port))

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(server_address)

    group = socket.inet_aton(address)
    mreq = struct.pack('4sL', group, socket.INADDR_ANY)
    sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

    print(f"Listening on udp://{address}:{port}")

    try:
        while True:
            data, _ = sock.recvfrom(MAX_UDP_PAYLOAD)
            notification = data.decode()
            print(notification)
    except:
        sock.close()


def usage(program):
    print(f'Usage: {program} ADDRESS PORT', file=sys.stderr)
    sys.exit(1)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        usage(sys.argv[0])

    sys.exit(main(*sys.argv[1:]))
