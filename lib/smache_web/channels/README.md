# Frontend code example

```js
import { Socket } from 'phoenix';

const socket = new Socket('ws://localhost:4000/socket', {});

socket.connect();

const chan = socket.channel('room:pubsub');
chan.join();

chan.on('sync', ({ key, payload: { data } }) => {
  console.log(key, data);
});

chan.push('sync', { body: { key: '1', data: { color: new Date().getTime() } } });
```
