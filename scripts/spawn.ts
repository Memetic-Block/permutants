import 'dotenv/config'
import Arweave from 'arweave'
import { loadWallet, resolveAuthority } from './util/helpers'
import { spawnProcess } from './tools/spawn'

const WALLET_PATH = process.env.WALLET_PATH || 'wallet.json'
if (!WALLET_PATH) {
  throw new Error('Error: WALLET_PATH env var is required (path to Arweave JWK file)')
}
const HB_URL = process.env.HB_URL || 'https://push.forward.computer'
const GATEWAY_URL = process.env.GATEWAY_URL || 'https://arweave.net'
const SCHEDULER = process.env.SCHEDULER || 'n_XZJhUnmldNFo4dhajoPZWhBXuJk-OcQr5JQ49c4Zo'
const module = process.env.MODULE || 'ISShJH1ij-hPPt9St5UFFr_8Ys3Kj5cyg7zrMGt7H9s'//'wal-fUK-YnB9Kp5mN8dgMsSqPSqiGx-0SvwFUSwpDBI'
const PROCESS_NAME = process.env.PROCESS_NAME || 'default'
const tagsInput = process.env.TAGS
let additionalTags: { name: string; value: string }[] = []
if (tagsInput) {
  try {
    additionalTags = JSON.parse(tagsInput)
    if (!Array.isArray(additionalTags)) {
      throw new Error('TAGS must be a JSON array')
    }
  } catch (e) {
    throw new Error(`Failed to parse TAGS as JSON: ${e.message}`)
  }
}

async function spawnScript() {
  const wallet = loadWallet(WALLET_PATH)
  const arweave = Arweave.init({})
  const address = await arweave.wallets.getAddress(wallet)
  console.log(`Resolving authority for [${HB_URL}]...`)
  const authority = await resolveAuthority(HB_URL)
  const scheduler = SCHEDULER || authority
  console.log(`Wallet:       ${address}`)
  console.log(`HB Node:      ${HB_URL}`)
  console.log(`Module:       ${module}`)
  console.log(`Scheduler:    ${scheduler}`)
  console.log(`Authority:    ${authority}`)
  console.log(`Process Name: ${PROCESS_NAME}`)
  console.log(`Tags:         ${JSON.stringify(additionalTags)}`)

  await spawnProcess({
    wallet,
    hyperbeamUrl: HB_URL,
    gatewayUrl: GATEWAY_URL,
    scheduler,
    authority,
    module,
    processName: PROCESS_NAME,
    additionalTags
  })
}

spawnScript()
  .then(() => process.exit(0))
  .catch(e => {
    console.error(e)
    process.exit(1)
  })
