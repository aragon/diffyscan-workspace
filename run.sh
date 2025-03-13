#!/bin/bash

if [ ! -f ".env" ]
then
  echo "Error: .env is not present"
  exit 1
fi

source .env

if [ -z "$GITHUB_API_TOKEN" ]
then
  echo "Error: GITHUB_API_TOKEN env var is empty"
  exit 1
fi

if [ -z "$BLOCK_EXPLORER_API_KEY" ]
then
  echo "Error: BLOCK_EXPLORER_API_KEY env var is empty"
  exit 1
fi

export GITHUB_API_TOKEN
export ETHERSCAN_EXPLORER_TOKEN=$BLOCK_EXPLORER_API_KEY

/root/.local/bin/diffyscan $1
