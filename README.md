# DiffyScan workspace

Prepare a Docker image with the up to date image.

```sh
docker build -t diffyscan .
```

Run the container with your configuration:

```sh
docker run --rm -it -v .:/app/ diffyscan config/*sepolia.json
```

