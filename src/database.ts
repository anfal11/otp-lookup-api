import * as mssql from 'mssql';

const config: mssql.config = {
  server: process.env.DB_HOST || '192.168.1.102',
  port: parseInt(process.env.DB_PORT || '1433'),
  user: process.env.DB_USER || 'SA',
  password: process.env.DB_PASS || 'W@letSimulation@2026',
  database: process.env.DB_NAME || 'finify',
  options: {
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true,
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};

let pool: mssql.ConnectionPool | null = null;

export async function getDbPool(): Promise<mssql.ConnectionPool> {
  if (!pool || !pool.connected) {
    pool = await new mssql.ConnectionPool(config).connect();
    console.log('[DB] MSSQL connection pool established');
  }
  return pool;
}