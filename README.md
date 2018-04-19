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

Currently the simplest solution is to make a shared volume for nodes to register themselves.

In order to do so, a directory is made here: `smache_mnt`

SSHFS will need to be used in production unless you use some magic infra that provides a shared mount by infering the docker-compose file :boom:

In the future, a simple `:rpc` service called `yo` will be used as the registry :pray:

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
1. Bash (masOS, Linux, WSL (Win10))

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
./scripts/dev.sh 4000 foo

# in another shell
./scripts/dev.sh 4001 bar
```

Now run the curl scripts (in a third shell):

```bash
./scripts/curl.post.sh 4000

./scripts/curl.get.sh 4001
```

## Deploying to Heroku (for testing a single node)

Make sure the container builds (heroku will rebuild it anyways but just be sure it works)!

`./scripts/smache.sh`

If you have made changes to the source code prior to running that script please pass a `--build` flag to ensure the container compiles your new source code.

Ex: `./scripts/smache.sh --build`

### If not logged in to Heroku Container Registry

```bash
heroku login
heroku container:login
```

Now: `./scripts/heroku.sh my_cool_app_name`
<!--

## Deploying to Digital Ocean/Vultr/EC2

Make sure you have Docker and docker-compose!
Make sure you have your ssh key as an authorized key for your target node!

### Build the release with Docker

1. In one shell: `./scripts/docker.release.sh`
1. In another shell (once release is built): `./scripts/docker.copy.release.sh`
1. Grab tarball and scp: `scp -r ./smache.tar.gz user@<target_ip>:/home/user`
1. SSH into your server: `ssh user@<target_ip>`
1. Unpack the tarball: `tar -xzf smache.tar.gz`
1. Run the server:

        a. As a Daemon: `PORT=<port> ./bin/smache start`
        b. In the foreground: `PORT=<port> ./bin/smache foreground`
        c. In interactive mode: `PORT=<port> ./bin/smache console`

## Current Benchmarks

On a single shard (so imagine just one ets table)

~13k req/s in an Alpine Docker Container running on Ubuntu 4.10 in production mode on a 2 Core Intel i7 from 2013

**CPU Info**

```bash
Model name:          Intel(R) Core(TM) i7-4558U CPU @ 2.80GHz
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  2
Core(s) per socket:  2
Socket(s):           1
```

### To run benchmarks

You will need two tabs/panes/shell for this:

1. Build the container and run it: `./scripts/test.sh`
2. Wait for: `Attaching to smache_prod_1`
3. Run the bench suite in a different shell/pane/tab: `./scripts/bench.sh`

        a. To keep changes in git HEAD pass the `-c` flag
        b. Ex: `./scripts/bench.sh -c`
        c. Otherwise the `.results.log` file will be checked out
-->

## LICENSE

Licensed under the [MIT License](https://choosealicense.com/licenses/mit/)

[See LICENSE file in root of project](https://github.com/selfup/smache/blob/master/LICENSE)
