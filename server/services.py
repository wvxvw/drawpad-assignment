#!/usr/bin/python

# Nothe, this module cannot be installed using easy_install
# you may need to build it on your own. I also depends on
# setuptools, so you need to make sure you have that installed
# http://sourceforge.net/projects/mysql-python/
import MySQLdb

# This should be available with the default Python install
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
from optparse import OptionParser
import getpass
import re
from os import path, curdir
from urlparse import urlparse, parse_qs

# This is the example HTTP server, it communicates to the MySQL
# 
# in order to run it, give the MySQL server is alreayd running,
# you imported the data, and have access to the server:
#
# $ ./services.py -u <user name> -w <password>
#
# See `services.py --help' for more details

parser = OptionParser()
parser.add_option(
    '-p', '--port', dest = 'port', default = 8080,
    help = '''The port operated by HTTP server.
Defaults to 8080.''')

parser.add_option(
    '-d', '--database-port', dest = 'database_port', default = 3306,
    help = '''The port number MySQL database listens for connections.
Defaults to 3306.''')

parser.add_option(
    '-u', '--user', dest = 'user', default = getpass.getuser(),
    help = '''The user, who will connect to the database.
Defaults to the current system user.''')

parser.add_option(
    '-w', '--password', dest = 'password', 
    help = '''The password, used to connect to the database.
No default, you must provide password.''')

parser.add_option(
    '-b', '--database', dest = 'database', default = 'adventure_works',
    help = '''The database to connect to.
Defaults to "example"''')

(options, args) = parser.parse_args()

STATIC_CONTENT = { '.html' : 'text/html',
                   '.jpg' : 'image/jpg',
                   '.swf' : 'application/x-shockwave-flash',
                   '.gif' : 'image/gif',
                   '.js' : 'application/javascript',
                   '.css' : 'text/css' }
# Add some services later
SERVICES = { }

class DrawpadHandler(BaseHTTPRequestHandler):

    www = path.join(curdir, 'www')
    
    def serve_static(self, file, mime):
        '''The handler for static files'''
        try:
            with open(path.join(self.www, file), 'r') as served:
                self.send_response(200)
                self.send_header('Content-type', mime)
                self.end_headers()
                self.wfile.write(served.read())
        except IOError:
            self.send_error(404, 'File Not Found: %s' % self.path)

    def do_GET(self):
        '''Mandatory GET handler'''
        url = urlparse(self.path)
        extension = path.splitext(url.path)[1]
        arguments = parse_qs(url.query)
        if self.path == '/':
            self.serve_static('drawpad.html', STATIC_CONTENT['.html'])
        elif extension in STATIC_CONTENT:
            self.serve_static(url.path[1:], STATIC_CONTENT[extension])
        elif 'service' in arguments:
            try:
                getattr(self, SERVICES[arguments['service'][0]])()
            except KeyError:
                self.send_error(404, 'No Such Service')

try:
    server = HTTPServer(('', options.port), DrawpadHandler)
    print 'Starting on port: %s...' % options.port
    server.serve_forever()

except KeyboardInterrupt:
    print '^C Shutting down...'
    server.socket.close()
    
