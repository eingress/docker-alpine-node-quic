# Alpine Node QUIC

**As of Node.js v15.8.0 experimental QUIC support has been removed.**

## Usage

Default ```WORKDIR``` is ```/app```.

```bash
# mount current directory and start a shell
docker run -it --rm -v $(pwd):/app eingressio/alpine-node-quic

# launch a node repl
docker run -it --rm eingressio/alpine-node-quic node
```

Please see the [QUIC](https://nodejs.org/api/quic.html) section of the Node.js docs for more information.

## Example

```javascript
'use strict';

const key = getTLSKeySomehow();
const cert = getTLSCertSomehow();

const { createQuicSocket } = require('net');

// Create the QUIC UDP IPv4 socket bound to local IP port 1234
const socket = createQuicSocket({ endpoint: { port: 1234 } });

socket.on('session', async (session) => {
  // A new server side session has been created!

  // The peer opened a new stream!
  session.on('stream', (stream) => {
    // Let's say hello
    stream.end('Hello World');

    // Let's see what the peer has to say...
    stream.setEncoding('utf8');
    stream.on('data', console.log);
    stream.on('end', () => console.log('stream ended'));
  });

  const uni = await session.openStream({ halfOpen: true });
  uni.write('hi ');
  uni.end('from the server!');
});

// Tell the socket to operate as a server using the given
// key and certificate to secure new connections, using
// the fictional 'hello' application protocol.
(async function() {
  await socket.listen({ key, cert, alpn: 'hello' });
  console.log('The socket is listening for sessions!');
})();
```
