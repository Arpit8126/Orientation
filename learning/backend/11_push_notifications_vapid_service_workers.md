# Backend Chapter 11: Push Notification Pipeline & VAPID Protocol

This module covers the systems architecture of Pookiz's WebPush notification pipeline, detailing subscription handshakes, VAPID payload encryption, browser push gateways, and service worker triggers.

---

## 1. Objective & Placement Value
- **Why this is asked:** Push notifications are essential for mobile browser engagement. Technical interviewers evaluate your understanding of public key cryptography in VAPID, dynamic subscription storage, peer-to-peer payload encryption (using AES-128-GCM), and handling device endpoint expiration codes.
- **Placement Value:** Prepares you to design battery-efficient, reliable push notification infrastructures that support multi-device delivery.

---

## 2. The Layman's Analogy
Think of the push notification system as a **secure student mailbox and courier service**:
- **The Subscription Registry (subscribe endpoint):** When you buy a new device, your browser generates a custom lockbox coordinate (**the endpoint URL**) and a keycard (**the encryption keys**). You hand these coordinates to the Pookiz central office, which stores them.
- **The VAPID Signature (The Dean's Stamp):** When Pookiz wants to send a notification to your device, it writes the message, encrypts it using your keycard, and signs the parcel with the school's official master seal (**the private VAPID key**).
- **The Gateway (Google/Apple Server):** Pookiz hands this sealed parcel to the Google/Apple courier. The courier checks the seal's authenticity using the public key. If verified, they deliver it to your device's background receiver (Service Worker), which wakes up your screen.

---

## 3. The Technical Specification

### A. WebPush Payload Encryption Mechanics
To ensure user privacy, the notification payload is encrypted peer-to-peer before leaving the application server, preventing the push service provider (FCM/APNS) from reading the message content:
1. **Client Subscription:** The browser registers with the VAPID public key and generates a `PushSubscription` JSON:
   - `endpoint`: Target gateway URL (e.g., `https://fcm.googleapis.com/fcm/send/...`).
   - `keys.p256dh`: P-256 Elliptic Curve public key for Diffie-Hellman key exchange.
   - `keys.auth`: Shared secret auth token.
2. **Server Encryption:** The server uses the WebPush library to perform ECDH (Elliptic Curve Diffie-Hellman) key exchange, deriving a symmetric session key.
3. **Payload Cryptography:** The server encrypts the JSON notification body using **AES-128-GCM** encryption and POSTs the encrypted bytes to the subscription endpoint, signed with the server's VAPID private key.

### B. Duplicate Subscription Cleanup Logic
Users log in from multiple devices, and browsers can regenerate subscriptions, leading to duplicate entries. In `subscribe/route.ts`, Pookiz handles this:
- Prior to inserting a new subscription, the server queries existing subscriptions matching `user_id`.
- It checks if any stored subscription matches the incoming `subscription.endpoint`. If a match is found, the server deletes the duplicate row before inserting the new record, preventing duplicate notifications.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the push subscription endpoint: [`d:\Pookiz\pookiz-app\src\app\api\push\subscribe\route.ts`](file:///d:/Pookiz/pookiz-app/src/app/api/push/subscribe/route.ts)

```typescript
export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user }, error: authError } = await supabase.auth.getUser()

  if (authError || !user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }
```
- **Line 5-10:** Exports the POST handler. Initializes the Supabase client and verifies the current user session, returning status `401` if unauthorized.

```typescript
  try {
    const { subscription } = await request.json()
    if (!subscription) {
      return NextResponse.json({ error: 'Subscription required' }, { status: 400 })
    }

    const admin = createAdminClient() as any
```
- **Line 17-20:** Parses the JSON request body, extracts the client's `subscription` object, and verifies it is present.
- **Line 22:** Initializes the privileged Supabase client (`createAdminClient()`) to bypass RLS policies during subscription cleanup.

```typescript
    // Fetch all user's subscriptions and find if any has the same endpoint, to avoid unique constraint violations
    const { data: existingSubs } = await admin
      .from('push_subscriptions')
      .select('id, subscription')
      .eq('user_id', user.id)

    if (existingSubs && existingSubs.length > 0) {
      const match = existingSubs.find((subRow: any) => subRow.subscription?.endpoint === subscription.endpoint)
      if (match) {
        await admin
          .from('push_subscriptions')
          .delete()
          .eq('id', match.id)
      }
    }
```
- **Line 25-29:** Queries the `push_subscriptions` table to retrieve all active registrations for the current user.
- **Line 30-32:** Iterates through the stored list to check if any entry shares the same `endpoint` URL as the new registration.
- **Line 33-37:** If a duplicate endpoint exists, deletes the old row to clean up the database.

```typescript
    // Insert the subscription
    const { error: insertError } = await admin
      .from('push_subscriptions')
      .insert({
        user_id: user.id,
        subscription,
      })

    if (insertError) throw insertError

    return NextResponse.json({ success: true })
  } catch (err: any) { ... }
}
```
- **Line 41-46:** Inserts the verified, deduplicated subscription payload into the database, linking it to the user's ID.
- **Line 48-50:** Handles insert errors and returns an HTTP `200` success response.

---

## 5. Edge Cases & Optimizations
- **Browser Cleared Cache (Orphaned Keys):** When a user clears their browser cache or uninstalls the site shortcut, their subscription key is deleted on the client, but remains in our database.
  - *Fix:* During push dispatch, if the push service returns status `404` or `410`, throw `SUB_EXPIRED` and delete the invalid subscription from PostgreSQL immediately.
- **Payload Size Limits:** WebPush payloads are limited to a maximum of **4078 bytes** (4KB).
  - *Fix:* Ensure notification JSON payloads (containing title, body, and URL) are kept small. Avoid sending large media file binaries in the push data.

---

## 6. Staff Engineer Viva Board

### Q1: Why must the push subscription payload be encrypted peer-to-peer, and how does the browser decrypt it?
**Answer:**
*"WebPush payloads are routed through external browser push gateways (such as Google FCM for Chrome or Apple APNS for Safari). If the data was sent in plain text, these providers could read, store, or manipulate user notifications.

To prevent this, the data is encrypted peer-to-peer using **AES-128-GCM** encryption. The browser client generates a public key (`p256dh`) and a shared auth secret (`auth`) and sends them during subscription. The application server uses these keys to encrypt the notification payload. 

When the gateway delivers the encrypted packet, it wakes up the browser's background **Service Worker**. The service worker retrieves the matching private key from the browser's secure key store, decrypts the payload in memory, and calls `showNotification()` to display the alert, keeping the notification data private."*

### Q2: Why is it necessary to deduplicate endpoints inside the `subscribe` API handler?
**Answer:**
*"If a user refreshes the page or installs the PWA on the same browser multiple times, the browser may request a new push subscription. 

If we inserted every new subscription directly without checking:
1. The database would accumulate multiple rows with identical or slightly different endpoint configurations for the same device.
2. When a notification triggers, the server would send duplicate push requests to the same device, causing the user to receive multiple identical alerts.
Checking and deleting matching endpoints before inserting new registrations prevents duplicate alerts and saves server resource usage."*

### Q3: What is the purpose of the `vapid-public-key` API endpoint, and why can't we hardcode the key in the client application?
**Answer:**
*"The `vapid-public-key` endpoint allows the client to retrieve the active VAPID public key from the server dynamically. 

We avoid hardcoding this key because:
1. **Key Rotation:** If a key is compromised or needs rotation, we can update it on the server without rebuilding and redeploying the client frontend.
2. **Dynamic Key Generation:** During local development, the server generates dynamic VAPID keys if environment variables are missing. Querying this endpoint ensures the local client always registers with the correct key."*

### Q4: Explain the difference between `webPush.sendNotification()` and standard WebSocket messages.
**Answer:**
*"- **WebSocket messages:** Run over a persistent, open TCP connection. They are extremely fast and low-latency, but they require the browser tab to be open and active. If the tab is closed or the phone is asleep, the connection is lost.
- **WebPush notifications:** Do not require the tab to be open. The application server sends the message to the browser's push gateway (FCM/APNS), which routes the message to the device. The device's operating system wakes up the browser's background service worker to display the notification, making it ideal for offline alerts."*

### Q5: How does the Service Worker handle click events on notifications? Walk me through the code logic.
**Answer:**
*"Inside the service worker script, we bind an event handler to the `notificationclick` event:
```javascript
self.addEventListener('notificationclick', (event) => {
  event.notification.close(); // Closes the notification window
  const targetUrl = event.notification.data.url;

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((windowClients) => {
      // Check if there is already a matching tab open
      for (const client of windowClients) {
        if (client.url === targetUrl && 'focus' in client) {
          return client.focus();
        }
      }
      // If no tab is open, open a new window
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});
```
This intercepts the click event, closes the system notification bubble, checks if the application is already open in another tab, and redirects or focuses the user on the target deep-link URL."*
