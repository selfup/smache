# Smache

Elixir Cache as a Service

Serialized - fault tolerant - self sharding - Key Value Cache :rocket:

Provides a RESTful API that can handle concurrent requests (Phoenix) but serializes all writes to memory.

All serialized writes can be split up by amount of shards.

Default shard size is 17. Any other wanted size can be set via `SHARD_LIMIT` (Any number above 0).

RAM IO and all cache is handled using [ETS](https://elixir-lang.org/getting-started/mix-otp/ets.html).

Example supervision tree of a default shard size (17):

![smache](https://user-images.githubusercontent.com/9837366/38340903-7fc9865a-383b-11e8-9adc-b0641291a5c7.PNG)

_Suprisingly performant_ :smile:

## Caveats

To auto shard at scale, all keys are turned into an integer if not already an integer :thinking:

All nil/null keys are rejected with a 403 :boom:

If you plan to store integers as well as regular strings, please consider a different strategy :thinking:

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

On a single shard (so imagine just one ets table)

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

## LICENSE

**MIT**

See: `LICENSE` file in root of project
