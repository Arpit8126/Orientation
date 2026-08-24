import React from 'react';
import Link from 'next/link';
import { 
  Zap, 
  Layers, 
  Database, 
  Crop, 
  ShieldCheck, 
  Sparkles, 
  ArrowRight,
  Code
} from 'lucide-react';

export default function FeaturesPage() {
  const features = [
    {
      icon: Layers,
      title: 'Quantized Segmentations',
      tech: '@imgly/background-removal-js',
      description: 'Uses an 8-bit integer quantized ISNet neural network (~20MB) to perform local pixel classification and isolate subjects instantly.',
    },
    {
      icon: Zap,
      title: 'Real-ESRGAN Super-Resolution',
      tech: 'TensorFlow.js + WebGPU',
      description: 'Upscales image resolution 4x by rebuilding missing high-frequency details. Leverages local GPU threads using WebGPU or WebGL execution providers.',
    },
    {
      icon: Database,
      title: 'EXIF Metadata Preservation',
      tech: 'piexifjs binary parser',
      description: 'Extracts camera parameters, GPS coordinates, capture dates, and lens details from original JPEG binary headers and transfers them into output canvas blobs.',
    },
    {
      icon: Crop,
      title: 'Offscreen Canvas Processing',
      tech: 'Zero-Degradation Canvas Engine',
      description: 'Runs auto-trim scanning and aspect-ratio crops on full-scale offscreen canvas nodes prior to upscaling, preventing down-sampling blur.',
    },
    {
      icon: ShieldCheck,
      title: 'Service Worker Cache Layer',
      tech: 'Offline-First Cache API',
      description: 'Intercepts heavy model weight requests and stores them permanently in Cache Storage, enabling near-instant loads on subsequent visits.',
    },
    {
      icon: Code,
      title: '100% Client-Side Runtime',
      tech: 'Next.js + WASM Runtime',
      description: 'No database, no APIs, no analytics tracking, no server overhead. An entire enterprise-grade SaaS packaged into static browser clients.',
    },
  ];

  return (
    <main className="min-h-screen bg-zinc-50 dark:bg-[#121214] text-zinc-800 dark:text-white py-16 px-4 sm:px-6 lg:px-8 transition-colors duration-200">
      <div className="mx-auto max-w-4xl">
        {/* Hero Section */}
        <div className="text-center mb-16">
          <div className="inline-flex h-9 w-9 items-center justify-center rounded-xl bg-[#6D57EC]/10 border border-[#6D57EC]/20 text-[#8B78FF] mb-4">
            <Sparkles className="h-5 w-5" />
          </div>
          <h1 className="text-4xl font-extrabold tracking-tight text-zinc-900 dark:text-white sm:text-5xl">
            VividCut <span className="text-[#8B78FF]">Features</span>
          </h1>
          <p className="mt-4 text-base text-zinc-500 dark:text-[#9B9BA6] max-w-xl mx-auto leading-relaxed">
            Discover the client-side technology stack and local AI models powering the zero-latency processing engine.
          </p>
        </div>

        {/* Features Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-16">
          {features.map((item, idx) => {
            const Icon = item.icon;
            return (
              <div 
                key={idx} 
                className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E] p-6 shadow-sm flex flex-col gap-3 hover:border-[#6D57EC]/30 transition-colors"
              >
                <div className="flex items-center justify-between">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-[#6D57EC]/10 border border-[#6D57EC]/20 text-[#8B78FF]">
                    <Icon className="h-5 w-5" />
                  </div>
                  <span className="text-[9px] font-bold text-[#8B78FF] bg-[#6D57EC]/10 px-2 py-0.5 rounded-full border border-[#8B78FF]/20">
                    {item.tech}
                  </span>
                </div>
                <h3 className="text-sm font-bold text-zinc-900 dark:text-white mt-2">{item.title}</h3>
                <p className="text-[11px] text-zinc-500 dark:text-[#9B9BA6] leading-relaxed">
                  {item.description}
                </p>
              </div>
            );
          })}
        </div>

        {/* Call to Action */}
        <div className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-zinc-100/50 dark:bg-[#1A1A1E]/30 p-8 text-center">
          <h2 className="text-lg font-bold text-zinc-900 dark:text-white font-sans">Ready to test our features?</h2>
          <p className="text-xs text-zinc-500 dark:text-[#9B9BA6] mt-2 mb-6">
            Drag and drop your images into our specialized local sandboxes.
          </p>
          <div className="flex justify-center gap-4 flex-wrap">
            <Link 
              href="/make-passport-photo-online" 
              className="inline-flex items-center gap-1.5 rounded-lg bg-[#6D57EC] hover:bg-[#8B78FF] text-white px-4 py-2 text-xs font-semibold transition-colors"
            >
              Make Passport Photos
              <ArrowRight className="h-4 w-4" />
            </Link>
            <Link 
              href="/clear-background-png" 
              className="inline-flex items-center gap-1.5 rounded-lg border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E] hover:bg-zinc-100 dark:hover:bg-[#2A2A30] text-zinc-800 dark:text-white px-4 py-2 text-xs font-semibold transition-colors"
            >
              Create Transparent PNGs
            </Link>
          </div>
        </div>
      </div>
    </main>
  );
}
