# Mainnet's
POLYGON_DEPLOYMENTS := osx-polygon admin-polygon multisig-polygon spp-polygon token-voting-polygon

# Testnet's

SEPOLIA_DEPLOYMENTS := osx-sepolia admin-sepolia multisig-sepolia spp-sepolia token-voting-sepolia
ZKSYNC_SEPOLIA_DEPLOYMENTS := osx-zksyncsepolia admin-zksyncsepolia multisig-zksyncsepolia spp-zksyncsepolia token-voting-zksyncsepolia
HOLESKY_DEPLOYMENTS :=

AVAILABLE_DEPLOYMENTS := $(POLYGON_DEPLOYMENTS) $(SEPOLIA_DEPLOYMENTS) \
	$(ZKSYNC_SEPOLIA_DEPLOYMENTS) $(HOLESKY_DEPLOYMENTS)
