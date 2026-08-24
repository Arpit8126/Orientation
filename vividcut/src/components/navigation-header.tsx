'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useTheme } from './theme-provider';
import { 
  Sun, 
  Moon, 
  Menu, 
  X, 
  Sparkles, 
  ShieldCheck, 
  ChevronDown, 
  CloudLightning,
  Image as ImageIcon,
  UserCheck,
  Zap,
  StickyNote
} from 'lucide-react';

export function NavigationHeader() {
  const pathname = usePathname();
  const { theme, toggleTheme } = useTheme();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [toolsDropdownOpen, setToolsDropdownOpen] = useState(false);
  const [cacheStatus, setCacheStatus] = useState<'checking' | 'not-cached' | 'cached'>('checking');

  // Check the Service Worker cache storage for loaded model assets
  useEffect(() => {
    const checkCache = async () => {
      if (typeof window !== 'undefined' && 'caches' in window) {
        try {
          const cache = await caches.open('vividcut-assets-cache-v1');
          // Check if the quantized background removal model is loaded
          const match = await cache.match('https://static.imgly.com/packages/@imgly/background-removal-js/1.7.0/assets/models/isnet_quint8.onnx');
          if (match) {
            setCacheStatus('cached');
          } else {
            setCacheStatus('not-cached');
          }
        } catch (e) {
          setCacheStatus('not-cached');
        }
      } else {
        setCacheStatus('not-cached');
      }
    };

    checkCache();
    // Poll cache status periodically to update the badge as background caching proceeds
    const interval = setInterval(checkCache, 5000);
    return () => clearInterval(interval);
  }, []);

  const tools = [
    {
      name: 'Background Remover',
      description: 'Isolate subjects and swap backdrops.',
      href: '/remove-background-from-image',
      icon: ImageIcon,
    },
    {
      name: 'Passport Photo Maker',
      description: 'Format official blue/white/grey sizes.',
      href: '/make-passport-photo-online',
      icon: UserCheck,
    },
    {
      name: 'AI Image Upscaler',
      description: 'Upscale and rebuild details 4x.',
      href: '/enhance-photo-quality-free',
      icon: Zap,
    },
    {
      name: 'Transparent PNG Creator',
      description: 'Make transparency stickers.',
      href: '/clear-background-png',
      icon: StickyNote,
    },
  ];

  return (
    <header className="fixed top-0 left-0 right-0 z-50 border-b border-[#2E2E35] dark:border-[#2E2E35] light:border-zinc-200 bg-[#1A1A1E]/80 dark:bg-[#1A1A1E]/85 light:bg-white/80 backdrop-blur-md transition-colors duration-200">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 items-center justify-between">
          {/* Logo & Brand */}
          <div className="flex items-center gap-6">
            <Link href="/" className="flex items-center gap-2 group">
              <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-[#6D57EC] text-white shadow-[0_0_15px_rgba(109,87,236,0.5)] group-hover:scale-105 transition-transform duration-200">
                <Sparkles className="h-5 w-5" />
              </div>
              <span className="text-lg font-bold tracking-tight text-[#1A1A1E] dark:text-white light:text-zinc-900">
                Vivid<span className="text-[#8B78FF]">Cut</span>
              </span>
            </Link>

            {/* Offline Cache Status Badge */}
            <div className="hidden sm:inline-flex">
              {cacheStatus === 'cached' ? (
                <span className="inline-flex items-center gap-1 rounded-full bg-emerald-500/10 dark:bg-emerald-500/10 light:bg-emerald-500/5 px-2.5 py-0.5 text-xs font-medium text-emerald-500 border border-emerald-500/20">
                  <ShieldCheck className="h-3.5 w-3.5" />
                  Cached (Offline Ready)
                </span>
              ) : cacheStatus === 'checking' ? (
                <span className="inline-flex items-center gap-1 rounded-full bg-zinc-500/10 px-2.5 py-0.5 text-xs font-medium text-[#9B9BA6] border border-zinc-500/20 animate-pulse">
                  Checking Cache...
                </span>
              ) : (
                <span className="inline-flex items-center gap-1 rounded-full bg-amber-500/10 dark:bg-amber-500/10 light:bg-amber-500/5 px-2.5 py-0.5 text-xs font-medium text-amber-500 border border-amber-500/20">
                  <CloudLightning className="h-3.5 w-3.5 animate-bounce mt-0.5" />
                  Setup Needed (~20MB)
                </span>
              )}
            </div>
          </div>

          {/* Desktop Navigation Links */}
          <nav className="hidden md:flex items-center gap-6">
            <Link 
              href="/" 
              className={`text-sm font-semibold transition-colors ${
                pathname === '/' 
                  ? 'text-[#6D57EC]' 
                  : 'text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:text-[#6D57EC] dark:hover:text-white light:hover:text-zinc-900'
              }`}
            >
              Home
            </Link>

            {/* Tools Dropdown Trigger */}
            <div className="relative">
              <button
                onClick={() => setToolsDropdownOpen(!toolsDropdownOpen)}
                onBlur={() => setTimeout(() => setToolsDropdownOpen(false), 200)}
                className="flex items-center gap-1 text-sm font-semibold text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:text-[#6D57EC] dark:hover:text-white light:hover:text-zinc-900 transition-colors"
              >
                Tools
                <ChevronDown className={`h-4 w-4 transition-transform duration-200 ${toolsDropdownOpen ? 'rotate-180' : ''}`} />
              </button>

              {/* Dropdown Menu */}
              {toolsDropdownOpen && (
                <div className="absolute top-full left-1/2 -translate-x-1/2 mt-2 w-80 rounded-2xl border border-[#2E2E35] dark:border-[#2E2E35] light:border-zinc-200 bg-[#1A1A1E] dark:bg-[#1A1A1E] light:bg-white p-4 shadow-xl ring-1 ring-black/5 animate-in fade-in slide-in-from-top-2 duration-150">
                  <div className="grid gap-2">
                    {tools.map((tool, idx) => {
                      const Icon = tool.icon;
                      return (
                        <Link
                          key={idx}
                          href={tool.href}
                          className="flex items-start gap-3 rounded-xl p-2 hover:bg-[#121214] dark:hover:bg-[#121214] light:hover:bg-zinc-100 transition-colors group"
                        >
                          <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-[#6D57EC]/10 border border-[#6D57EC]/20 text-[#8B78FF]">
                            <Icon className="h-5 w-5" />
                          </div>
                          <div>
                            <div className="text-xs font-bold text-white dark:text-white light:text-zinc-800 group-hover:text-[#8B78FF]">
                              {tool.name}
                            </div>
                            <p className="text-[10px] text-[#9B9BA6] mt-0.5">
                              {tool.description}
                            </p>
                          </div>
                        </Link>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>

            <Link 
              href="/features" 
              className={`text-sm font-semibold transition-colors ${
                pathname === '/features' 
                  ? 'text-[#6D57EC]' 
                  : 'text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:text-[#6D57EC] dark:hover:text-white light:hover:text-zinc-900'
              }`}
            >
              Features
            </Link>

            <Link 
              href="/about" 
              className={`text-sm font-semibold transition-colors ${
                pathname === '/about' 
                  ? 'text-[#6D57EC]' 
                  : 'text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:text-[#6D57EC] dark:hover:text-white light:hover:text-zinc-900'
              }`}
            >
              About
            </Link>
          </nav>

          {/* Right Panel: Theme & Mobile Toggle */}
          <div className="flex items-center gap-4">
            {/* Theme Toggle Button */}
            <button
              onClick={toggleTheme}
              className="rounded-lg p-2 text-[#9B9BA6] hover:bg-[#2A2A30] dark:hover:bg-[#2A2A30] light:hover:bg-zinc-100 hover:text-white dark:hover:text-white light:hover:text-zinc-950 transition-colors"
              title={theme === 'dark' ? 'Switch to Light Mode' : 'Switch to Dark Mode'}
            >
              {theme === 'dark' ? (
                <Sun className="h-5 w-5 text-amber-400" />
              ) : (
                <Moon className="h-5 w-5 text-indigo-600" />
              )}
            </button>

            {/* Mobile Menu Button */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="rounded-lg p-2 text-[#9B9BA6] hover:bg-[#2A2A30] dark:hover:bg-[#2A2A30] light:hover:bg-zinc-100 md:hidden hover:text-white dark:hover:text-white light:hover:text-zinc-950 transition-colors"
            >
              {mobileMenuOpen ? (
                <X className="h-5 w-5" />
              ) : (
                <Menu className="h-5 w-5" />
              )}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Navigation Drawer */}
      {mobileMenuOpen && (
        <div className="md:hidden border-t border-[#2E2E35] dark:border-[#2E2E35] light:border-zinc-200 bg-[#1A1A1E] dark:bg-[#1A1A1E] light:bg-white animate-in slide-in-from-top duration-200">
          <div className="space-y-1 px-4 py-4 flex flex-col gap-2">
            {/* Cache badge for mobile */}
            <div className="py-1 px-3 sm:hidden self-start">
              {cacheStatus === 'cached' ? (
                <span className="inline-flex items-center gap-1 rounded-full bg-emerald-500/10 px-2.5 py-0.5 text-[10px] font-medium text-emerald-500 border border-emerald-500/20">
                  <ShieldCheck className="h-3 w-3" />
                  Cached (Offline Ready)
                </span>
              ) : (
                <span className="inline-flex items-center gap-1 rounded-full bg-amber-500/10 px-2.5 py-0.5 text-[10px] font-medium text-amber-500 border border-amber-500/20">
                  <CloudLightning className="h-3 w-3" />
                  Setup Needed (~20MB)
                </span>
              )}
            </div>

            <Link
              href="/"
              onClick={() => setMobileMenuOpen(false)}
              className={`block rounded-lg px-3 py-2 text-base font-semibold ${
                pathname === '/' ? 'bg-[#6D57EC]/10 text-[#8B78FF]' : 'text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:bg-[#2A2A30] dark:hover:bg-[#2A2A30] light:hover:bg-zinc-100'
              }`}
            >
              Home
            </Link>

            <div className="px-3 py-2">
              <span className="text-xs font-bold text-zinc-500 uppercase tracking-wider block mb-2">Specialized Tools</span>
              <div className="grid gap-2 pl-2">
                {tools.map((tool, idx) => (
                  <Link
                    key={idx}
                    href={tool.href}
                    onClick={() => setMobileMenuOpen(false)}
                    className={`flex items-center gap-3 rounded-lg px-2 py-1.5 text-sm ${
                      pathname === tool.href ? 'text-[#8B78FF] font-semibold' : 'text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:text-white dark:hover:text-white light:hover:text-zinc-950'
                    }`}
                  >
                    {tool.name}
                  </Link>
                ))}
              </div>
            </div>

            <Link
              href="/features"
              onClick={() => setMobileMenuOpen(false)}
              className={`block rounded-lg px-3 py-2 text-base font-semibold ${
                pathname === '/features' ? 'bg-[#6D57EC]/10 text-[#8B78FF]' : 'text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:bg-[#2A2A30] dark:hover:bg-[#2A2A30] light:hover:bg-zinc-100'
              }`}
            >
              Features
            </Link>

            <Link
              href="/about"
              onClick={() => setMobileMenuOpen(false)}
              className={`block rounded-lg px-3 py-2 text-base font-semibold ${
                pathname === '/about' ? 'bg-[#6D57EC]/10 text-[#8B78FF]' : 'text-[#9B9BA6] dark:text-[#9B9BA6] light:text-zinc-600 hover:bg-[#2A2A30] dark:hover:bg-[#2A2A30] light:hover:bg-zinc-100'
              }`}
            >
              About
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}
