> [!WARNING]
> This is still in progress guide. But it consists already useful information.

# Introduction

This guide aims to demonstrate the setup of multiple post services using go-spacemesh. It assumes familiarity with the setup and employs a standalone network for ease of illustration.

Using a similar setup for a production environment is feasible, but that's not the purpose of this guide.

We will create a simple network topology for the post services and then construct a directed acyclic graph (DAG) to manage the post services.

# 1:n post service guide with a standalone network

## Prerequisites

1. A Linux or MacOS system. This guide has not been tested on Windows.
2. [go-spacemesh](https://github.com/spacemeshos/go-spacemesh/releases) version 1.4.0-alpha.3 or later, unzipped and located in the `./go-spacemesh` directory beside the `config.json` file. This file is the configuration for the node in the standalone setup and is tailored for this demonstration.
3. [postcli](https://github.com/spacemeshos/post-rs/releases) version 0.7.1 or later in the `./postcli` directory.
4. [dagu](https://github.com/dagu-dev/dagu/releases) version 1.12.9 or later available in the `./dagu` directory.

## Standalone network

We will operate a network with epochs lasting 15 minutes, layers that last for 1 minute, with a poet cycle gap of 5 minutes and a phase shift of 10 minutes.

Please note that in standalone mode, the poet works within the same process as the node, which might lead to occasional 100% usage of one CPU core.

The only parameter not pre-set in the config is the genesis time. Ideally, set this time a little into the future to allow for preparation of the post services for the first epoch. For this guide, we will set it as `2024-03-08T14:30:00Z`

# The setup

## Dagu setup

As we touched on in the introduction, we will use DAGU to coordinate the post proving processes.

1. Start dagu with the following command while in the `dagu` directory:

```
./dagu server -d dags
```

By default, the Dagu UI will be accessible at `http://localhost:8080`

## Post initialization and node setup

1. Start the node using the following command:

```
./go-spacemesh -c config.json --preset=standalone --genesis-time=2024-03-08T14:30:00Z --grpc-json-listener 127.0.0.1:10095 -d ../node_data | tee -a node.log
```

2. Go to DAGU and execute the `init` DAG. It will set up the post data with `postcli`, retrieve the `goldenATX` from the node API, and copy the `identity.key` from each post data folder to the node data directory.
3. Confirm the initialization was successful by checking that the DAGU status for that DAG is `finished`.
4. Stop the node. This is necessary because the node does not reload keys from disk by design.
5. Remove the `local.key` file from the node data directory. The setup of multiple post services requires the deletion of the node's `local.key` file. The node will not start if this file is present.
6. Restart the node with the same command as in step 1 and keep it running.

### Setup description

In the `init.yaml` DAG, you'll notice we have set up 10 post directories. We've chosen this naming scheme to resemble a realistic scenario.

```
post/diskA_post1
├── identity.key
├── postdata_0.bin
└── postdata_metadata.json
... (similar structure for other post directories)
```

Imagine each `disk*` as a separate physical disk and each `_post*` as a separate post service operating on that disk.

We aim for a configuration where no more than one post service is proven at a time per disk and, at the same time, we are comfortable running all necessary post proving processes on different disks.

The DAG is a straightforward orchestration of post proving processes. It will execute post proving processes in the order we want, based on the dependencies we define.

> [!WARNING]
> This setup is meant for demonstration purposes only. There are other ways to achieve similar results, and this particular setup should not be employed in a production environment.

## Starting the post services

You can now go to DAGU and run the `proving` DAG. This will begin the initial post proving processes for each post service.

Upon successful execution, you'll see the resulting DAG as such:
![Proving DAG](docs/proving_dag.png)

The visualization clearly displays the dependencies and the sequence of the post proving processes.

Each post proving process represents an individual post service that is started when needed and stopped after fulfilling its purpose.
