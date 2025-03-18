SEPARATOR := ""

# Mainnet's
MAINNET_DEPLOYMENTS := osx-mainnet admin-mainnet multisig-mainnet spp-mainnet token-voting-mainnet
POLYGON_DEPLOYMENTS := osx-polygon admin-polygon multisig-polygon spp-polygon token-voting-polygon
BASE_DEPLOYMENTS := osx-base admin-base multisig-base spp-base token-voting-base
ARBITRUM_DEPLOYMENTS := osx-arbitrum admin-arbitrum multisig-arbitrum spp-arbitrum token-voting-arbitrum
ZKSYNC_DEPLOYMENTS := osx-zksync admin-zksync multisig-zksync spp-zksync token-voting-zksync

# Testnet's

SEPOLIA_DEPLOYMENTS := osx-sepolia admin-sepolia multisig-sepolia spp-sepolia token-voting-sepolia
ZKSYNC_SEPOLIA_DEPLOYMENTS := osx-zksyncsepolia admin-zksyncsepolia multisig-zksyncsepolia spp-zksyncsepolia token-voting-zksyncsepolia
HOLESKY_DEPLOYMENTS :=

AVAILABLE_DEPLOYMENTS := \
	$(MAINNET_DEPLOYMENTS) $(SEPARATOR) \
	$(POLYGON_DEPLOYMENTS) $(SEPARATOR) \
	$(BASE_DEPLOYMENTS) $(SEPARATOR) \
	$(ARBITRUM_DEPLOYMENTS) $(SEPARATOR) \
	$(ZKSYNC_DEPLOYMENTS) $(SEPARATOR) \
	\
	$(SEPOLIA_DEPLOYMENTS) $(SEPARATOR) \
	$(ZKSYNC_SEPOLIA_DEPLOYMENTS) $(SEPARATOR) \
	$(HOLESKY_DEPLOYMENTS)
