const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = process.env.PORT || 8080;
const ROOT_DIR = path.resolve(__dirname);

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.mp4': 'video/mp4',
  '.webm': 'video/webm',
  '.xml': 'application/xml; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8',
  '.pdf': 'application/pdf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf'
};

const server = http.createServer((req, res) => {
  // Only accept GET and HEAD requests
  if (req.method !== 'GET' && req.method !== 'HEAD') {
    res.writeHead(405, { 'Content-Type': 'text/plain' });
    return res.end('Method Not Allowed');
  }

  const parsedUrl = url.parse(req.url);
  let pathname = decodeURIComponent(parsedUrl.pathname);

  // Normalize path and prevent directory traversal
  let safePath = path.normalize(pathname).replace(/^(\.\.[\/\\])+/, '');
  let filePath = path.join(ROOT_DIR, safePath);

  // Verify filePath is inside ROOT_DIR
  if (!filePath.startsWith(ROOT_DIR)) {
    res.writeHead(403, { 'Content-Type': 'text/plain' });
    return res.end('Forbidden');
  }

  // Check if target exists
  fs.stat(filePath, (err, stats) => {
    if (err) {
      // Try appending .html for clean URLs (e.g. /about -> /about.html)
      const htmlPath = filePath + '.html';
      fs.stat(htmlPath, (htmlErr, htmlStats) => {
        if (!htmlErr && htmlStats.isFile()) {
          return serveFile(req, res, htmlPath, htmlStats);
        }
        res.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end('<!DOCTYPE html><html><head><title>404 Not Found</title></head><body style="font-family:sans-serif;text-align:center;padding:50px;"><h1>404 - Page Not Found</h1><p><a href="/">Return to Homepage</a></p></body></html>');
      });
      return;
    }

    // If directory, look for index.html
    if (stats.isDirectory()) {
      filePath = path.join(filePath, 'index.html');
      fs.stat(filePath, (indexErr, indexStats) => {
        if (indexErr || !indexStats.isFile()) {
          res.writeHead(404, { 'Content-Type': 'text/plain' });
          return res.end('Not Found');
        }
        serveFile(req, res, filePath, indexStats);
      });
      return;
    }

    if (stats.isFile()) {
      serveFile(req, res, filePath, stats);
    } else {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Not Found');
    }
  });
});

function serveFile(req, res, filePath, stats) {
  const ext = path.extname(filePath).toLowerCase();
  const contentType = MIME_TYPES[ext] || 'application/octet-stream';

  // Support HTTP 206 Partial Content for video streaming (crucial for iOS Safari / Chrome video controls)
  const range = req.headers.range;
  if (range && ext === '.mp4') {
    const parts = range.replace(/bytes=/, '').split('-');
    const start = parseInt(parts[0], 10);
    const end = parts[1] ? parseInt(parts[1], 10) : stats.size - 1;

    if (start >= stats.size) {
      res.writeHead(416, {
        'Content-Range': `bytes */${stats.size}`
      });
      return res.end();
    }

    const chunksize = (end - start) + 1;
    const file = fs.createReadStream(filePath, { start, end });

    res.writeHead(206, {
      'Content-Range': `bytes ${start}-${end}/${stats.size}`,
      'Accept-Ranges': 'bytes',
      'Content-Length': chunksize,
      'Content-Type': contentType
    });

    file.pipe(res);
    return;
  }

  // Standard 200 response with caching
  const headers = {
    'Content-Type': contentType,
    'Content-Length': stats.size,
    'Accept-Ranges': 'bytes'
  };

  // Cache static assets (images, css, js, fonts) for 1 hour; HTML revalidated
  if (['.html', '.json', '.xml'].includes(ext)) {
    headers['Cache-Control'] = 'no-cache';
  } else {
    headers['Cache-Control'] = 'public, max-age=3600';
  }

  res.writeHead(200, headers);

  if (req.method === 'HEAD') {
    return res.end();
  }

  const stream = fs.createReadStream(filePath);
  stream.pipe(res);
  stream.on('error', (streamErr) => {
    console.error('Stream error:', streamErr);
    if (!res.headersSent) {
      res.writeHead(500, { 'Content-Type': 'text/plain' });
      res.end('Internal Server Error');
    }
  });
}

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Ganesha Enterprises web server listening on port ${PORT}`);
});

