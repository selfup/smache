# Smache

Elixir Cache as a Service :tada: _warning this is alpha stage software_

Serialized - fault tolerant - self sharding - Key Value Cache :rocket:

1. Provides a RESTful API that can handle concurrent requests (Phoenix) but serializes all writes to memory
1. When nodes are behind a load balancer every node you add can become conected to each other
1. Distribute your cache by adding machines (shards) and they automaitcally figure out where to grab data
1. RAM IO and all cache is handled using [ETS](https://elixir-lang.org/getting-started/mix-otp/ets.html)

_Suprisingly performant_ :smile:

## Built for Load Balancing

Load Balance your cluster of cache nodes (static or dynamic) and performance increases linearly! :tada:

1. Static clusters (say you stick with 20 forever)

        a. Will never wipe data (unless rebooted, or the node crashes)
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

All nodes are dependant on a node longname to be provided on bootup to connect to the network :rocket:

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

## Development

**Deps**:

1. Docker
1. Elixir
1. Bash
1. macOS or Linux (Windows can work but is cumbersome)

**On first boot**:

`./scripts/test.sh && ./scripts/services.sh`

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
./scripts/services.sh

# if the second ip addr has a different 2nd ip number...
# Example: self: smache@172.27.0.2 - uplink: smache@172.20.0.2
# TWO=27 ./scripts/services.sh

./scripts/curl.post.sh 1234 1237

./scripts/curl.get.sh 1235 1236
```

## LICENSE

Licensed under the [MIT License](https://choosealicense.com/licenses/mit/)

[See LICENSE file in root of project](https://github.com/selfup/smache/blob/master/LICENSE)
