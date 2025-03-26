# DiffyScan workspace

An easy to use workspace for verifying contract source code using [Lido's DiffyScan](https://github.com/lidofinance/diffyscan) tool.

This repository comes preconfigured to verify Aragon OSx and Aragon's plugin source code, but it can be adapted to verify any smart contract.

## Get started

Ensure that you have `make` installed on your system:

```sh
$ make
Available targets:
- make help       Display the current message

- make init               Check the dependencies and prepare the Docker image
- make clean              Clean the generated artifacts
- make diff-summary       Show the detected mismatches on the latest run under ./digest

- make osx-sepolia        Verify using deployments/osx-sepolia.json
- make admin-sepolia      Verify using deployments/admin-sepolia.json
- make multisig-sepolia   Verify using deployments/multisig-sepolia.json
- make spp-sepolia        Verify using deployments/spp-sepolia.json
- make token-voting-sepolia         Verify using deployments/token-voting-sepolia.json
[...]
```

### Initialization

Prepare a Docker image with the up to date image.

```sh
make init
```

### Define the deployment parameters

Copy `.env.example` into `.env` and define the required values.

Given the network that you are targetting, define the intended parameters on a file named like `deployments/<target>.json`:

```json
{
  "contracts": {
    "0x1957e052B9DfeF53d4FcB22f6372F8ea41049Ba1": "DAOFactory",
    "0x823546Acfb4ed490a37488391676859F1BE135B6": "PluginRepoFactory"
  },
  "explorer_hostname": "api-sepolia.etherscan.io",
  "explorer_token_env_var": "--- This value is automatically filled from .env ---",
  "github_repo": {
    "url": "https://github.com/aragon/osx",
    "commit": "423014c01ebd49f24f8c82646540fe49309a6e9e",
    "relative_root": "packages/contracts"
  },
  // ...
  "bytecode_comparison": {
    "constructor_calldata": {},
    "constructor_args": {}
  }
}
```


## Run it

Run make with your target deployment to verify:

```sh
make osx-sepolia
```

## Adding new networks

Edit `deployments.mk` and add a new network entry to `AVAILABLE_DEPLOYMENTS`.

Run `make help` and check that the new deployment appears.

Copy `deployments/example.json` into a new file under `deployments/<deployment-name>.json` and adapt it to contain the relevant values for the new deployment.
