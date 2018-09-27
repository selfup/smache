# Frontend code example

```js
import { Socket } from 'phoenix';

const socket = new Socket('ws://localhost:4000/socket', {});

socket.connect();

// to receive events from all rooms or all data updates
// use the :all channel
// otherwise, sub to specific keys that you are worried about
// like - :players, :npcs, :etc..
const chan = socket.channel('room:all');
chan.join();

chan.on('sync', ({ key, payload: { data } }) => {
  console.log(key, data);
});

chan.push('sync', { body: { key: '1', data: { color: new Date().getTime() } } });
```
