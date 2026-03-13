import 'dotenv/config'
import { createReadStream, readFileSync, statSync } from 'fs'
import { ArweaveSigner, TurboFactory, TurboSigner } from '@ardrive/turbo-sdk'

const CONTRACT_VERSION = process.env.CONTRACT_VERSION || 'dev'
const CONTRACT_NAME = process.env.CONTRACT_NAME || process.argv[2] || ''
if (!CONTRACT_NAME) {
  throw new Error('CONTRACT_NAME is not set!')
}
const WALLET_PATH = process.env.WALLET_PATH || ''
if (!WALLET_PATH) {
  throw new Error('WALLET_PATH is not set!')
}
const JWK = JSON.parse(readFileSync(WALLET_PATH, 'utf-8'))
const SIGNER = new ArweaveSigner(JWK)

export async function publish(
  contractName: string,
  contractVersion: string,
  signer: TurboSigner
) {
  console.info(`Publishing LUA View Source for [${contractName}]`)
  console.info(`Using contract version: ${contractVersion}`)
  const bundledLuaPath = `./dist/${contractName}/process.lua`
  const bundledLuaSize = statSync(bundledLuaPath).size
  const turbo = TurboFactory.authenticated({ signer })
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

  console.info(`Publication result for ${contractName} contract source:`)
  console.dir(uploadResult, { depth: null })
}

publish(CONTRACT_NAME, CONTRACT_VERSION, SIGNER).then(() => {
  console.info('Publish contract script executed successfully!')
}).catch(error => {
  console.error(
    `Error executing publish contract script: ${error.message}`,
    error.stack
  )
  process.exit(1)
})
