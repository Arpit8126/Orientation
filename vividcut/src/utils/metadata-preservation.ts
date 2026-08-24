import * as piexif from 'piexifjs';

/**
 * Extracts EXIF data from an original image File and inserts it into a new canvas-generated base64 image string.
 * Returns the modified base64 data URL.
 */
export function preserveExif(originalFile: File, canvasDataUrl: string): Promise<string> {
  return new Promise((resolve) => {
    // Only attempt EXIF injection for JPEG/JPG formats
    if (!originalFile.type.match(/image\/jpe?g/i)) {
      resolve(canvasDataUrl);
      return;
    }

    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        const originalBase64 = e.target?.result as string;
        if (!originalBase64) {
          resolve(canvasDataUrl);
          return;
        }

        // Load the EXIF object from the original JPEG base64 string
        const exifObj = piexif.load(originalBase64);

        // Dump the EXIF object back to a binary string format
        const exifBytes = piexif.dump(exifObj);

        // Insert the binary EXIF data into the canvas-generated JPEG data URL
        const modifiedDataUrl = piexif.insert(exifBytes, canvasDataUrl);
        resolve(modifiedDataUrl);
      } catch (err) {
        console.warn('Failed to copy EXIF metadata (file may not have valid EXIF tags):', err);
        resolve(canvasDataUrl); // Fallback to normal canvas data URL on failure
      }
    };
    reader.onerror = () => {
      resolve(canvasDataUrl);
    };
    reader.readAsDataURL(originalFile);
  });
}

/**
 * Converts a base64/data URL to a Blob object.
 */
export function dataUrlToBlob(dataUrl: string): Blob {
  const arr = dataUrl.split(',');
  const mime = arr[0].match(/:(.*?);/)?.[1] || 'image/png';
  const bstr = atob(arr[1]);
  let n = bstr.length;
  const u8arr = new Uint8Array(n);
  while (n--) {
    u8arr[n] = bstr.charCodeAt(n);
  }
  return new Blob([u8arr], { type: mime });
}

/**
 * Trims transparent pixels from the outer borders of a canvas.
 * Returns a new cropped canvas.
 */
export function trimCanvasTransparency(canvas: HTMLCanvasElement): HTMLCanvasElement {
  const ctx = canvas.getContext('2d');
  if (!ctx) return canvas;

  const width = canvas.width;
  const height = canvas.height;
  const imgData = ctx.getImageData(0, 0, width, height);
  const data = imgData.data;

  let minX = width;
  let minY = height;
  let maxX = 0;
  let maxY = 0;
  let found = false;

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const index = (y * width + x) * 4;
      const alpha = data[index + 3];
      if (alpha > 5) { // alpha threshold
        found = true;
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }

  if (!found) {
    return canvas; // return original if empty/fully transparent
  }

  const croppedWidth = maxX - minX + 1;
  const croppedHeight = maxY - minY + 1;

  const croppedCanvas = document.createElement('canvas');
  croppedCanvas.width = croppedWidth;
  croppedCanvas.height = croppedHeight;
  const croppedCtx = croppedCanvas.getContext('2d');

  if (croppedCtx) {
    croppedCtx.drawImage(canvas, minX, minY, croppedWidth, croppedHeight, 0, 0, croppedWidth, croppedHeight);
  }

  return croppedCanvas;
}

