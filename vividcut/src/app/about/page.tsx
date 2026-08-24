import React from 'react';
import Link from 'next/link';
import { Shield, Cpu, CloudOff, Sparkles, Code, ArrowRight } from 'lucide-react';

export default function AboutPage() {
  const principles = [
    {
      icon: Shield,
      title: '100% Client-Side Privacy',
      description: 'Your images are never uploaded to any server. All segmentations, crops, and super-resolution upscales happen locally within your browser sandbox.',
    },
    {
      icon: CloudOff,
      title: 'Zero Server Infrastructure',
      description: 'By offloading heavy AI calculations to your device, we maintain $0 server cost. This allows us to keep the service free, fast, and completely unlimited.',
    },
    {
      icon: Cpu,
      title: 'WebGPU & WASM Hardware Speed',
      description: 'We compile neural networks to WebAssembly and leverage WebGPU hardware acceleration to run AI models at native hardware speeds directly on your GPU.',
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
            About <span className="text-[#8B78FF]">VividCut</span>
          </h1>
          <p className="mt-4 text-base text-zinc-500 dark:text-[#9B9BA6] max-w-xl mx-auto leading-relaxed">
            The world\'s first professional-grade, serverless AI Image Manipulation micro-SaaS running completely on your device.
          </p>
        </div>

        {/* Narrative */}
        <div className="prose dark:prose-invert max-w-none mb-16 space-y-6">
          <h2 className="text-xl font-bold border-b border-zinc-200 dark:border-[#2E2E35] pb-2 text-zinc-900 dark:text-white">
            Our Mission: Democratizing Local AI
          </h2>
          <p className="text-xs text-zinc-600 dark:text-[#9B9BA6] leading-relaxed">
            Traditional AI services force you to upload your personal files to distant servers. This compromises your privacy, forces you to wait in long queues, and requires companies to charge expensive monthly subscription fees to cover their massive GPU server bills.
          </p>
          <p className="text-xs text-zinc-600 dark:text-[#9B9BA6] leading-relaxed">
            <strong>VividCut does things differently.</strong> We believe that modern computers, laptops, and smartphones have incredibly powerful processors and graphics cards that are often sitting idle. By writing highly-optimized client-side compilation layers, we run heavy neural networks directly on your device. The result? Instant processing, complete privacy, and zero fees.
          </p>
        </div>

        {/* Principles Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          {principles.map((item, idx) => {
            const Icon = item.icon;
            return (
              <div 
                key={idx} 
                className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E] p-6 shadow-sm flex flex-col gap-3 hover:border-[#6D57EC]/30 transition-colors"
              >
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-[#6D57EC]/10 border border-[#6D57EC]/20 text-[#8B78FF]">
                  <Icon className="h-5 w-5" />
                </div>
                <h3 className="text-sm font-bold text-zinc-900 dark:text-white">{item.title}</h3>
                <p className="text-[11px] text-zinc-500 dark:text-[#9B9BA6] leading-relaxed flex-1">
                  {item.description}
                </p>
              </div>
            );
          })}
        </div>

        {/* Call to Action */}
        <div className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-zinc-100/50 dark:bg-[#1A1A1E]/30 p-8 text-center">
          <h2 className="text-lg font-bold text-zinc-900 dark:text-white">Ready to experience the future?</h2>
          <p className="text-xs text-zinc-500 dark:text-[#9B9BA6] mt-2 mb-6">
            Get started now. No signup required, no cookies, no subscriptions.
          </p>
          <div className="flex justify-center gap-4 flex-wrap">
            <Link 
              href="/remove-background-from-image" 
              className="inline-flex items-center gap-1.5 rounded-lg bg-[#6D57EC] hover:bg-[#8B78FF] text-white px-4 py-2 text-xs font-semibold transition-colors"
            >
              Start Removing Backgrounds
              <ArrowRight className="h-4 w-4" />
            </Link>
            <Link 
              href="/enhance-photo-quality-free" 
              className="inline-flex items-center gap-1.5 rounded-lg border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E] hover:bg-zinc-100 dark:hover:bg-[#2A2A30] text-zinc-800 dark:text-white px-4 py-2 text-xs font-semibold transition-colors"
            >
              Start AI Upscaling
            </Link>
          </div>
        </div>
      </div>
    </main>
  );
}
