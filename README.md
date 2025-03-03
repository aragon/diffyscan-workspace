# DiffyScan workspace

An easy to use workspace for verifying contract source code using [Lido's DiffyScan](https://github.com/lidofinance/diffyscan) tool.

This repository comes preconfigured to verify Aragon OSx and Aragon's plugin source code, but it can be adapted to verify any smart contract.

## Get started

Ensure that you have `make` installed on your system:

```sh
$ make
Available targets:

- make init       Check the dependencies and prepare the Docker image
- make clean      Clean the generated artifacts

- make check-sepolia    Check the deployment from params/sepolia-deployment.json
- make check-holesky    Check the deployment from params/holesky-deployment.json
```

### Initialization

Prepare a Docker image with the up to date image.

```sh
make init
```

### Define the deployment parameters

Copy `.env.example` into `.env` and define the required values.

Given the network that you are targetting, define the intended parameters on a file named like `params/<network>-deployment.json`:

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
    "hardhat_config_name": "hardhat/holesky-config.js",
    "constructor_calldata": {},
    "constructor_args": {}
  }
}
```

Ensure that the file referenced by `hardhat_config_name` (`hardhat/*-config.js`) corresponds to your target network.

## Run it

Run the tool with your configuration:

```sh
make check-sepolia
```

## Adding new networks

Edit `Makefile` and add a new network entry to `SUPPORTED_NETWORKS`. 

If you run `make help` you will see a new target for it.

Copy `params/example.json` and adapt it into a new file named like `params/<network>-deployment.json`.
