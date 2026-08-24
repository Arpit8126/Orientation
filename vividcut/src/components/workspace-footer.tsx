import React from 'react';
import Link from 'next/link';

export function WorkspaceFooter() {
  const toolColumns = [
    {
      title: 'Background Separation',
      links: [
        { label: 'AI Background Remover Free', href: '/remove-background-from-image' },
        { label: 'Clear Image Background Online', href: '/remove-background-from-image' },
        { label: 'Isolate Subject Client-Side', href: '/remove-background-from-image' },
        { label: 'Erase Portrait Background', href: '/remove-background-from-image' },
        { label: 'Cut Out Product Photo', href: '/remove-background-from-image' }
      ]
    },
    {
      title: 'Passport Photo Tools',
      links: [
        { label: 'Passport Photo Background to White', href: '/make-passport-photo-online' },
        { label: 'Visa Photo Background Converter', href: '/make-passport-photo-online' },
        { label: 'Passport Background Blue Swap', href: '/make-passport-photo-online' },
        { label: 'Passport Background Grey Swap', href: '/make-passport-photo-online' },
        { label: 'Official Passport Size Generator', href: '/make-passport-photo-online' }
      ]
    },
    {
      title: 'Super-Resolution',
      links: [
        { label: 'AI Photo Quality Enhancer', href: '/enhance-photo-quality-free' },
        { label: '4x Image Upscaler Online', href: '/enhance-photo-quality-free' },
        { label: 'Fix Blurry Portrait Free', href: '/enhance-photo-quality-free' },
        { label: 'WebGPU Hardware Accelerated Upscale', href: '/enhance-photo-quality-free' },
        { label: 'Unblur Low-Res JPEG Online', href: '/enhance-photo-quality-free' }
      ]
    },
    {
      title: 'Lossless Formatting',
      links: [
        { label: 'Make PNG Transparent Online', href: '/clear-background-png' },
        { label: 'Extract Transparent Signature', href: '/clear-background-png' },
        { label: 'Convert JPEG to Transparent PNG', href: '/clear-background-png' },
        { label: 'Zero-Degradation PNG Generator', href: '/clear-background-png' },
        { label: 'Uncompressed WebP Exporter', href: '/clear-background-png' }
      ]
    }
  ];

  return (
    <footer className="w-full border-t border-[#2E2E35] bg-[#121214] py-12 px-6 sm:px-12 md:px-24">
      <div className="mx-auto max-w-7xl">
        <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 md:grid-cols-4">
          {toolColumns.map((col, index) => (
            <div key={index} className="flex flex-col gap-4">
              <h3 className="text-sm font-semibold tracking-wider text-[#FFFFFF] uppercase">
                {col.title}
              </h3>
              <nav className="flex flex-col gap-2">
                {col.links.map((link, linkIndex) => (
                  <Link
                    key={linkIndex}
                    href={link.href}
                    className="text-xs text-[#9B9BA6] hover:text-[#8B78FF] transition-colors duration-200"
                  >
                    {link.label}
                  </Link>
                ))}
              </nav>
            </div>
          ))}
        </div>

        <div className="mt-12 flex flex-col items-center justify-between border-t border-[#2E2E35] pt-6 md:flex-row gap-4">
          <div className="flex flex-col items-center md:items-start gap-1">
            <span className="text-sm font-bold text-white tracking-tight flex items-center gap-1.5">
              <span className="h-2 w-2 rounded-full bg-[#6D57EC] animate-pulse"></span>
              Vivid<span className="text-[#8B78FF]">Cut</span>
            </span>
            <p className="text-xs text-[#9B9BA6] text-center md:text-left">
              100% Client-side AI Image Processing. Privacy-first, zero server uploads, zero cost.
            </p>
          </div>
          <p className="text-xs text-[#9B9BA6]">
            &copy; {new Date().getFullYear()} VividCut. Built on WebGPU & WebAssembly.
          </p>
        </div>
      </div>
    </footer>
  );
}
