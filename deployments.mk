SEPARATOR := ""

# Mainnet's
MAINNET_DEPLOYMENTS := osx-mainnet admin-mainnet multisig-mainnet token-voting-mainnet
POLYGON_DEPLOYMENTS := osx-polygon admin-polygon multisig-polygon token-voting-polygon
BASE_DEPLOYMENTS := osx-base admin-base multisig-base token-voting-base
ARBITRUM_DEPLOYMENTS := osx-arbitrum admin-arbitrum multisig-arbitrum token-voting-arbitrum
ZKSYNC_DEPLOYMENTS := osx-zksync admin-zksync multisig-zksync token-voting-zksync

# Testnet's

SEPOLIA_DEPLOYMENTS := osx-sepolia admin-sepolia multisig-sepolia token-voting-sepolia
HOLESKY_DEPLOYMENTS := osx-holesky admin-holesky multisig-holesky token-voting-holesky
ZKSYNC_SEPOLIA_DEPLOYMENTS := osx-zksyncsepolia admin-zksyncsepolia multisig-zksyncsepolia token-voting-zksyncsepolia

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
