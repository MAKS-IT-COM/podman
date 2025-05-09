from http.server import BaseHTTPRequestHandler, HTTPServer

class HealthzHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/healthz':
            self.send_response(200)
        else:
            self.send_response(404)
        self.end_headers()

if __name__ == '__main__':
    HTTPServer(('0.0.0.0', 8080), HealthzHandler).serve_forever()