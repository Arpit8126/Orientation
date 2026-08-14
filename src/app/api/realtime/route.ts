import { sseClients } from '@/lib/db'

export async function GET(request: Request) {
  const responseStream = new ReadableStream({
    start(controller) {
      // Add the controller stream to sseClients
      sseClients.add(controller)

      // Send initial connection message
      controller.enqueue(new TextEncoder().encode('data: connected\n\n'))

      // Periodically send keep-alive comment packets to prevent request dropouts
      const keepAliveInterval = setInterval(() => {
        try {
          controller.enqueue(new TextEncoder().encode(': keepalive\n\n'))
        } catch (e) {
          clearInterval(keepAliveInterval)
          sseClients.delete(controller)
        }
      }, 15000)

      // Remove from client registry when request is cancelled/aborted
      request.signal.addEventListener('abort', () => {
        clearInterval(keepAliveInterval)
        sseClients.delete(controller)
      })
    },
    cancel() {
      // Stream cancelled
    }
  })

  return new Response(responseStream, {
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache, no-transform',
      'Connection': 'keep-alive'
    }
  })
}
