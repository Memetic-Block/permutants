// @ts-ignore
import { connect, createSigner } from '@permaweb/aoconnect/node'
import { JWKInterface } from 'arweave/node/lib/wallet'

export interface SpawnProcessOptions {
  wallet: JWKInterface
  hyperbeamUrl: string
  gatewayUrl: string
  scheduler: string
  authority: string
  module: string
  processName: string
  additionalTags?: { name: string; value: string }[]
}

export async function spawnProcess(opts: SpawnProcessOptions) {
  const {
    wallet,
    hyperbeamUrl,
    gatewayUrl,
    scheduler,
    authority,
    module,
    processName,
    additionalTags
  } = opts
  const signer = createSigner(wallet)
  const ao = connect({
    MODE: 'mainnet',
    signer,
    GATEWAY_URL: gatewayUrl,
    URL: hyperbeamUrl,
    SCHEDULER: scheduler
  })

  console.log('Spawning process...')
  const processId = await ao.spawn({
    tags: [
      { name: 'App-Name', value: 'Wuzzy' },
      { name: 'Name', value: processName },
      { name: 'Authority', value: authority },
      ...(additionalTags || [])
    ],
    authority,
    module,
    signer,
    data: ''
  })

  console.log(`Process Id: [${processId}]`)
  console.log(`Process spawned: [${hyperbeamUrl}/${processId}/now/serialize~json@1.0]`)

  return processId
}
