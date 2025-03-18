# Mainnet's
MAINNET_DEPLOYMENTS := osx-mainnet admin-mainnet multisig-mainnet spp-mainnet token-voting-mainnet
POLYGON_DEPLOYMENTS := osx-polygon admin-polygon multisig-polygon spp-polygon token-voting-polygon
BASE_DEPLOYMENTS := osx-base admin-base multisig-base spp-base token-voting-base
ARBITRUM_DEPLOYMENTS := osx-arbitrum admin-arbitrum multisig-arbitrum spp-arbitrum token-voting-arbitrum

# Testnet's

SEPOLIA_DEPLOYMENTS := osx-sepolia admin-sepolia multisig-sepolia spp-sepolia token-voting-sepolia
ZKSYNC_SEPOLIA_DEPLOYMENTS := osx-zksyncsepolia admin-zksyncsepolia multisig-zksyncsepolia spp-zksyncsepolia token-voting-zksyncsepolia
HOLESKY_DEPLOYMENTS :=

AVAILABLE_DEPLOYMENTS := $(MAINNET_DEPLOYMENTS) $(POLYGON_DEPLOYMENTS) $(BASE_DEPLOYMENTS) $(ARBITRUM_DEPLOYMENTS) \
	$(SEPOLIA_DEPLOYMENTS) $(ZKSYNC_SEPOLIA_DEPLOYMENTS) $(HOLESKY_DEPLOYMENTS)
