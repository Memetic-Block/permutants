// @ts-ignore
import { connect, createSigner } from '@permaweb/aoconnect/node'
import Arweave from 'arweave'
import { JWKInterface } from 'arweave/node/lib/wallet'
import { resolveAuthority } from '../util/helpers'

export interface SendActionMessageOptions {
  wallet: JWKInterface
  hyperbeamUrl: string
  authority: string
  scheduler: string
  processId: string
  action: string
  data?: string
  additionalTags?: { name: string; value: string }[]
}

export async function sendActionMessage(opts: SendActionMessageOptions) {
  const {
    wallet,
    hyperbeamUrl,
    scheduler,
    processId,
    action,
    data,
    additionalTags
  } = opts
  const signer = createSigner(wallet)
  const ao = connect({
    MODE: 'mainnet',
    signer,
    URL: hyperbeamUrl,
    SCHEDULER: scheduler
  })
  const tags = [ { name: 'Action', value: action }, ...(additionalTags || []) ]

  console.info(`Sending Action [${action}] to Process [${processId}] with Node [${hyperbeamUrl}]`)

  const messageId = await ao.message({
    process: processId,
    tags,
    data,
    signer
  })

  console.log(`Action [${action}] sent to process [${processId}] with messageId [${messageId}], checking result...`)
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