# Smache

Elixir Cache as a Service

Serialized - fault tolerant - self caching - self sharding - Key Value Cache :rocket:

Provides a RESTful API that can handle concurrent requests (Phoenix) but serializes all writes to memory.

All serialized writes can be split up by amount of shards.

Default shard size is 4. Any other wanted size can be set via `SHARD_LIMIT` (Any number above 0).

RAM IO and all cache is handled using [ETS](https://elixir-lang.org/getting-started/mix-otp/ets.html).

Example supervision tree of a default shard size (4):

![](https://user-images.githubusercontent.com/9837366/37997853-005b93e0-31e2-11e8-9fe7-0e33eb54f943.PNG) 

_Suprisingly performant_ :smile:

## Development

**Deps**:

1. Docker
1. Elixir
1. Bash (masOS, Linux, WSL (Win10))

**On first boot**:

`./scripts/test.sh`

1. Generate Secret
1. Ensure all needed directories are made
1. Ensure everything is installed
1. Run tests
1. Create an Alpine Docker Container
1. Build release (not exposed, just testing it can build)

Essentially the _bootstrapping_ script :rocket:

Called test, because it ensures that your dev enviornment is ready to roll, and it runs tests :smile:

## Deploying to Heroku (for testing purposes)

Make sure the container builds (heroku will rebuild it anyways but just be sure it works)!

`./scripts/test.sh`

### If not logged in to Heroku

```bash
heroku login
heroku container:login
```

Now: `APP_NAME=<app_name> ./scripts/heroku.sh`

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

## Backing up data

1. Tarball: `./scripts/archive.tar.sh`
2. Zip: `./scripts/achrive.zip.sh`

## Current Benchmarks

~13k req/s in an Alpine Docker Container running on Ubuntu 17.10 in production mode on a 2 Core Intel i7 from 2013

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

### Another Alternative for Benching

_Default sharding is set to 4_

```bash
./scripts/console.bench.sh
```

**If you want to increase the shard size**

_You may set `SHARD_LIMIT` to any positive number over 0_

```bash
SHARD_LIMIT=16 ./scripts/console.bench.sh
```

_Remember this is synchronous and using a stream or a parallel map can be more realistic_

```elixir
alias Smache.Ets.Table, as: EtsTable

data = %{color: "blue"}

# if you changed SHARD_LIMIT
# ex: SHARD_LIMIT=24
# change 0..3 to 0..23 (or limit - 1)
ets_tables = 0..3 |> Enum.map(fn i -> :"ets_table_#{i}" end)

# this will be cold cache
0..20_000 |> Enum.each(fn i ->
  table_id = rem(i, length(ets_tables))
  EtsTable.fetch(i, data, Enum.at(ets_tables, table_id))
end)

# this will be warm cache
0..20_000 |> Enum.each(fn i ->
  table_id = rem(i, length(ets_tables))
  EtsTable.fetch(i, data, Enum.at(ets_tables, table_id))
end)
```

## LICENSE

**MIT**

See: `LICENSE` file in root of project
