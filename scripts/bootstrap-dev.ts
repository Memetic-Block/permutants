import 'dotenv/config'
import Arweave from 'arweave'
import { loadWallet, resolveAuthority } from './util/helpers'
import { spawnProcess } from './tools/spawn'
import { doEval } from './tools/eval'

const WALLET_PATH = process.env.WALLET_PATH || 'wallet.json'
const HB_URL = process.env.HB_URL || 'https://push.forward.computer'
const GATEWAY_URL = process.env.GATEWAY_URL || 'https://arweave.net'
const SCHEDULER = process.env.SCHEDULER
const MODULE = process.env.MODULE || 'ISShJH1ij-hPPt9St5UFFr_8Ys3Kj5cyg7zrMGt7H9s'

async function bootstrap() {
  const wallet = loadWallet(WALLET_PATH)
  const arweave = Arweave.init({})
  const address = await arweave.wallets.getAddress(wallet)
  const authority = await resolveAuthority(HB_URL)
  const scheduler = SCHEDULER || authority

  console.log('=== Bootstrap Dev Environment ===')
  console.log(`Wallet:    ${address}`)
  console.log(`HB Node:   ${HB_URL}`)
  console.log(`Module:    ${MODULE}`)
  console.log(`Scheduler: ${scheduler}`)
  console.log(`Authority: ${authority}`)
  console.log()

  // 1. Spawn permutant process
  console.log('--- Step 1: Spawn new process for permutant ---')
  const permutantId = await spawnProcess({
    wallet,
    hyperbeamUrl: HB_URL,
    gatewayUrl: GATEWAY_URL,
    scheduler,
    authority,
    module: MODULE,
    processName: 'permutant'
  })

  // 2. Eval permutant source
  console.log('--- Step 2: Eval permutant source ---')
  await doEval({
    wallet,
    hyperbeamUrl: HB_URL,
    scheduler,
    processId: permutantId,
    processName: 'permutant'
  })

  console.log()
  console.log('=== Bootstrap Complete ===')
  console.log(`Permutant:       ${permutantId}`)
}

bootstrap()
  .then(() => process.exit(0))
  .catch(e => {
    console.error(e)
    process.exit(1)
  })
