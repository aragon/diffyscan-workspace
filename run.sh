#!/bin/bash

if [ ! -f ".env" ]
then
  echo "Error: .env is not present"
  exit 1
fi

source .env
export GITHUB_API_TOKEN
export ETHERSCAN_EXPLORER_TOKEN

if [ -z "$GITHUB_API_TOKEN" ]
then
  echo "Error: GITHUB_API_TOKEN env var is empty"
  exit 1
fi

if [ -z "$ETHERSCAN_EXPLORER_TOKEN" ]
then
  echo "Error: ETHERSCAN_EXPLORER_TOKEN env var is empty"
  exit 1
fi

/root/.local/bin/diffyscan $1
