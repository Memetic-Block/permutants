import { JWKInterface } from 'arweave/node/lib/wallet'
import { readFileSync } from 'fs'
import { resolve } from 'path'

export function loadWallet (path: string) {
  try {
    return JSON.parse(readFileSync(resolve(path), 'utf-8')) as JWKInterface
  } catch (err) {
    console.error(`Error: Could not read wallet from ${path}: ${err.message}`)
    process.exit(1)
  }
}

export async function resolveAuthority (url: string) {
  if (process.env.AUTHORITY) return process.env.AUTHORITY
  const res = await fetch(`${url}/~meta@1.0/info/address`)
  if (!res.ok) throw new Error(`Failed to resolve authority from ${url}: ${res.status}`)
  return res.text()
}
