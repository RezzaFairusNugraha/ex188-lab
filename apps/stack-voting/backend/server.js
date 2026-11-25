#!/usr/bin/env node
'use strict';

// PulseVote Backend API (vote-api) — DO NOT MODIFY.
const fs = require('fs');
const http = require('http');
const net = require('net');
const path = require('path');

const PORT = parseInt(process.env.API_PORT || '4000', 10);
const DB_HOST = process.env.DB_HOST || 'vote-db';
const DB_PORT = parseInt(process.env.DB_PORT || '5432', 10);
const CACHE_HOST = process.env.CACHE_HOST || 'vote-cache';
const CACHE_PORT = parseInt(process.env.CACHE_PORT || '6379', 10);
const BALLOT_DIR = process.env.BALLOT_DIR || '/var/lib/voting/ballots';
const DB_PASSWORD_FILE = process.env.DB_PASSWORD_FILE || '/run/secrets/db_password';

function getDbSecret() {
  if (DB_PASSWORD_FILE && fs.existsSync(DB_PASSWORD_FILE)) {
    return fs.readFileSync(DB_PASSWORD_FILE, 'utf8').trim();
  }
  return (process.env.DB_PASSWORD || '').trim();
}

function probeTcp(host, port, timeoutMs = 1500) {
  return new Promise((resolve) => {
    const sock = new net.Socket();
    let settled = false;
    const finish = (ok) => {
      if (!settled) {
        settled = true;
        sock.destroy();
        resolve(ok);
      }
    };
    sock.setTimeout(timeoutMs);
    sock.once('connect', () => finish(true));
    sock.once('timeout', () => finish(false));
    sock.once('error', () => finish(false));
    sock.connect(port, host);
  });
}

function readTally() {
  const counts = { 'Podman Quadlet': 2, 'Kubernetes YAML': 1 };
  const f = path.join(BALLOT_DIR, 'ballots.jsonl');
  if (fs.existsSync(f)) {
    for (const line of fs.readFileSync(f, 'utf8').split('\n')) {
      if (!line.trim()) continue;
      try {
        const rec = JSON.parse(line);
        counts[rec.choice] = (counts[rec.choice] || 0) + 1;
      } catch (_) {}
    }
  }
  return counts;
}

function send(res, code, obj) {
  const raw = JSON.stringify(obj) + '\n';
  res.writeHead(code, { 'Content-Type': 'application/json' });
  res.end(raw);
}

const server = http.createServer(async (req, res) => {
  if (req.method === 'GET' && req.url === '/healthz') {
    const [dbOk, cacheOk] = await Promise.all([
      probeTcp(DB_HOST, DB_PORT),
      probeTcp(CACHE_HOST, CACHE_PORT),
    ]);
    const hasSecret = Boolean(getDbSecret());
    const ok = dbOk && cacheOk && hasSecret;
    return send(res, ok ? 200 : 503, {
      status: ok ? 'ok' : 'degraded',
      db_reachable: dbOk,
      cache_reachable: cacheOk,
      secret_loaded: hasSecret,
    });
  }
  if (req.method === 'GET' && req.url === '/tally') {
    return send(res, 200, { service: 'vote-api', tally: readTally() });
  }
  if (req.method === 'POST' && req.url === '/vote') {
    let body = '';
    req.on('data', (c) => { body += c.toString('utf8'); });
    req.on('end', () => {
      try {
        const parsed = body ? JSON.parse(body) : { choice: 'Podman Quadlet' };
        fs.mkdirSync(BALLOT_DIR, { recursive: true });
        fs.appendFileSync(
          path.join(BALLOT_DIR, 'ballots.jsonl'),
          JSON.stringify({ choice: parsed.choice || 'Podman Quadlet', ts: Date.now() }) + '\n'
        );
        return send(res, 201, { accepted: true, tally: readTally() });
      } catch (err) {
        return send(res, 500, { error: err.message });
      }
    });
    return;
  }
  return send(res, 404, { error: 'not found' });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`INFO: vote-api listening on 0.0.0.0:${PORT}`);
});
