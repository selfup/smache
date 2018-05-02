# Smache

Elixir Cache as a Service :tada: _warning this is alpha stage software_

Serialized - fault tolerant - self sharding - Key Value Cache :rocket:

1. Provides a RESTful API that can handle concurrent requests (Phoenix) but serializes all writes to memory
1. All serialized writes can be split up by amount of shards (to deal with concurrency backpressure)
1. Default shard size is 4
1. Any other wanted size can be set via `SHARD_LIMIT` (Any number above 0)
1. RAM IO and all cache is handled using [ETS](https://elixir-lang.org/getting-started/mix-otp/ets.html)

Example supervision tree of a default shard size (4):

![smache](https://user-images.githubusercontent.com/9837366/38791748-07b6a3c8-410f-11e8-9b31-f1a0daa752df.png)

The random PID is for the Node Discovery Loop :pray:

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

Currently the simplest solution is to make a main registry service for nodes to register themselves.

This registry is called **uplink**.

All worker nodes are dependant on this node being up first/forever :rocket:

To auto shard at scale, all keys are turned into an integer if not already an integer :thinking:

All nil/null keys are rejected with a 403 :boom:

If you plan to store integers (or strings that directly map to integers as keys) as well as regular strings (as keys), please understand the following strategies! :thinking:

Examples:

1. `1` -> `1`
2. `"1"` -> `1`
3. `"aa"` -> `24_929`
4. `"aaa"` -> `6_381_921`
5. `"abcd"` -> `1_633_837_924`

_Simply put:_ to avoid collisions check the range of a string to see how far up you can use a normal integer key.

For example here:

1. 4 chars starts at 1.6+ billion...
1. 3 chars starts at 6.3+ million
1. 2 chars starts at 24+ thousand

So unless you are storing that much data, make sure to store strings of a certain length to ensure they do not colide with already stored integers :pray:

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

## LICENSE

Licensed under the [MIT License](https://choosealicense.com/licenses/mit/)

[See LICENSE file in root of project](https://github.com/selfup/smache/blob/master/LICENSE)
