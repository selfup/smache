# Frontend code example

```js
import { Socket } from 'phoenix';

const socket = new Socket('ws://localhost:4000/socket', {});

socket.connect();

// to receive events from all rooms or all data updates
// use the :all channel
// otherwise, sub to specific keys that you are worried about
// like - :players, :npcs, :etc..
// you can also send to a specific room in different components
// but the recieve all in main or something complex like that!
const chan = socket.channel('room:all');
chan.join();

chan.on('sync', ({ key, payload: { data } }) => {
  console.log(key, data);
});

// if you just want to recieve all updates, no need to push messages
// if you are trying to push updates to a specific room make sure to namespace!
chan.push('sync', { body: { key: '1', data: { color: new Date().getTime() } } });
```
