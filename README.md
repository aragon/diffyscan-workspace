# DiffyScan workspace

## Get started

Prepare a Docker image with the up to date image.

```sh
docker build -t diffyscan .
```

## Deployment parameters

Verify or addapt the configuration on `params/example.json`:

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
