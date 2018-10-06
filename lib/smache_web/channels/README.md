# Frontend code example

```js
import { Socket } from 'phoenix';

const socket = new Socket('ws://localhost:4000/socket', {});

socket.connect();

// to receive events from all rooms or all data updates use room:sub
// otherwise, get updates to specific rooms that you are worried about
// like => room:sub_players or room:sub_npcs
const ROOM_NAME = 'myRoom';

const chan = socket.channel(ROOM_NAME + 'all');
chan.join();

// YOU MUST USE THE FOLLOWING SYNTAX FOR ROOM NAMES!
// roomname_sub
// roomname_pub

// listen to published events
chan.on(ROOM_NAME + '_sub', ({ key, payload: { data } }) => {
  console.log(key, data);
});

// push updated state change to all subscribers
chan.push(ROOM_NAME + '_pub', {
  body: {
    key: '1',
    data: {
      sha: new Date().getTime(),
    },
  },
});
```
