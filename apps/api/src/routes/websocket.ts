import type { FastifyPluginAsync } from 'fastify';

interface WSMessage {
  type: string;
  payload?: unknown;
  userId?: string;
}

export const registerWebsocketRoutes: FastifyPluginAsync = (fastify) => {
  fastify.get('/ws', { websocket: true }, (connection, _request) => {
    void _request;

    connection.on('message', (message: Buffer | string) => {
      try {
        const parsed = JSON.parse(message.toString()) as unknown as WSMessage;

        if (parsed.type === 'user-typing') {
          // Broadcast to all other connected clients
          for (const client of fastify.websocketServer.clients) {
            if (client !== connection && client.readyState === 1) {
              // OPEN
              client.send(
                JSON.stringify({
                  type: 'user-typing',
                  userId: parsed.userId,
                  payload: parsed.payload,
                }),
              );
            }
          }
        }
      } catch (error) {
        fastify.log.error({ err: error }, 'Failed to parse websocket message');
      }
    });

    connection.on('close', () => {
      // Clean up connection state if needed
    });
  });

  return Promise.resolve();
};
