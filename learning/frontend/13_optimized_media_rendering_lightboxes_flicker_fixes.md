# Frontend Chapter 13: Media Rendering, Skeletons & Lightbox Overlays

This module covers the client-side design of the media rendering engine in Pookiz, detailing React Portals, keyboard-controlled image lightboxes, layout constraints, and skeleton loaders.

---

## 1. Objective & Placement Value
- **Why this is asked:** High-performance media elements require advanced DOM rendering. Technical interviewers evaluate your understanding of **React Portals** (mounting overlays at the document body to bypass layout bounds), loading placeholder skeletons (preventing CLS), dynamic aspect-ratio layouts, and binding keyboard listeners to modal states.
- **Placement Value:** Prepares you to design responsive media widgets, build clean overlays, and write accessible, flicker-free image preview grids.

---

## 2. The Layman's Analogy
Think of the image zoom lightbox as a **projector slide overlay inside a library**:
- **Standard Image Grid (Desk Photos):** You display small printed photos on a desk. The desk borders restrict the photos.
- **React Portal (The Master Projector):** When you click a photo to zoom in, instead of trying to stretch the photo on the small desk, you project it onto a massive screen hung from the library ceiling (**the document body**). This screen covers everything else and has no borders.
- **Keyboard navigation (The remote control):** You sit back with a remote control, pressing the left/right arrow buttons to change slides, and the escape button to shut down the projector, keeping controls fast and intuitive.

---

## 3. The Technical Specification

### A. React Portals for UI Overlays
Normally, a React component mounts inside its parent element's DOM structure. 
- *The Issue:* If a parent element has `overflow: hidden` or absolute positioning bounds, child elements that are larger than the parent (like a screen-spanning modal overlay) will be cropped or misaligned.
- *The Solution:* We use **React Portals** (`createPortal`) to detach the modal component from its parent DOM structure, mounting it directly under the `document.body` while preserving React state and lifecycle:
  ```typescript
  createPortal(<LightboxModal />, document.body)
  ```

### B. Keyboard Event Handlers for Lightbox Navigation
To support keyboard navigation inside zoom overlays, the client registers event listeners on `window` when the lightbox is active:
- `Escape`: Sets `isLightboxOpen = false` to close the modal.
- `ArrowLeft`: Decrements `lightboxIndex` to show the previous image.
- `ArrowRight`: Increments `lightboxIndex` to show the next image.
These event listeners must be removed when the lightbox is closed to prevent memory leaks and handle normal keyboard interactions.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the portal-based lightbox and keyboard handlers in [`d:\Pookiz\pookiz-app\src\components\chat\MessageBubble.tsx`](file:///d:/Pookiz/pookiz-app/src/components/chat/MessageBubble.tsx):

```typescript
  const [isLightboxOpen, setIsLightboxOpen] = useState(false);
  const [lightboxIndex, setLightboxIndex] = useState(0);
```
- **Line 509-510:** Initializes the modal toggler state and the current active image index pointer.

```typescript
  useEffect(() => {
    if (!isLightboxOpen) return;

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        setIsLightboxOpen(false);
      } else if (e.key === 'ArrowLeft') {
        setLightboxIndex((prev) => (prev > 0 ? prev - 1 : prev));
      } else if (e.key === 'ArrowRight') {
        setLightboxIndex((prev) => (prev < mediaUrls.length - 1 ? prev + 1 : prev));
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [isLightboxOpen, mediaUrls.length]);
```
- **Line 1110:** Runs the effect only when the lightbox is open.
- **Line 1112-1118:** Intercepts keys. Updates `lightboxIndex` or closes the modal based on key inputs.
- **Line 1120-1123:** Attaches the window event listener on open, and returns a cleanup function to unregister the listener on close.

```typescript
      {isLightboxOpen && mediaUrls.length > 0 && mounted && createPortal(
        <div 
          className="fixed inset-0 z-[9999] bg-black/95 flex flex-col justify-between p-4 animate-fade-in print:hidden"
          onClick={() => setIsLightboxOpen(false)}
        >
          {/* Header Controls */}
          {/* ... */}
          
          <img 
            src={mediaUrls[lightboxIndex]} 
            alt="Zoomed attachment" 
            className="max-w-full max-h-[80vh] object-contain mx-auto select-none rounded-sm"
            onClick={(e) => e.stopPropagation()} 
          />

          {/* Navigation Arrows */}
          {/* ... */}
        </div>,
        document.body
      )}
```
- **Line 2138:** If open, uses `createPortal` to mount the overlay div directly under the `document.body` node.
- **Line 2139:** Applies a high z-index (`z-[9999]`) to ensure the overlay displays on top of all other elements.
- **Line 2217-2220:** Renders the active image based on `lightboxIndex`. Uses `e.stopPropagation()` to prevent clicks on the image itself from triggering the overlay's click listener and closing the modal.

---

## 5. Edge Cases & Optimizations
- **Browser Scrollbar Jitter:** When the lightbox modal opens, the body scrollbar is often hidden (`overflow: hidden`), which causes the page layout to shift slightly to the right to fill the space.
  - *Fix:* Measure the scrollbar width and apply it as a dynamic padding-right to the body when opening the modal, keeping the layout stable.
- **Image Flicker on Index Switch:** Switching between images inside the lightbox can cause a visual flicker as the browser downloads the new image.
  - *Fix:* Preload adjacent images in the background using invisible `img` links in the DOM to ensure they are cached.

---

## 6. Staff Engineer Viva Board

### Q1: What is a React Portal, and why is it critical for rendering modals, tooltips, and lightboxes?
**Answer:**
*"A **React Portal** (`createPortal`) allows you to render a component's DOM node into a different part of the DOM tree (typically as a direct child of the `document.body`), while preserving its position in the React parent-child component tree.

This is critical because:
1. **Layout Scope:** If a parent component has `overflow: hidden`, `z-index: 1`, or `position: relative`, any child overlay (like a screen-spanning lightbox) will be cropped or covered by adjacent layouts.
2. **Event Bubbling:** Although the DOM node mounts under `document.body`, standard React events (like click bubbles) continue to propagate through the React component tree, allowing parent components to capture events normally."*

### Q2: Why is `e.stopPropagation()` placed on the main `<img>` element inside our lightbox overlay?
**Answer:**
*"The background overlay has a click listener that calls `setIsLightboxOpen(false)` to close the modal when the user clicks the dark background. 

Because events bubble up from child elements, clicking the image itself would trigger the click handler on the image, bubble up to the overlay, and close the modal. 

Adding `e.stopPropagation()` to the `<img>` tag blocks the click event from bubbling up, ensuring the modal remains open when the user clicks or zooms in on the image."*

### Q3: What is Cumulative Layout Shift (CLS), and how do image loading skeletons prevent it?
**Answer:**
*"**Cumulative Layout Shift (CLS)** measures how much visible elements shift on the screen as assets load. For example, if an image loads without dimensions, the text below it shifts down once the image completes loading, creating a bad user experience.

Image loading skeletons prevent this by rendering a placeholder box with fixed dimensions (matching the image's final aspect ratio) before the image loads. This reserves space in the layout, keeping positions stable as the image downloads."*

### Q4: How do you handle cleaning up keyboard event listeners to prevent memory leaks?
**Answer:**
*"We handle cleanup by returning a cleanup function from our `useEffect` hook:
```typescript
useEffect(() => {
  window.addEventListener('keydown', handleKeyDown);
  return () => {
    window.removeEventListener('keydown', handleKeyDown);
  };
}, [isLightboxOpen]);
```
When the component unmounts or `isLightboxOpen` changes, React executes the cleanup function, removing the listener from the `window` object. This prevents memory leaks and ensures keys function normally in other areas."*

### Q5: What is the advantage of using `object-contain` over `object-cover` inside the lightbox `<img>` tag?
**Answer:**
*"- **`object-cover`:** Stretches and crops the image to fill the container, which works well for profile banners but cuts off image details in zoom views.
- **`object-contain`:** Scales the image to fit the container while preserving its original aspect ratio and keeping the entire image visible without cropping. This is the correct choice for zoom views where users need to see the full image details."*
