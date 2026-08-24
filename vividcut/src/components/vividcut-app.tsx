'use client';

import React, { useState, useEffect, useRef } from 'react';
import { usePathname } from 'next/navigation';
import { 
  X, 
  Upload, 
  Image as ImageIcon, 
  Copy, 
  Download, 
  Sparkles, 
  Settings, 
  Layers, 
  Plus,
  RefreshCw,
  Info,
  ShieldCheck
} from 'lucide-react';
import { BeforeAfterSlider } from './before-after-slider';
import { preserveExif, dataUrlToBlob, trimCanvasTransparency } from '@/utils/metadata-preservation';

interface BatchImage {
  id: string;
  file: File;
  name: string;
  description: string;
  status: 'queued' | 'loading-model' | 'removing-bg' | 'upscaling' | 'rendering' | 'completed' | 'failed';
  progress: number; // 0 to 100
  progressMessage: string;
  originalUrl: string;
  resultUrl?: string;
  resultBlob?: Blob;
  width?: number;
  height?: number;
  timeLeft?: string;
}

interface VividCutAppProps {
  initialTool?: 'bg-remover' | 'upscaler';
  prefilledBgColor?: string;
  exportFormat?: 'png' | 'webp' | 'jpeg';
  passportPreset?: boolean;
}

export function VividCutApp({
  initialTool = 'bg-remover',
  prefilledBgColor = 'transparent',
  exportFormat = 'png',
  passportPreset = false
}: VividCutAppProps) {
  const pathname = usePathname();
  // Navigation Tabs
  const [activeTab, setActiveTab] = useState<'new' | 'existing'>('new');
  
  // Workspace Config
  const [activeTool, setActiveTool] = useState<'bg-remover' | 'upscaler'>(initialTool);
  const [bgColor, setBgColor] = useState<string>(prefilledBgColor);
  const [customBgColor, setCustomBgColor] = useState<string>('#6D57EC');
  const [shadowBlur, setShadowBlur] = useState<number>(0);
  const [shadowOffset, setShadowOffset] = useState<number>(0);
  const [upscaleToggle, setUpscaleToggle] = useState<boolean>(initialTool === 'upscaler');
  const [targetFormat, setTargetFormat] = useState<'png' | 'webp' | 'jpeg'>(exportFormat);
  
  // Batch Queue State
  const [batchQueue, setBatchQueue] = useState<BatchImage[]>([]);
  const [isProcessing, setIsProcessing] = useState<boolean>(false);
  const [selectedQueueId, setSelectedQueueId] = useState<string | null>(null);

  // Crop & Trim Configurations
  const [enableCrop, setEnableCrop] = useState<boolean>(false);
  const [autoTrim, setAutoTrim] = useState<boolean>(false);
  const [cropLeft, setCropLeft] = useState<number>(0);
  const [cropRight, setCropRight] = useState<number>(0);
  const [cropTop, setCropTop] = useState<number>(0);
  const [cropBottom, setCropBottom] = useState<number>(0);
  const [cropAspectRatio, setCropAspectRatio] = useState<string>('free');

  // Ref hooks
  const fileInputRef = useRef<HTMLInputElement>(null);
  const cropWrapperRef = useRef<HTMLDivElement>(null);
  const isProcessingRef = useRef(false);

  // Drag and Magnifier hover states
  const [activeDragHandle, setActiveDragHandle] = useState<string | null>(null);
  const [magnifierPos, setMagnifierPos] = useState({ x: 0, y: 0, show: false });
  const [magnifierBgPos, setMagnifierBgPos] = useState('50% 50%');

  // Sync state with props when landing pages change
  useEffect(() => {
    setActiveTool(initialTool);
    setBgColor(prefilledBgColor);
    setTargetFormat(exportFormat);
    setUpscaleToggle(initialTool === 'upscaler');
    
    if (passportPreset) {
      setEnableCrop(true);
      setCropAspectRatio('passport');
      setCropLeft(15);
      setCropRight(15);
      setCropTop(10);
      setCropBottom(15);
      setBgColor('#ffffff');
    } else {
      setEnableCrop(false);
      setCropAspectRatio('free');
      setCropLeft(0);
      setCropRight(0);
      setCropTop(0);
      setCropBottom(0);
    }
  }, [initialTool, prefilledBgColor, exportFormat, passportPreset]);

  // Centering crop calculation based on aspect ratio constraints
  const adjustCropForAspectRatio = (ratio: string, width: number, height: number) => {
    if (ratio === 'free' || !width || !height) return;
    let r = 1.0;
    if (ratio === '1:1') r = 1.0;
    else if (ratio === 'passport') r = 3.5 / 4.5;
    else if (ratio === '4:5') r = 0.8;
    else if (ratio === '16:9') r = 16 / 9;

    const currentAspect = width / height;
    if (currentAspect > r) {
      // Wider: crop left/right
      const targetWidth = height * r;
      const marginPercent = ((width - targetWidth) / (2 * width)) * 100;
      setCropLeft(Math.round(marginPercent));
      setCropRight(Math.round(marginPercent));
      setCropTop(0);
      setCropBottom(0);
    } else {
      // Taller: crop top/bottom
      const targetHeight = width / r;
      const marginPercent = ((height - targetHeight) / (2 * height)) * 100;
      setCropTop(Math.round(marginPercent));
      setCropBottom(Math.round(marginPercent));
      setCropLeft(0);
      setCropRight(0);
    }
  };

  const activeSelectedItem = batchQueue.find(item => item.id === selectedQueueId) || batchQueue[0];

  // Crop drag coordination calculation
  const handleCropDrag = (clientX: number, clientY: number) => {
    if (!activeDragHandle || !cropWrapperRef.current) return;
    const rect = cropWrapperRef.current.getBoundingClientRect();
    
    // Relative coordinates as percentages (0 to 100)
    let px = ((clientX - rect.left) / rect.width) * 100;
    let py = ((clientY - rect.top) / rect.height) * 100;
    
    px = Math.max(0, Math.min(100, px));
    py = Math.max(0, Math.min(100, py));
    
    if (activeDragHandle === 'top-left') {
      const newLeft = Math.round(px);
      const newTop = Math.round(py);
      if (newLeft + cropRight < 95) setCropLeft(newLeft);
      if (newTop + cropBottom < 95) setCropTop(newTop);
    } else if (activeDragHandle === 'top-right') {
      const newRight = Math.round(100 - px);
      const newTop = Math.round(py);
      if (newRight + cropLeft < 95) setCropRight(newRight);
      if (newTop + cropBottom < 95) setCropTop(newTop);
    } else if (activeDragHandle === 'bottom-left') {
      const newLeft = Math.round(px);
      const newBottom = Math.round(100 - py);
      if (newLeft + cropRight < 95) setCropLeft(newLeft);
      if (newBottom + cropTop < 95) setCropBottom(newBottom);
    } else if (activeDragHandle === 'bottom-right') {
      const newRight = Math.round(100 - px);
      const newBottom = Math.round(100 - py);
      if (newRight + cropLeft < 95) setCropRight(newRight);
      if (newBottom + cropTop < 95) setCropBottom(newBottom);
    }
  };

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      handleCropDrag(e.clientX, e.clientY);
    };
    const handleTouchMove = (e: TouchEvent) => {
      if (e.touches.length > 0) {
        handleCropDrag(e.touches[0].clientX, e.touches[0].clientY);
      }
    };
    const handleMouseUp = () => {
      setActiveDragHandle(null);
    };
    
    if (activeDragHandle) {
      window.addEventListener('mousemove', handleMouseMove);
      window.addEventListener('mouseup', handleMouseUp);
      window.addEventListener('touchmove', handleTouchMove, { passive: true });
      window.addEventListener('touchend', handleMouseUp);
    }
    
    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
      window.removeEventListener('mouseup', handleMouseUp);
      window.removeEventListener('touchmove', handleTouchMove);
      window.removeEventListener('touchend', handleMouseUp);
    };
  }, [activeDragHandle, cropLeft, cropRight, cropTop, cropBottom]);

  const handleMagnifierMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    
    const px = (x / rect.width) * 100;
    const py = (y / rect.height) * 100;
    
    setMagnifierPos({ x, y, show: true });
    setMagnifierBgPos(`${px}% ${py}%`);
  };

  const handleMagnifierMouseLeave = () => {
    setMagnifierPos(prev => ({ ...prev, show: false }));
  };

  // Service worker model asset preloading
  useEffect(() => {
    if (typeof window !== 'undefined' && 'serviceWorker' in navigator) {
      const urls = [
        'https://static.imgly.com/packages/@imgly/background-removal-js/1.7.0/assets/wasms/ort-wasm-simd.wasm',
        'https://static.imgly.com/packages/@imgly/background-removal-js/1.7.0/assets/wasms/ort-wasm-simd-threaded.wasm',
        'https://static.imgly.com/packages/@imgly/background-removal-js/1.7.0/assets/models/isnet_quint8.onnx',
        'https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-wasm@4.22.0/dist/tfjs-backend-wasm.wasm',
        'https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-wasm@4.22.0/dist/tfjs-backend-wasm-simd.wasm',
        'https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-wasm@4.22.0/dist/tfjs-backend-wasm-threaded.wasm'
      ];
      
      const triggerPrefetch = () => {
        if (navigator.serviceWorker.controller) {
          navigator.serviceWorker.controller.postMessage({
            type: 'PREFETCH_ASSETS',
            urls
          });
        }
      };

      navigator.serviceWorker.ready.then(() => {
        if ('requestIdleCallback' in window) {
          window.requestIdleCallback(triggerPrefetch);
        } else {
          setTimeout(triggerPrefetch, 2500);
        }
      });
    }
  }, []);

  // Update crop aspect ratio margins automatically when ratio or item selection changes
  useEffect(() => {
    if (activeSelectedItem && activeSelectedItem.width && activeSelectedItem.height && cropAspectRatio !== 'free' && enableCrop) {
      adjustCropForAspectRatio(cropAspectRatio, activeSelectedItem.width, activeSelectedItem.height);
    }
  }, [cropAspectRatio, enableCrop, selectedQueueId, activeSelectedItem?.width, activeSelectedItem?.height]);

  // Handle Drag & Drop
  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
      addFilesToQueue(Array.from(e.dataTransfer.files));
    }
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      addFilesToQueue(Array.from(e.target.files));
    }
  };

  const addFilesToQueue = (files: File[]) => {
    const imageFiles = files.filter(f => f.type.startsWith('image/')).slice(0, 5);
    if (imageFiles.length === 0) return;

    const newItems: BatchImage[] = imageFiles.map((file, index) => {
      const remainingSeconds = 5 + index * 4;
      return {
        id: Math.random().toString(36).substring(7),
        file,
        name: file.name.split('.')[0],
        description: `Client-side processing of ${file.name}`,
        status: 'queued',
        progress: 0,
        progressMessage: 'Queued...',
        originalUrl: URL.createObjectURL(file),
        timeLeft: `${remainingSeconds} sec left`
      };
    });

    setBatchQueue(prev => {
      const updated = [...prev, ...newItems].slice(0, 5);
      if (updated.length > 0 && !selectedQueueId) {
        setSelectedQueueId(updated[0].id);
      }
      return updated;
    });
  };

  // Trigger processing sequence
  const startProcessing = () => {
    if (batchQueue.length === 0 || isProcessing) return;
    setIsProcessing(true);
    isProcessingRef.current = true;
  };

  // Sequence processor effect
  useEffect(() => {
    if (!isProcessing) return;

    const processNext = async () => {
      const nextIndex = batchQueue.findIndex(item => item.status === 'queued');
      if (nextIndex === -1) {
        setIsProcessing(false);
        isProcessingRef.current = false;
        
        try {
          const confetti = (await import('canvas-confetti')).default;
          confetti({
            particleCount: 80,
            spread: 60,
            origin: { y: 0.8 },
            colors: ['#6D57EC', '#8B78FF', '#FFFFFF']
          });
        } catch (e) {
          console.warn(e);
        }
        return;
      }

      const activeItem = batchQueue[nextIndex];
      
      try {
        await processSingleImage(activeItem.id);
      } catch (err) {
        console.error('Failed to process image: ', activeItem.id, err);
        updateQueueItem(activeItem.id, { 
          status: 'failed', 
          progressMessage: 'Processing Error',
          progress: 0 
        });
      }
    };

    processNext();
  }, [isProcessing, batchQueue]);

  const updateQueueItem = (id: string, updates: Partial<BatchImage>) => {
    setBatchQueue(prev => prev.map(item => item.id === id ? { ...item, ...updates } : item));
  };

  const processSingleImage = async (id: string) => {
    const item = batchQueue.find(x => x.id === id);
    if (!item) return;

    let currentBlob: File | Blob = item.file;
    let currentUrl = item.originalUrl;

    if (activeTool === 'bg-remover') {
      updateQueueItem(id, { 
        status: 'loading-model', 
        progress: 15, 
        progressMessage: 'Initializing AI Models...' 
      });

      const imgly = await import('@imgly/background-removal');
      
      updateQueueItem(id, { 
        status: 'removing-bg', 
        progress: 25, 
        progressMessage: 'Downloading AI Weights...' 
      });

      const imglyConfig = {
        progress: (key: string, current: number, total: number) => {
          const percent = Math.round((current / total) * 45);
          let message = 'Downloading Model Assets...';
          if (key.includes('wasm')) message = 'Initializing Compute Shaders...';
          else if (key.includes('model')) message = `Downloading AI Weights (${Math.round(current / 1024 / 1024)}MB / ${Math.round(total / 1024 / 1024)}MB)...`;
          updateQueueItem(id, { progress: 25 + percent, progressMessage: message });
        },
        model: 'isnet_quint8' as const,
      };

      try {
        const transparentBlob = await imgly.removeBackground(currentBlob, imglyConfig);
        currentBlob = transparentBlob as File;
        currentUrl = URL.createObjectURL(transparentBlob);
      } catch (err) {
        console.error('Local background removal failed:', err);
      }
    }

    if (autoTrim && activeTool === 'bg-remover') {
      updateQueueItem(id, { status: 'rendering', progress: 72, progressMessage: 'Auto-trimming transparent bounds...' });
      const tempImg = new Image();
      tempImg.src = currentUrl;
      await new Promise((resolve) => { tempImg.onload = resolve; tempImg.onerror = resolve; });
      const tempCanvas = document.createElement('canvas');
      tempCanvas.width = tempImg.naturalWidth || tempImg.width;
      tempCanvas.height = tempImg.naturalHeight || tempImg.height;
      const tempCtx = tempCanvas.getContext('2d');
      if (tempCtx) {
        tempCtx.drawImage(tempImg, 0, 0);
        const trimmedCanvas = trimCanvasTransparency(tempCanvas);
        currentUrl = trimmedCanvas.toDataURL('image/png');
        currentBlob = dataUrlToBlob(currentUrl);
      }
    }

    if (enableCrop) {
      updateQueueItem(id, { status: 'rendering', progress: 75, progressMessage: 'Applying crop margins...' });
      const tempImg = new Image();
      tempImg.src = currentUrl;
      await new Promise((resolve) => { tempImg.onload = resolve; tempImg.onerror = resolve; });
      const nativeWidth = tempImg.naturalWidth || tempImg.width;
      const nativeHeight = tempImg.naturalHeight || tempImg.height;
      const x = Math.round((cropLeft / 100) * nativeWidth);
      const y = Math.round((cropTop / 100) * nativeHeight);
      const w = Math.max(1, Math.round((1 - (cropLeft + cropRight) / 100) * nativeWidth));
      const h = Math.max(1, Math.round((1 - (cropTop + cropBottom) / 100) * nativeHeight));
      const tempCanvas = document.createElement('canvas');
      tempCanvas.width = w;
      tempCanvas.height = h;
      const tempCtx = tempCanvas.getContext('2d');
      if (tempCtx) {
        tempCtx.drawImage(tempImg, x, y, w, h, 0, 0, w, h);
        currentUrl = tempCanvas.toDataURL('image/png');
        currentBlob = dataUrlToBlob(currentUrl);
      }
    }

    if (upscaleToggle) {
      updateQueueItem(id, { status: 'loading-model', progress: 80, progressMessage: 'Loading Super-Resolution Weights...' });
      const tf = await import('@tensorflow/tfjs');
      await import('@tensorflow/tfjs-backend-webgpu');
      const tfWasm = await import('@tensorflow/tfjs-backend-wasm');
      tfWasm.setWasmPaths('https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-wasm/dist/');
      let backend = 'cpu';
      try {
        if ('gpu' in navigator) { await tf.setBackend('webgpu'); await tf.ready(); backend = 'webgpu'; }
        else { throw new Error('WebGPU not supported'); }
      } catch (gpuErr) {
        try { await tf.setBackend('wasm'); await tf.ready(); backend = 'wasm'; } catch (wasmErr) { await tf.setBackend('webgl'); await tf.ready(); backend = 'webgl'; }
      }
      updateQueueItem(id, { status: 'upscaling', progress: 85, progressMessage: `Running Real-ESRGAN (4x, ${backend.toUpperCase()})...` });
      const UpscalerClass = (await import('upscaler')).default;
      const x4Model = (await import('@upscalerjs/esrgan-slim/4x')).default;
      const upscaler = new UpscalerClass({ model: x4Model });
      try {
        const enhancedBase64 = await upscaler.upscale(currentUrl, {
          progress: (percent) => { updateQueueItem(id, { progress: 85 + Math.round(percent * 13), progressMessage: `Enhancing pixel matrices: ${Math.round(percent * 100)}%` }); }
        });
        currentBlob = dataUrlToBlob(enhancedBase64) as File;
        currentUrl = enhancedBase64;
      } catch (err) { console.error('Super-resolution upscale failed:', err); }
    }

    updateQueueItem(id, { status: 'rendering', progress: 98, progressMessage: 'Preserving EXIF / Finalizing Canvas...' });
    const img = new Image();
    img.src = currentUrl;
    await new Promise((resolve) => { img.onload = resolve; img.onerror = resolve; });
    const nativeWidth = img.naturalWidth || img.width || 800;
    const nativeHeight = img.naturalHeight || img.height || 600;
    const canvas = document.createElement('canvas');
    canvas.width = nativeWidth; canvas.height = nativeHeight;
    const ctx = canvas.getContext('2d');
    if (ctx) {
      const isTransparent = bgColor === 'transparent' || activeTool !== 'bg-remover';
      if (!isTransparent) { ctx.fillStyle = bgColor === 'custom' ? customBgColor : bgColor; ctx.fillRect(0, 0, nativeWidth, nativeHeight); }
      if (shadowBlur > 0 && activeTool === 'bg-remover') {
        ctx.shadowColor = 'rgba(0, 0, 0, 0.4)';
        const scaleFactor = Math.min(nativeWidth, nativeHeight) / 500;
        ctx.shadowBlur = shadowBlur * scaleFactor;
        ctx.shadowOffsetX = shadowOffset * scaleFactor;
        ctx.shadowOffsetY = shadowOffset * scaleFactor;
      }
      ctx.drawImage(img, 0, 0, nativeWidth, nativeHeight);
    }
    const mimeType = targetFormat === 'jpeg' ? 'image/jpeg' : targetFormat === 'webp' ? 'image/webp' : 'image/png';
    const canvasDataUrl = canvas.toDataURL(mimeType, targetFormat === 'png' ? undefined : 0.95);
    let finalDataUrl = canvasDataUrl;
    if (targetFormat === 'jpeg') finalDataUrl = await preserveExif(item.file, canvasDataUrl);
    const finalBlob = dataUrlToBlob(finalDataUrl);
    const finalBlobUrl = URL.createObjectURL(finalBlob);
    updateQueueItem(id, {
      status: 'completed',
      progress: 100,
      progressMessage: 'Completed Successfully',
      resultUrl: finalBlobUrl,
      resultBlob: finalBlob,
      width: nativeWidth,
      height: nativeHeight,
      timeLeft: undefined
    });
  };

  const copyToClipboard = async (item: BatchImage) => {
    if (!item.resultBlob) return;
    try {
      let pngBlob = item.resultBlob;
      if (item.resultBlob.type !== 'image/png') {
        const img = new Image();
        img.src = item.resultUrl || '';
        await new Promise((resolve) => { img.onload = resolve; });
        const canvas = document.createElement('canvas');
        canvas.width = img.width; canvas.height = img.height;
        canvas.getContext('2d')?.drawImage(img, 0, 0);
        pngBlob = await new Promise(resolve => canvas.toBlob(b => resolve(b || item.resultBlob!), 'image/png')) as Blob;
      }
      await navigator.clipboard.write([ new ClipboardItem({ [pngBlob.type]: pngBlob }) ]);
      alert('Copied to clipboard!');
    } catch (err) { alert('Could not copy image to clipboard.'); }
  };

  const handleDownload = (item: BatchImage) => {
    if (!item.resultUrl) return;
    const link = document.createElement('a');
    const ext = targetFormat === 'jpeg' ? 'jpg' : targetFormat;
    link.download = `${item.name}_vividcut.${ext}`;
    link.href = item.resultUrl;
    link.click();
  };

  const clearQueue = () => {
    batchQueue.forEach(item => {
      if (item.originalUrl) URL.revokeObjectURL(item.originalUrl);
      if (item.resultUrl) URL.revokeObjectURL(item.resultUrl);
    });
    setBatchQueue([]);
    setIsProcessing(false);
    isProcessingRef.current = false;
    setSelectedQueueId(null);
  };

  return (
    <div className="w-full max-w-2xl mx-auto rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E] shadow-xl overflow-hidden transition-all duration-200">
      {/* Visualizer header */}
      <div className="flex items-center justify-between border-b border-zinc-200 dark:border-[#2E2E35] px-6 py-4 bg-zinc-50/50 dark:bg-[#1e1e24]/50">
        <h2 className="text-sm font-bold tracking-tight text-zinc-900 dark:text-white flex items-center gap-2">
          <span className="h-2 w-2 rounded-full bg-[#6D57EC] animate-pulse"></span>
          {activeTool === 'bg-remover' 
            ? (passportPreset ? 'Passport Size Photo Maker' : 'AI Background Remover') 
            : 'AI Image Enhancer'}
        </h2>
        {batchQueue.length > 0 && (
          <button 
            onClick={clearQueue}
            className="rounded-lg p-1.5 text-zinc-400 dark:text-[#9B9BA6] hover:bg-zinc-100 dark:hover:bg-[#2A2A30] hover:text-zinc-950 dark:hover:text-white transition-colors"
          >
            <X className="h-4 w-4" />
          </button>
        )}
      </div>

      <div className="p-6 flex flex-col gap-6">
        {batchQueue.length === 0 ? (
          /* Upload State */
          <div className="flex flex-col gap-6">
            {/* Caching/WASM Alert Warning */}
            <div className="flex items-start gap-3 rounded-xl border border-indigo-500/10 bg-indigo-500/5 p-4">
              <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-indigo-500/10 text-[#8B78FF]">
                <ShieldCheck className="h-4 w-4" />
              </div>
              <div className="flex-1">
                <h4 className="text-xs font-bold text-zinc-900 dark:text-white">
                  100% Secure Local AI Processing
                </h4>
                <p className="text-[10px] text-zinc-500 dark:text-[#9B9BA6] mt-1 leading-relaxed">
                  Your photos are processed entirely inside your browser. A quantized model ({activeTool === 'bg-remover' ? '~20MB' : '~12MB'}) downloads once on your first run and is saved locally. No images are sent to any server.
                </p>
              </div>
            </div>

            {/* Drop Zone */}
            <div
              onDragOver={handleDragOver}
              onDrop={handleDrop}
              onClick={() => fileInputRef.current?.click()}
              className="relative flex flex-col items-center justify-center rounded-2xl border-2 border-dashed border-zinc-200 dark:border-[#2E2E35] bg-zinc-50/50 dark:bg-[#121214]/40 hover:bg-zinc-100/50 dark:hover:bg-[#121214]/85 p-12 text-center cursor-pointer group transition-all duration-200 min-h-[220px]"
            >
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                onChange={handleFileSelect}
                className="hidden"
              />
              
              <div className="flex h-12 w-12 items-center justify-center rounded-full bg-white dark:bg-[#1A1A1E] border border-zinc-200 dark:border-[#2E2E35] text-zinc-400 dark:text-[#9B9BA6] group-hover:text-[#6D57EC] group-hover:border-[#6D57EC]/40 group-hover:bg-[#6D57EC]/10 transition-all duration-300">
                <Upload className="h-5 w-5 group-hover:scale-110 transition-transform" />
              </div>
              
              <h3 className="mt-4 text-xs font-semibold text-zinc-800 dark:text-white tracking-wide">
                Drag and drop your image here, or <span className="text-[#8B78FF] underline">browse</span>.
              </h3>
              <p className="mt-1 text-[10px] text-zinc-500 dark:text-[#9B9BA6]">
                Supports JPEGs, PNGs and WebPs up to 10MB
              </p>
            </div>
          </div>
        ) : (
          /* Process & View State */
          <div className="flex flex-col gap-6">
            
            {/* Visualizer Frame */}
            <div className="relative rounded-xl border border-zinc-200 dark:border-[#2E2E35] bg-zinc-100 dark:bg-[#121214] overflow-hidden flex items-center justify-center p-4 min-h-[320px] max-h-[460px]">
              {activeSelectedItem.status === 'completed' && activeSelectedItem.resultUrl ? (
                /* Completed State */
                activeTool === 'upscaler' ? (
                  /* AI Image Enhancer: Hover Magnifier Preview */
                  <div 
                    className="relative w-full h-full flex items-center justify-center cursor-crosshair"
                    onMouseMove={handleMagnifierMouseMove}
                    onMouseLeave={handleMagnifierMouseLeave}
                  >
                    <img 
                      src={activeSelectedItem.resultUrl} 
                      alt="Upscaled result" 
                      className="max-w-full max-h-[360px] object-contain rounded-lg shadow-xl"
                    />
                    
                    {/* Hover Magnifier circular overlay */}
                    {magnifierPos.show && (
                      <div 
                        className="absolute w-36 h-36 rounded-full border-2 border-[#6D57EC] shadow-[0_10px_25px_rgba(0,0,0,0.5)] pointer-events-none z-10"
                        style={{
                          left: `${magnifierPos.x - 72}px`,
                          top: `${magnifierPos.y - 72}px`,
                          backgroundImage: `url(${activeSelectedItem.resultUrl})`,
                          backgroundPosition: magnifierBgPos,
                          backgroundSize: `${3 * 100}%`, // 3x zoom
                          backgroundRepeat: 'no-repeat',
                          backgroundColor: '#121214'
                        }}
                      />
                    )}
                  </div>
                ) : (
                  /* Background Remover / Passport Maker: standard Output */
                  <div className="relative w-full h-full flex items-center justify-center">
                    <img 
                      src={activeSelectedItem.resultUrl} 
                      alt="Output cutout" 
                      className="max-w-full max-h-[360px] object-contain rounded-lg shadow-xl"
                    />
                  </div>
                )
              ) : (
                /* Original Image / Processing State */
                <div className="relative w-full h-full flex items-center justify-center">
                  <div 
                    ref={cropWrapperRef}
                    className="relative max-w-full max-h-[360px] flex items-center justify-center"
                  >
                    <img 
                      src={activeSelectedItem.originalUrl} 
                      alt="Input Preview" 
                      onLoad={(e) => {
                        const img = e.currentTarget;
                        const w = img.naturalWidth || img.width;
                        const h = img.naturalHeight || img.height;
                        if (activeSelectedItem.width !== w || activeSelectedItem.height !== h) {
                          updateQueueItem(activeSelectedItem.id, { width: w, height: h });
                        }
                      }}
                      className={`max-w-full max-h-[360px] object-contain rounded-lg transition-opacity duration-200 ${
                        enableCrop ? 'opacity-85' : 'opacity-60'
                      }`}
                    />

                    {/* Interactive Drag Crop Handles */}
                    {enableCrop && activeSelectedItem.status === 'queued' && (
                      <div className="absolute inset-0 pointer-events-none select-none">
                        {/* Shaded top */}
                        <div className="absolute top-0 left-0 right-0 bg-black/65" style={{ height: `${cropTop}%` }} />
                        {/* Shaded bottom */}
                        <div className="absolute bottom-0 left-0 right-0 bg-black/65" style={{ height: `${cropBottom}%` }} />
                        {/* Shaded left */}
                        <div 
                          className="absolute left-0 bg-black/65" 
                          style={{ top: `${cropTop}%`, bottom: `${cropBottom}%`, width: `${cropLeft}%` }} 
                        />
                        {/* Shaded right */}
                        <div 
                          className="absolute right-0 bg-black/65" 
                          style={{ top: `${cropTop}%`, bottom: `${cropBottom}%`, width: `${cropRight}%` }} 
                        />

                        {/* Interactive Box border and corner drag anchor points */}
                        <div 
                          className="absolute border border-dashed border-[#8B78FF] shadow-[0_0_15px_rgba(109,87,236,0.35)]" 
                          style={{ 
                            top: `${cropTop}%`, 
                            bottom: `${cropBottom}%`, 
                            left: `${cropLeft}%`, 
                            right: `${cropRight}%` 
                          }}
                        >
                          {/* Corner Handles - large for easy mouse/touch selection */}
                          <div 
                            onMouseDown={(e) => { e.stopPropagation(); e.preventDefault(); setActiveDragHandle('top-left'); }}
                            onTouchStart={(e) => { e.stopPropagation(); setActiveDragHandle('top-left'); }}
                            className="absolute -top-2.5 -left-2.5 w-5 h-5 cursor-nwse-resize pointer-events-auto flex items-center justify-center group"
                          >
                            <div className="w-2.5 h-2.5 border-t-2 border-l-2 border-[#8B78FF] group-hover:scale-125 transition-transform" />
                          </div>
                          
                          <div 
                            onMouseDown={(e) => { e.stopPropagation(); e.preventDefault(); setActiveDragHandle('top-right'); }}
                            onTouchStart={(e) => { e.stopPropagation(); setActiveDragHandle('top-right'); }}
                            className="absolute -top-2.5 -right-2.5 w-5 h-5 cursor-nesw-resize pointer-events-auto flex items-center justify-center group"
                          >
                            <div className="w-2.5 h-2.5 border-t-2 border-r-2 border-[#8B78FF] group-hover:scale-125 transition-transform" />
                          </div>

                          <div 
                            onMouseDown={(e) => { e.stopPropagation(); e.preventDefault(); setActiveDragHandle('bottom-left'); }}
                            onTouchStart={(e) => { e.stopPropagation(); setActiveDragHandle('bottom-left'); }}
                            className="absolute -bottom-2.5 -left-2.5 w-5 h-5 cursor-nesw-resize pointer-events-auto flex items-center justify-center group"
                          >
                            <div className="w-2.5 h-2.5 border-b-2 border-l-2 border-[#8B78FF] group-hover:scale-125 transition-transform" />
                          </div>

                          <div 
                            onMouseDown={(e) => { e.stopPropagation(); e.preventDefault(); setActiveDragHandle('bottom-right'); }}
                            onTouchStart={(e) => { e.stopPropagation(); setActiveDragHandle('bottom-right'); }}
                            className="absolute -bottom-2.5 -right-2.5 w-5 h-5 cursor-nwse-resize pointer-events-auto flex items-center justify-center group"
                          >
                            <div className="w-2.5 h-2.5 border-b-2 border-r-2 border-[#8B78FF] group-hover:scale-125 transition-transform" />
                          </div>
                        </div>
                      </div>
                    )}
                  </div>

                  {/* Processing Overlay */}
                  {activeSelectedItem.status !== 'queued' && (
                    <div className="absolute inset-0 bg-white/90 dark:bg-[#121214]/90 flex flex-col items-center justify-center p-4">
                      <RefreshCw className="h-8 w-8 text-[#6D57EC] animate-spin mb-3" />
                      <span className="text-sm font-bold text-zinc-950 dark:text-white">{activeSelectedItem.progressMessage}</span>
                      <span className="text-xs text-zinc-500 dark:text-[#9B9BA6] mt-1">{activeSelectedItem.progress}%</span>
                      
                      <div className="w-48 bg-zinc-200 dark:bg-[#1A1A1E] h-1.5 rounded-full mt-3 overflow-hidden border border-zinc-300 dark:border-[#2E2E35]">
                        <div 
                          className="bg-[#6D57EC] h-full transition-all duration-300"
                          style={{ width: `${activeSelectedItem.progress}%` }}
                        />
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Task controls */}
            {activeSelectedItem.status === 'completed' ? (
              /* Completed controls */
              <div className="flex flex-col gap-4">
                {activeTool === 'bg-remover' && (
                  <div className="rounded-xl border border-zinc-200 dark:border-[#2E2E35] bg-zinc-50/50 dark:bg-[#121214]/30 p-4 flex flex-col gap-3">
                    {/* Background presets */}
                    {pathname !== '/clear-background-png' && (
                      <div>
                        <span className="text-[10px] font-bold text-zinc-500 dark:text-[#9B9BA6] block mb-1.5 uppercase">Background Color Swapper</span>
                        <div className="flex flex-wrap gap-2">
                          {[
                            { id: 'transparent', label: 'Transparent' },
                            { id: '#ffffff', label: 'White' },
                            { id: '#0047AB', label: 'Blue' },
                            { id: '#808080', label: 'Grey' },
                            { id: 'custom', label: 'Custom' }
                          ].map(col => (
                            <button
                              key={col.id}
                              type="button"
                              onClick={() => { setBgColor(col.id); startProcessing(); }}
                              className={`rounded px-2.5 py-1 text-[10px] font-semibold border transition-all ${
                                bgColor === col.id 
                                  ? 'bg-[#6D57EC] text-white border-[#8B78FF]/30' 
                                  : 'bg-zinc-100 dark:bg-[#2A2A30] text-zinc-600 dark:text-[#9B9BA6] border-zinc-200 dark:border-[#2E2E35] hover:text-zinc-950 dark:hover:text-white'
                              }`}
                            >
                              {col.label}
                            </button>
                          ))}
                        </div>
                        {bgColor === 'custom' && (
                          <div className="flex items-center gap-2 mt-2">
                            <input 
                              type="color" 
                              value={customBgColor} 
                              onChange={(e) => setCustomBgColor(e.target.value)}
                              className="h-6 w-10 border border-zinc-200 dark:border-[#2E2E35] rounded bg-white dark:bg-[#1A1A1E] cursor-pointer"
                            />
                            <input 
                              type="text" 
                              value={customBgColor}
                              onChange={(e) => setCustomBgColor(e.target.value)}
                              className="flex-1 bg-white dark:bg-[#121214] border border-zinc-200 dark:border-[#2E2E35] rounded px-2.5 py-0.5 text-xs text-zinc-800 dark:text-white"
                            />
                            <button
                              type="button"
                              onClick={startProcessing}
                              className="rounded px-2.5 py-1 text-[10px] bg-[#6D57EC] text-white font-semibold"
                            >
                              Apply
                            </button>
                          </div>
                        )}
                      </div>
                    )}
                    
                    {/* Shadow Controls */}
                    {!passportPreset && (
                      <div className="grid grid-cols-2 gap-3 border-t border-zinc-250 dark:border-[#2E2E35]/40 pt-3">
                        <div>
                          <span className="text-[10px] font-bold text-zinc-500 dark:text-[#9B9BA6] flex justify-between uppercase">
                            <span>Shadow Blur</span>
                            <span className="text-zinc-800 dark:text-white">{shadowBlur}px</span>
                          </span>
                          <input 
                            type="range" 
                            min="0" 
                            max="25" 
                            value={shadowBlur} 
                            onChange={(e) => setShadowBlur(parseInt(e.target.value))}
                            onMouseUp={startProcessing}
                            onTouchEnd={startProcessing}
                            className="w-full accent-[#6D57EC] bg-zinc-200 dark:bg-[#2E2E35] h-1 rounded mt-1.5"
                          />
                        </div>
                        <div>
                          <span className="text-[10px] font-bold text-zinc-500 dark:text-[#9B9BA6] flex justify-between uppercase">
                            <span>Offset</span>
                            <span className="text-zinc-800 dark:text-white">{shadowOffset}px</span>
                          </span>
                          <input 
                            type="range" 
                            min="-15" 
                            max="15" 
                            value={shadowOffset} 
                            onChange={(e) => setShadowOffset(parseInt(e.target.value))}
                            onMouseUp={startProcessing}
                            onTouchEnd={startProcessing}
                            className="w-full accent-[#6D57EC] bg-zinc-200 dark:bg-[#2E2E35] h-1 rounded mt-1.5"
                          />
                        </div>
                      </div>
                    )}
                  </div>
                )}

                {activeTool === 'upscaler' && (
                  <p className="text-[10px] text-zinc-500 dark:text-[#9B9BA6] text-center italic">
                    💡 Hover over the image to inspect the 4x enhanced high-definition pixel enhancements.
                  </p>
                )}

                {/* Final actions */}
                <div className="flex gap-3">
                  <button
                    onClick={() => copyToClipboard(activeSelectedItem)}
                    className="flex-1 flex items-center justify-center gap-1.5 rounded-lg border border-zinc-200 dark:border-[#2E2E35] bg-zinc-100 hover:bg-zinc-200 dark:bg-[#2A2A30] dark:hover:bg-[#2A2A30]/80 text-zinc-700 dark:text-[#9B9BA6] hover:text-zinc-950 dark:hover:text-white py-2.5 text-xs transition-colors font-semibold"
                  >
                    <Copy className="h-4 w-4" />
                    Copy to Clipboard
                  </button>
                  <button
                    onClick={() => handleDownload(activeSelectedItem)}
                    className="flex-1 flex items-center justify-center gap-1.5 rounded-lg bg-[#6D57EC] hover:bg-[#8B78FF] text-white py-2.5 text-xs transition-colors font-bold shadow-[0_4px_15px_rgba(109,87,236,0.2)]"
                  >
                    <Download className="h-4 w-4" />
                    Download Image
                  </button>
                </div>
              </div>
            ) : (
              /* Queued / Crop controls */
              <div className="flex flex-col gap-4">
                {activeSelectedItem.status === 'queued' && (
                  <div className="rounded-xl border border-zinc-200 dark:border-[#2E2E35] bg-zinc-50/50 dark:bg-[#121214]/30 p-4 flex flex-col gap-3">
                    
                    {/* Manual Crop Switch */}
                    {!passportPreset && (
                      <label className="flex items-center gap-2 cursor-pointer">
                        <input 
                          type="checkbox" 
                          checked={enableCrop}
                          onChange={(e) => setEnableCrop(e.target.checked)}
                          className="rounded border-zinc-300 dark:border-[#2E2E35] bg-white dark:bg-[#121214] text-[#6D57EC] focus:ring-[#6D57EC] h-3.5 w-3.5"
                        />
                        <div className="flex flex-col">
                          <span className="text-[11px] font-bold text-zinc-900 dark:text-white">Enable Manual Crop</span>
                          <span className="text-[9px] text-zinc-500 dark:text-[#9B9BA6]">Drag corners on the visualizer directly to crop</span>
                        </div>
                      </label>
                    )}

                    {/* Auto-trim transparency (Only BG remover, NOT passport) */}
                    {activeTool === 'bg-remover' && !passportPreset && (
                      <label className="flex items-center gap-2 cursor-pointer border-t border-zinc-250 dark:border-[#2E2E35]/40 pt-2 mt-1">
                        <input 
                          type="checkbox" 
                          checked={autoTrim}
                          onChange={(e) => setAutoTrim(e.target.checked)}
                          className="rounded border-zinc-300 dark:border-[#2E2E35] bg-white dark:bg-[#121214] text-[#6D57EC] focus:ring-[#6D57EC] h-3.5 w-3.5"
                        />
                        <div className="flex flex-col">
                          <span className="text-[11px] font-bold text-zinc-900 dark:text-white">Auto-Trim Transparency</span>
                          <span className="text-[9px] text-zinc-500 dark:text-[#9B9BA6]">Automatically crop empty borders</span>
                        </div>
                      </label>
                    )}

                    {/* Aspect Ratio select (hidden if passport) */}
                    {enableCrop && !passportPreset && (
                      <div className="border-t border-zinc-250 dark:border-[#2E2E35]/40 pt-2 mt-1 flex flex-col gap-1.5">
                        <span className="text-[9px] font-bold text-zinc-500 dark:text-[#9B9BA6] uppercase">Crop Aspect Ratio</span>
                        <select
                          value={cropAspectRatio}
                          onChange={(e) => setCropAspectRatio(e.target.value)}
                          className="w-full rounded border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E] text-[10px] text-zinc-800 dark:text-white px-2 py-1 outline-none focus:border-[#6D57EC]"
                        >
                          <option value="free">Free Form</option>
                          <option value="1:1">Square (1:1)</option>
                          <option value="passport">Passport (3.5 : 4.5)</option>
                          <option value="4:5">Portrait (4:5)</option>
                          <option value="16:9">Landscape (16:9)</option>
                        </select>
                      </div>
                    )}
                  </div>
                )}

                {/* Primary trigger button */}
                <div className="flex gap-3">
                  <button
                    type="button"
                    onClick={clearQueue}
                    className="rounded-lg border border-zinc-200 dark:border-[#2E2E35] bg-zinc-100 hover:bg-zinc-200 dark:bg-[#2A2A30] dark:hover:bg-[#2A2A30]/80 text-zinc-800 dark:text-white px-4 py-2.5 text-xs font-semibold transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    type="button"
                    onClick={startProcessing}
                    disabled={isProcessing}
                    className="flex-1 rounded-lg bg-[#6D57EC] hover:bg-[#8B78FF] text-white px-4 py-2.5 text-xs font-bold shadow-[0_4px_15px_rgba(109,87,236,0.3)] disabled:opacity-50 transition-all duration-200"
                  >
                    {isProcessing ? 'Initializing AI Engine...' : 'Process Image'}
                  </button>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
