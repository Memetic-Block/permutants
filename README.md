# Permutants

Tamagotchi-style virtual pets as [AO](https://ao.arweave.net/) smart contract processes on Arweave. Each spawned process is a single permutant that hatches, grows, evolves, and — if neglected — dies.

## How It Works

A permutant starts as an **egg**. The owner hatches it (giving it a name), then keeps it alive by sending **Feed**, **Play**, **Heal**, and **Sleep** messages. Stats decay over time using lazy evaluation — every interaction recalculates decay based on elapsed time since the last action.

### Lifecycle

```
Egg ──Hatch──▸ Baby ──1hr──▸ Child ──4hr──▸ Teen ──12hr──▸ Adult ──48hr──▸ Elder
                                                                              │
                                          Egg ◂──Revive── Dead ◂─health=0───┘
```

At each stage transition, the permutant's **variant** is determined by its dominant stat (e.g., highest happiness → "playful" baby, highest health → "resilient" teen).

### Stats

| Stat | Action | Effect |
|---|---|---|
| Hunger | `Feed` | +25 (capped at 100) |
| Happiness | `Play` | +25 |
| Health | `Heal` | +25 |
| Energy | `Sleep` | +25 |

All stats decay continuously. Decay rates increase at later lifecycle stages. If **health** reaches 0, the permutant dies and becomes a tombstone. The owner can **Revive** it back to an egg.

## Actions

All actions except `View-State` and `View-Roles` require owner permission.

| Action | Data | Description |
|---|---|---|
| `Hatch` | Name (string) | Hatch the egg, set permutant name |
| `Feed` | — | Restore hunger |
| `Play` | — | Restore happiness |
| `Heal` | — | Restore health |
| `Sleep` | — | Restore energy |
| `Revive` | — | Reset dead permutant to egg |
| `View-State` | — | Returns full state as JSON (public) |
| `Update-Roles` | JSON role grants/revokes | Manage ACL roles |
| `View-Roles` | — | Returns ACL state as JSON |

## State Shape

```json
{
  "name": "Blobby",
  "stage": "child",
  "variant": "joyful",
  "born_at": 1741872000000,
  "last_interaction": 1741875600000,
  "age": 3600,
  "stats": {
    "hunger": 72,
    "happiness": 85,
    "health": 90,
    "energy": 68
  }
}
```

## Project Structure

```
src/contracts/
  common/
    acl.lua            # Reusable role-based access control module
  permutant/
    config.lua         # Constants: decay rates, thresholds, boost amounts, variants
    decay.lua          # Lazy decay engine: tick(), newEgg()
    permutant.lua      # Main contract: state init, handlers, patches
scripts/
  bundle.ts            # Bundle Lua source into deployable process.lua
  spawn.ts             # Spawn a new AO process
  eval.ts              # Hot-reload contract code via Eval action
  action-message.ts    # Send an action message to a process
  publish.ts           # Upload bundled Lua to Arweave
```

## Usage

```bash
# Bundle the contract
CONTRACT_NAMES=permutant npm run bundle

# Spawn a new process
WALLET_PATH=./wallet.json PROCESS_NAME=my-permutant npm run spawn

# Deploy contract code to the process
WALLET_PATH=./wallet.json PROCESS_ID=<id> PROCESS_NAME=permutant npm run eval

# Hatch your permutant
WALLET_PATH=./wallet.json PROCESS_ID=<id> ACTION=Hatch DATA="Blobby" npm run action-message

# Feed it
WALLET_PATH=./wallet.json PROCESS_ID=<id> ACTION=Feed npm run action-message

# Check its state
WALLET_PATH=./wallet.json PROCESS_ID=<id> ACTION=View-State npm run action-message
```
