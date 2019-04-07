# Smache

Cache that can get Smashed :tada: _warning this is alpha stage software_

Distributed - Scalable - Serialized - Immutable - Fault Tolerant - Self Sharding - Key Value Cache :rocket:

1. Provides a JSON API that can handle concurrent requests (Phoenix) but serializes all writes to memory
1. When nodes are behind a load balancer every node you add can become connected to each other (distributed)
1. Distribute your cache by adding machines (shards) and they automaitcally figure out where to grab data
1. RAM IO and all cache is handled using [ETS](https://elixir-lang.org/getting-started/mix-otp/ets.html)

_Suprisingly performant_ :smile:

## Release Repo

Over at GitLab the release repo lives!

Repo: https://gitlab.com/selfup/smache

Docker Registry for Smache: `registry.gitlab.com`

Image tag: `registry.gitlab.com/selfup/smache:latest`

## Purpose

High frequency short term cache storage. If this does not fit your bill there are caveats!

Common use cases would be something like location data for realtime applications (Uber/Lyft/etc...)

### Example JSON API

### Healthcheck

**GET** `/`

Returns an empty object in json: `{}`

### Get Key

**GET** `/api`

Params: `?key=some_key`

Returns (for now) key/data/node

```json
{
  "key": "some_key",
  "data": {
    "color": "blue"
  },
  "node": "smache@localhost"
}
```

### Post Data

**POST** `/api`

_key should be numbers but can be any string_

_data key must always be an object_

```json
{
  "key": "something",
  "data": {
    "msg": "hello"
  }
}
```

## Why was this built?

As an expirement. Turns out it works.

Here's why developement has continued:

1. Each node becomes it's own shard. Automagically
1. Very cheap to run idle, auto scaling takes care of the rest like stateless apis
1. Some of the data has to rebuild but that's not a big deal in it's use case
1. Location data is only valid for a certain amount of time
1. This was initially built as a backpressure mitigation tool for High IO NoSQL data
1. It turns out it's really fast

## Built for Load Balancing

Load Balance your cluster of cache nodes (static or dynamic)

1.  Static clusters (say you stick with 20 forever)

        a. Will never lose references to existing data (unless rebooted, or the node crashes)
        b. Will be easier to maintain

2.  Dynamic clusters (auto scaling)

        a. Will lose a percentage of data per shard on expansion/shrinkage
        b. Data rebuilds as fast as it did the first time
        c. Best price to performance ratio

## TODOS

1. Figure out cache invalidation strategies
1. Wipe old data from nodes that have a new respective shard

## Caveats

Stale data is still a thing for now. :sob:

All nodes are dependant on a node longname (`smache@internal_ip`) to be provided on bootup to connect to the network :rocket:

No TLS support for internal calls. Must be in a VPC or a managed cluster. Also Digital Ocean has sweet Private Networking features.

To auto shard at scale, all keys are turned into an integer if not already an integer :warning:

All nil/null keys are rejected with a 405 :boom:

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

Consider using shas or ids only. Numeric ids are prefered!

## Development

**Deps**:

1. Docker
1. Elixir
1. Bash
1. macOS or Linux (Windows can work but is cumbersome)

**On first boot**:

`./scripts/services.sh`

1. Generate Secret/Cookie
1. Ensure deps are installed and compiled
1. Build the image
1. Run all 4 containers

Essentially the _bootstrapping_ scripts :rocket:

### Have two local nodes talk to eachother in dev

```bash
# in one shell

./scripts/dev.sh 4000 smache@localhost localhost

# in a second shell
./scripts/dev.sh 4001 smache_two@localhost localhost
```

Now run the curl scripts (in a third shell):

```bash
./scripts/curl.post.sh 4000

./scripts/curl.get.sh 4001
```

### How to have 4 nodes talk via docker

```bash
# boots a Load Balancer (haproxy) and 4 smache nodes
./scripts/services.sh

# posts 7 different keys and data
./scripts/curl.post.sh 8080

# gets all posted data
./scripts/curl.get.sh 8080
```

### Performance (stress test)

Linux / Ubuntu 18.04.1

**Single node**

_900 clients_

Control (health check returning empty JSON object):

```ocaml
Finished 50000 requests

--> results:

    Time taken for tests:   1.637 seconds
    Requests per second:    30539.96 [#/sec] (mean)
      50%     28 ms
      95%     46 ms
     100%     76 (longest request)
```

---

**Single Node**

_900 clients_

POST key/data return data in JSON:

```ocaml
Finished 50000 requests

--> results:

    Time taken for tests:   2.136 seconds
    Requests per second:    23411.13 [#/sec] (mean)
      50%     37 ms
      95%     62 ms
     100%     94 (longest request)
```

GET key return key/data/node in JSON:

```ocaml
Finished 50000 requests

--> results:

    Time taken for tests:   1.880 seconds
    Requests per second:    26595.15 [#/sec] (mean)
      50%     32 ms
      95%     52 ms
     100%     78 (longest request)
```

**Two Nodes (force distributed RPC calls)**

_900 clients_

POST key/data return data in JSON:

```ocaml
Finished 50000 requests

--> results:

    Time taken for tests:   2.845 seconds
    Requests per second:    17576.51 [#/sec] (mean)
      50%     50 ms
      95%     77 ms
     100%    118 (longest request)
```

GET key return key/data/node in JSON:

```ocaml
Finished 50000 requests

--> results:

    Time taken for tests:   2.681 seconds
    Requests per second:    18651.75 [#/sec] (mean)
      50%     46 ms
      95%     76 ms
     100%    167 (longest request)
```

### Internal Performance

```elixir
1..4 |> Enum.each(fn _ -> Smache.Mitigator.bench() end)
```

Results:

10k records written then read in: 18.593 ms
10k records written then read in: 17.226 ms
10k records written then read in: 15.206 ms
10k records written then read in: 15.007 ms

10k records written then read in: 39.919 ms
10k records written then read in: 15.344 ms
10k records written then read in: 16.827 ms
10k records written then read in: 15.346 ms
