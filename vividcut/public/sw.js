const CACHE_NAME = 'vividcut-assets-cache-v1';

self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'PREFETCH_ASSETS') {
    const urlsToCache = event.data.urls;
    event.waitUntil(
      caches.open(CACHE_NAME).then((cache) => {
        return Promise.all(
          urlsToCache.map(url => {
            return cache.match(url).then(response => {
              if (!response) {
                // Fetch and put in cache
                return fetch(url, { mode: 'cors' })
                  .then(res => {
                    if (res.ok) {
                      cache.put(url, res.clone());
                    }
                  })
                  .catch(err => console.warn('Failed to prefetch asset in SW:', url, err));
              }
            });
          })
        );
      })
    );
  }
});

self.addEventListener('fetch', (event) => {
  const requestUrl = event.request.url;
  // Intercept requests for models and wasm files
  if (
    requestUrl.includes('.wasm') || 
    requestUrl.includes('.onnx') || 
    requestUrl.includes('static.imgly.com') ||
    requestUrl.includes('cdn.jsdelivr.net') ||
    requestUrl.includes('upscalerjs')
  ) {
    event.respondWith(
      caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          return response || fetch(event.request).then((networkResponse) => {
            if (networkResponse.ok) {
              cache.put(event.request, networkResponse.clone());
            }
            return networkResponse;
          });
        });
      })
    );
  }
});
