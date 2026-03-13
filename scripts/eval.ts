import 'dotenv/config'
import Arweave from 'arweave'
import { loadWallet, resolveAuthority } from './util/helpers'
import { doEval } from './tools/eval'

const WALLET_PATH = process.env.WALLET_PATH || 'wallet.json'
const HB_URL = process.env.HB_URL || 'https://push.forward.computer'
const SCHEDULER = process.env.SCHEDULER || 'n_XZJhUnmldNFo4dhajoPZWhBXuJk-OcQr5JQ49c4Zo'
if (!WALLET_PATH) {
  throw new Error('Error: WALLET_PATH env var is required (path to Arweave JWK file)')
}
const processId = process.env.PROCESS_ID || ''
if (!processId) {
  throw new Error('PROCESS_ID is not set!')
}
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

async function evalScript() {
  const wallet = loadWallet(WALLET_PATH)
  const arweave = Arweave.init({})
  const address = await arweave.wallets.getAddress(wallet)
  console.log(`Resolving authority for [${HB_URL}]...`)
  const authority = await resolveAuthority(HB_URL)
  const scheduler = SCHEDULER || authority
  console.log(`Wallet:       ${address}`)
  console.log(`HB Node:      ${HB_URL}`)
  console.log(`Scheduler:    ${scheduler}`)
  console.log(`Authority:    ${authority}`)
  console.log(`Process ID:   ${processId}`)
  console.log(`Process Name: ${PROCESS_NAME}`)

  await doEval({
    wallet,
    hyperbeamUrl: HB_URL,
    scheduler,
    processId,
    processName: PROCESS_NAME,
    additionalTags
  })
}

evalScript()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
