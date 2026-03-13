import 'dotenv/config'
import { createReadStream, readFileSync, statSync } from 'fs'
import { ArweaveSigner, TurboAuthenticatedConfiguration, TurboFactory, TurboSigner } from '@ardrive/turbo-sdk'

const VIEW_VERSION = process.env.VIEW_VERSION || 'dev'
const VIEW_NAME = process.env.VIEW_NAME || process.argv[2] || ''
if (!VIEW_NAME) {
  throw new Error('VIEW_NAME is not set!')
}
const WALLET_PATH = process.env.WALLET_PATH || ''
if (!WALLET_PATH) {
  throw new Error('WALLET_PATH is not set!')
}
const JWK = JSON.parse(readFileSync(WALLET_PATH, 'utf-8'))
const SIGNER = new ArweaveSigner(JWK)
const GATEWAY_URL = process.env.GATEWAY_URL
const BUNDLER_URL = process.env.BUNDLER_URL

export async function publish(
  viewName: string,
  viewVersion: string,
  signer: TurboSigner
) {
  console.info(`Publishing LUA View Source for [${viewName}]`)
  console.info(`Using view version: ${viewVersion}`)
  const bundledLuaPath = `./src/views/${viewName}.lua`
  const bundledLuaSize = statSync(bundledLuaPath).size
  const turboOpts: TurboAuthenticatedConfiguration = { signer }
  if (GATEWAY_URL || BUNDLER_URL) {
    console.info(`Using gateway: ${GATEWAY_URL}`)
    console.info(`Using bundler: ${BUNDLER_URL}`)
    turboOpts.gatewayUrl = GATEWAY_URL
    turboOpts.uploadServiceConfig = { url: BUNDLER_URL }
  }
  const turbo = TurboFactory.authenticated(turboOpts)
  const uploadResult = await turbo.uploadFile({
    fileStreamFactory: () => createReadStream(bundledLuaPath),
    fileSizeFactory: () => bundledLuaSize,
    dataItemOpts: {
      tags: [
        { name: 'Content-Type', value: 'application/lua' },
        { name: 'Author', value: 'Memetic Block' },
        { name: 'Data-Protocol', value: 'ao' },
        { name: 'App-Name', value: 'Wuzzy'}
      ]
    }
  })

  console.info(`Publication result for ${viewName} view:`)
  console.dir(uploadResult, { depth: null })
}

publish(VIEW_NAME, VIEW_VERSION, SIGNER).then(() => {
  console.info('Publish view script executed successfully!')
}).catch(error => {
  console.error(
    `Error executing publish view script: ${error.message}`,
    error.stack
  )
  process.exit(1)
})
