if [[ $(which elixir) == "" ]]
then
  apt-get update \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

  export LANG=en_US.utf8 \
    
  apt-get update && apt-get install wget -y \
    && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install esl-erlang -y && apt-get install elixir -y
else
  source smache_rel/.env \
    && mv smache_rel/smache.tar.gz ./ \
    && tar -xzf smache.tar.gz \
    && mv smache_rel/rel ./ \
    && rel/boot.sh
fi
