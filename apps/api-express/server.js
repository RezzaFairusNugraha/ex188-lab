#!/usr/bin/env node
'use strict';

// Northwind Inventory REST API (api-express) — DO NOT MODIFY.
const fs = require('fs');
const http = require('http');
const os = require('os');
const path = require('path');

const PORT = parseInt(process.env.PORT || '3000', 10);
const HOST = process.env.HOST || '0.0.0.0';
const NODE_ENV = process.env.NODE_ENV || 'production';
const CATALOG_FILE = process.env.CATALOG_FILE || '/etc/api-express/catalog.json';
const AUDIT_DIR = process.env.AUDIT_DIR || '/var/lib/api-express/audit';
const AUTH_REQUIRED = (process.env.AUTH_REQUIRED || 'false').toLowerCase() === 'true';
const API_TOKEN_FILE = process.env.API_TOKEN_FILE || '/run/secrets/api_token';

function resolveToken() {
  if (API_TOKEN_FILE && fs.existsSync(API_TOKEN_FILE)) {
    const t = fs.readFileSync(API_TOKEN_FILE, 'utf8').trim();
    if (t) return t;
  }
  if (process.env.API_TOKEN && process.env.API_TOKEN.trim()) {
    return process.env.API_TOKEN.trim();
  }
  return '';
}

function readCatalog() {
  const fallback = path.join(__dirname, 'config', 'catalog.json');
  const target = fs.existsSync(CATALOG_FILE) ? CATALOG_FILE : fallback;
  if (!fs.existsSync(target)) return [];
  return JSON.parse(fs.readFileSync(target, 'utf8'));
}

const activeToken = resolveToken();
if (AUTH_REQUIRED && !activeToken) {
  console.error('FATAL: AUTH_REQUIRED=true but neither API_TOKEN_FILE nor API_TOKEN provided a secret.');
  process.exit(1);
}

function sendJson(res, code, obj) {
  const body = JSON.stringify(obj) + '\n';
  res.writeHead(code, {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(body),
  });
  res.end(body);
}

const server = http.createServer((req, res) => {
  const url = (req.url || '/').split('?')[0];
  if (req.method === 'GET' && url === '/healthz') {
    return sendJson(res, 200, { status: 'healthy', service: 'api-express' });
  }
  if (req.method === 'GET' && (url === '/' || url === '/api/v1/info')) {
    const items = readCatalog();
    return sendJson(res, 200, {
      service: 'api-express',
      node_env: NODE_ENV,
      hostname: os.hostname(),
      uid: process.getuid ? process.getuid() : -1,
      auth_configured: Boolean(activeToken),
      catalog_file: CATALOG_FILE,
      catalog_count: items.length,
    });
  }
  if (req.method === 'GET' && url === '/api/v1/items') {
    try {
      return sendJson(res, 200, { items: readCatalog() });
    } catch (err) {
      return sendJson(res, 500, { error: err.message });
    }
  }
  if (req.method === 'POST' && url === '/api/v1/audit') {
    if (AUTH_REQUIRED) {
      const provided = req.headers['x-api-token'] || '';
      if (provided !== activeToken) {
        return sendJson(res, 401, { error: 'invalid or missing X-API-Token' });
      }
    }
    let body = '';
    req.on('data', (chunk) => { body += chunk.toString('utf8'); });
    req.on('end', () => {
      try {
        fs.mkdirSync(AUDIT_DIR, { recursive: true });
        const entry = JSON.stringify({ ts: new Date().toISOString(), event: body.trim() || 'audit-ping' }) + '\n';
        fs.appendFileSync(path.join(AUDIT_DIR, 'audit.log'), entry, 'utf8');
        return sendJson(res, 201, { recorded: true });
      } catch (err) {
        return sendJson(res, 500, { error: err.message });
      }
    });
    return;
  }
  return sendJson(res, 404, { error: 'route not found' });
});

process.on('SIGTERM', () => {
  console.log('INFO: SIGTERM received, closing api-express HTTP server.');
  server.close(() => process.exit(0));
});

server.listen(PORT, HOST, () => {
  console.log(`INFO: api-express listening on ${HOST}:${PORT} (env=${NODE_ENV})`);
});
