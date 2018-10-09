# ping sweep tool to determine which hosts are up
# author : Evan Craska <erc9510@rit.edu>
# date : 8 October 2018
import sys
import os
import ipaddress
import struct
import socket

def parse_to_int(strings):
    x = 0
    while x < len(strings):
        strings[x] = int(strings[x])
        x += 1
    return strings


def get_ip(octets):
    ip = ""
    for octet in octets:
        ip += str(octet) + "."
    ip = ip[:-1]
    return ip


def print_usage():
    print("Usage: \npython pingsweep.py addresses")
    print("addresses : range or network to scan.")
    print("Examples:")
    print("python pingsweep.py 10.10.1.1-10.10.2.50")
    print("python pingsweep.py 10.10.0.0/16")
    sys.exit(0)


def main():
    if len(sys.argv) != 2:
        print_usage()
    else:
        if sys.argv[1] == "-h" or sys.argv[1] == "?" or sys.argv[1] == "--help":
            print_usage()
    
    
    up = []
    if '-' in sys.argv[1]:
        start = sys.argv[1].split('-')[0]
        end = sys.argv[1].split('-')[1]
        start_octets_strings = start.split('.')
        end_octets_strings = end.split('.')
        start_octets = parse_to_int(start_octets_strings)
        end_octets = parse_to_int(end_octets_strings)

        ipstruct = struct.Struct('>I')
        x, = ipstruct.unpack(socket.inet_aton(start))
        y, = ipstruct.unpack(socket.inet_aton(end))
        for i in range(x, y + 1):
            response = os.system("ping -c 1 " + socket.inet_ntoa(ipstruct.pack(i)) + " > /dev/null")
            if response == 0:
                up.append(socket.inet_ntoa(ipstruct.pack(i)))

    elif '/' in sys.argv[1]:
        network = ipaddress.ip_network(unicode(sys.argv[1]))
        for address in network.hosts():
            response = os.system("ping -c 1 " + str(address) + " > /dev/null")
            if response == 0:
                up.append(str(address))
    else:
        print("Invalid formatting: " + sys.argv[1])
        sys.exit(1)

        
    print("Hosts that are up:")
    for host in up:
        print("\t" + host)
    return up


if __name__ == "__main__":
    main()
