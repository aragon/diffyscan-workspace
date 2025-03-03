# DiffyScan workspace

## Get started

Ensure that you have `make` installed on your system:

```sh
$ make
Available targets:

- make init       Check the dependencies and prepare the Docker image
- make clean      Clean the generated artifacts

- make sepolia    Check the deployment from params/sepolia-deployment.json
- make holesky    Check the deployment from params/holesky-deployment.json
```

### Initialization

Prepare a Docker image with the up to date image.

```sh
make init
```

### Define the deployment parameters

Edit the parameters on a file named like `params/<network>-deployment.json`, containing the intended parameters:

```json
{
  "contracts": {
    "0x1957e052B9DfeF53d4FcB22f6372F8ea41049Ba1": "DAOFactory",
    "0x823546Acfb4ed490a37488391676859F1BE135B6": "PluginRepoFactory"
  },
  "explorer_hostname": "api-sepolia.etherscan.io",
  "explorer_token_env_var": "--- CHANGE THIS VALUE ---",
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
docker run --rm -it -v .:/app/ diffyscan params/*sepolia.json
```

## Adding new networks

Edit `Makefile` and add a new network entry to `SUPPORTED_NETWORKS`. 

If you run `make help` you will see a new target for it.

Copy `params/example.json` and adapt it into a new file named like `params/<network>-deployment.json`.
