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
    print("Usage: \npython pingsweep.py filename")
    print("filename : input file containing ranges to sweep through")
    sys.exit(0)


def main():
    if len(sys.argv) != 2:
        print_usage()
    else:
        if sys.argv[1] == "-h" or sys.argv[1] == "?" or sys.argv[1] == "--help":
            print_usage()
    
    with open(sys.argv[1]) as fp:
        up = []
        for line in fp:
            if '-' in line:
                start = line.split('-')[0]
                end = line.split('-')[1]
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

                # start_address = ipaddress.IPv4Address(unicode(start))
                # end_address = ipaddress.IPv4Address(unicode(end))
                # while start < end:
                # 	print(str(start))
                # 	start += 1

            elif '/' in line:
                network = ipaddress.ip_network(unicode(line.strip()))
                for address in network.hosts():
                    response = os.system("ping -c 1 " + str(address) + " > /dev/null")
                    if response == 0:
                        up.append(str(address))
            else:
                print("Invalid formatting in file: " + line.strip())
                sys.exit(1)

        
    print("Hosts that are up:")
    for host in up:
        print("\t" + host)
    return up


if __name__ == "__main__":
    main()
