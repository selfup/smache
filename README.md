# Smache

Cache that can get Smashed :tada: _warning this is alpha stage software_

Distributed - Scalable - Serialized - Immutable - Fault Tolerant - Self Sharding - Key Value Cache :rocket:

1. Provides a RESTful API that can handle concurrent requests (Phoenix) but serializes all writes to memory
1. When nodes are behind a load balancer every node you add can become connected to each other (distributed)
1. Distribute your cache by adding machines (shards) and they automaitcally figure out where to grab data
1. RAM IO and all cache is handled using [ETS](https://elixir-lang.org/getting-started/mix-otp/ets.html)

_Suprisingly performant_ :smile:

Current benchmarks on a 4GHz 3770k with DDR3 RAM (all orchestrated with kubernetes):

- 1 Machine
- 4 Smaches
- 1 Nginx Load Balancer
- 1 Bench Suite
- 1 Set of Nginx Activity Logs

**105k req/s**

If the concurrency of requests are only double that of the actual nodes in the cluster response times are:

_10k requests and 14 concurrency (7 nodes)_

1. 50% 400us
1. 95% 800us
1. 100% 1ms (longest request)

If the concurrency of request are a giant multitude of the nodes in the cluster response times are:

_10k requests and 100 concurrency (7 nodes)_

1. 50% 1ms
1. 95% 2ms
1. 100% 6ms (longest request)

_20k requests and 200 concurrency (7 nodes)_

1. 50% 1ms
1. 95% 3ms
1. 100% 9ms (longest request)

_30k requests and 400 concurrency (7 nodes)_

1. 50% 3ms
1. 95% 5ms
1. 100% 15ms (longest request)

Request per second remain stable, but some backpressure gets created at different intervals.

You can see anywhere from 65k to 115k req/s

**This can mostly be attributed to nginx activity logs on the same machine and heavy IO on the same machine.**

Smache only logs warnings/errors.

## Purpose

High frequency short term cache storage. If this does not fit your bill there are caveats!

Common use cases would be something like location data for realtime applications (Uber/Lyft/etc...)

## Caching solutions already exist?

Memcache and redis are big players in the game.

These take a different approach. They use connection pools and have a limit of how many clients can be connected.

They are also very fast!

You also run into the idea of a Master/Slave replica concept. Your clusters are really just all the same data, which means RAM and more RAM.

However these are more long term cache solutions. Smache is not that!

Think of this as a RESTful MongoDB without schemas and a flat single table that does not persist.

## Why was this built?

As an expirement. Turns out it works.

Here's why developement has continued:

1. Each node becomes it's own shard. Automagically
1. Bottleneck is the load balancer
1. Very cheap to run idle, auto scaling takes care of the rest like stateless apis
1. The data has to rebuild but that's not a big deal in it's use case
1. Location data is only valid for a certain amount of time
1. Rebuilding provides more accuracy anyways
1. This was initially built as a backpressure mitigation tool for High IO NoSQL data
1. It turns out it's really fast
1. It's only 300 ish lines of runtime code
1. The rest of the functionality comes from the battletested Erlang BEAM

## Built for Load Balancing

Load Balance your cluster of cache nodes (static or dynamic) and performance increases linearly! :tada:

1. Static clusters (say you stick with 20 forever)

        a. Will never lose references to existing data (unless rebooted, or the node crashes)
        b. Will be easier to maintain
        c. No big worry about data loss, it will be very rare (if at all)

2. Dynamic clusters (auto scaling)

        a. Will lose data per shard on expansion as well as shrinkage
        b. Data rebuilds as fast as it did the first time
        c. Best price to performance ratio
        d. Requires being ok with losing cache at the cost of reducing price

## TODOS

1. Expirement with Websocket support
2. Figure out cache invalidation strategies
3. Wipe old data from nodes that have a new respective shard (dynamic expansion)

## Caveats

Stale data is still a thing for now. :sob:

All nodes are dependant on a node longname (`smache@internal_ip`) to be provided on bootup to connect to the network :rocket:

No TLS support for internal calls. Must be in a VPC or a managed cluster. Also Digital Ocean has sweet Private Networking features.

To auto shard at scale, all keys are turned into an integer if not already an integer :thinking:

All nil/null keys are rejected with a 403 :boom:

If you plan to use integers and strings (as keys), please read the following:

Examples:

1. `1` -> `1` (integer remains an integer)
2. `"1"` -> `1` (string that can be casted into integer)
3. `"aa"` -> `24_929` (string that needs to be encoded into an integer)
4. `"aaa"` -> `6_381_921` (string that needs to be encoded into an integer)
5. `"abcd"` -> `1_633_837_924` (string that needs to be encoded into an integer)

_Simply put:_ to avoid collisions (int/char) check the range of a string to see how far up you can use a normal integer key.

For example here:

1. 4 chars starts at 1.6+ billion
1. 3 chars starts at 6.3+ million
1. 2 chars starts at 24+ thousand

Unless you are storing that much data, make sure to store strings of a certain length to ensure they do not colide with already stored integers (or vice versa) :pray:

Consider using shas or ids only.

An ENV var can be read to ensure that heavy string to uint conversion doesn't need to happen.

## Development

**Deps**:

1. Docker
1. Elixir
1. Bash
1. macOS or Linux (Windows can work but is cumbersome)

**On first boot**:

`./scripts/services.sh`

1. Generate Secret
1. Ensure deps are installed and compiled
1. Run tests
1. Build the image
1. Run all 4 containers

Essentially the _bootstrapping_ scripts :rocket:

### Have two local nodes talk to eachother in dev

```bash
# in one shell

# grab everything before .local
hostname #=> something.local

./scripts/dev.sh 4000 foo foo@something

# in another shell
./scripts/dev.sh 4001 bar foo@something
```

Now run the curl scripts (in a third shell):

```bash
./scripts/curl.post.sh 4000 4000

./scripts/curl.get.sh 4001 4001
```

### How to have 4 nodes talk via docker

```bash
# boots a Load Balancer (nginx) and 4 smache nodes
./scripts/services.sh

# posts 7 different keys and data
./scripts/curl.post.sh 8080

# gets all posted data
./scripts/curl.get.sh 8080
```

## Deployment

Other than Docker no deps are needed to build containers.

If you have your own load balancer just: `docker-compose -f kompose/docker-compose.yml build`

Do needed modifications to the deployment yamls for K8S or roll your own.

Ship the nodes to your prefered orchestrator. Do not scale the `uplink` node.

While it is part of the distributed mesh, it is the single point of truth for new nodes.

With K8s when the downlinks boot up they might restart once if the uplink node is not up yet.

This is normal.

## Network split

This will suck because it just does.

However this is a masterles system. So technically data will provided and rebuilt in the available network.

Once the network is restored:

1. At this point scale down to a good amount of nodes
1. Let the cache rebuild
1. Scale up or let autoscalers do their thing
