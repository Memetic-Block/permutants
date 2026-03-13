// @ts-ignore
import { connect, createSigner } from '@permaweb/aoconnect/node'
import { JWKInterface } from 'arweave/node/lib/wallet'
import { readFileSync } from 'fs'

export interface DoEvalOptions {
  wallet: JWKInterface
  hyperbeamUrl: string
  scheduler: string
  processId: string
  processName: string
  additionalTags?: { name: string; value: string }[]
}

export async function doEval(opts: DoEvalOptions) {
  const {
    wallet,
    hyperbeamUrl,
    scheduler,
    processId,
    processName,
    additionalTags
  } = opts
  const signer = createSigner(wallet)
  const ao = connect({
    MODE: 'mainnet',
    signer,
    URL: hyperbeamUrl,
    SCHEDULER: scheduler
  })

  console.log('Reading Eval source from file...')
  const data = readFileSync(`./dist/${processName}/process.lua`, 'utf8')

  console.log(`Executing Eval Action...`)
  const messageId = await ao.message({
    process: processId,
    data,
    tags: [
      { name: 'Action', value: 'Eval' },
      { name: 'App-Name', value: 'Wuzzy' },
      ...(additionalTags || [])
    ],
    signer
  })

  console.log(`Eval Action sent with messageId [${messageId}], checking result...`)
  const result = await ao.result({
    process: processId,
    message: messageId
  })

  if (result.Error) {
    throw new Error(`Eval Action failed with error: ${result.Error}`)
  }
  console.log('Eval Action Output.prompt:', result.Output?.prompt)
  console.log(`Check state: [${hyperbeamUrl}/${processId}/now/serialize~json@1.0]`)

  return messageId
}
