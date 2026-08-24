import React from 'react';
import { getSeoContent } from '@/utils/seo-data';
import { VividCutApp } from '@/components/vividcut-app';
import { WorkspaceFooter } from '@/components/workspace-footer';
import { Info, Sparkles, Check } from 'lucide-react';

export async function generateMetadata() {
  const seo = getSeoContent('default');
  return {
    title: seo.title,
    description: seo.metaDescription,
    alternates: {
      canonical: '/',
    },
    openGraph: {
      title: seo.title,
      description: seo.metaDescription,
      type: 'website',
    }
  };
}

export default async function HomePage() {
  const seo = getSeoContent('default');

  // JSON-LD structured FAQ Schema data
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    'mainEntity': seo.faqs.map((faq) => ({
      '@type': 'Question',
      'name': faq.question,
      'acceptedAnswer': {
        '@type': 'Answer',
        'text': faq.answer
      }
    }))
  };

  return (
    <div className="flex flex-col min-h-screen bg-zinc-50 dark:bg-[#121214] text-zinc-800 dark:text-white transition-colors duration-200">
      {/* JSON-LD Schema injection */}
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      {/* Main Workspace Area */}
      <main className="flex-1 flex flex-col py-12 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto w-full gap-10">
        
        {/* Dynamic Landing Page Header */}
        <div className="text-center max-w-3xl mx-auto flex flex-col gap-3">
          <div className="inline-flex items-center gap-1.5 self-center rounded-full bg-[#6D57EC]/10 border border-[#6D57EC]/20 px-3.5 py-1 text-xs font-semibold text-[#8B78FF]">
            <Sparkles className="h-3 w-3 animate-pulse" />
            100% Client-Side AI Engine
          </div>
          
          <h1 className="text-3xl sm:text-4xl md:text-5xl font-extrabold tracking-tight text-zinc-900 dark:text-white mt-1">
            {seo.heading}
          </h1>
          
          <p className="text-sm sm:text-base text-zinc-650 dark:text-[#9B9BA6] max-w-2xl mx-auto leading-relaxed">
            {seo.subheading}
          </p>
        </div>

        {/* The Master Workspace Component */}
        <VividCutApp 
          initialTool={seo.defaultTool}
          prefilledBgColor={seo.presets?.bgColor || 'transparent'}
          exportFormat={seo.presets?.exportFormat || 'png'}
        />

        {/* Dynamic DOM Content for Search Crawlers */}
        <section className="mt-12 grid grid-cols-1 lg:grid-cols-12 gap-8 border-t border-zinc-200 dark:border-[#2E2E35] pt-12">
          
          {/* Article & Intro Column */}
          <div className="lg:col-span-8 flex flex-col gap-6">
            <div className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E]/40 p-6 sm:p-8 shadow-sm backdrop-blur-sm">
              <h2 className="text-xl font-bold text-zinc-900 dark:text-white mb-4">
                About the Local AI Tool
              </h2>
              <p className="text-xs sm:text-sm text-zinc-600 dark:text-[#9B9BA6] leading-relaxed mb-6">
                {seo.introText}
              </p>
              
              <div 
                className="prose dark:prose-invert max-w-none text-xs sm:text-sm text-zinc-600 dark:text-[#9B9BA6] leading-relaxed space-y-4
                  prose-headings:text-zinc-900 dark:prose-headings:text-white prose-headings:font-bold prose-h2:text-base prose-h2:mt-6 prose-h2:mb-2"
                dangerouslySetInnerHTML={{ __html: seo.seoArticle }}
              />
            </div>

            {/* Structured FAQ Layout */}
            <div className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E]/40 p-6 sm:p-8 shadow-sm backdrop-blur-sm">
              <h2 className="text-xl font-bold text-zinc-900 dark:text-white mb-6">
                Frequently Asked Questions
              </h2>
              <div className="flex flex-col gap-4">
                {seo.faqs.map((faq, index) => (
                  <div key={index} className="border-b border-zinc-200 dark:border-[#2E2E35] pb-4 last:border-0 last:pb-0">
                    <h3 className="text-xs sm:text-sm font-bold text-zinc-950 dark:text-white mb-2 flex items-start gap-2">
                      <span className="text-[#8B78FF]">Q:</span>
                      {faq.question}
                    </h3>
                    <p className="text-xs text-zinc-600 dark:text-[#9B9BA6] leading-relaxed pl-5">
                      {faq.answer}
                    </p>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Features & Guides Sidebar */}
          <div className="lg:col-span-4 flex flex-col gap-6">
            
            {/* Features Card */}
            <div className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E]/40 p-6 shadow-sm backdrop-blur-sm flex flex-col gap-4">
              <h2 className="text-sm font-bold text-zinc-900 dark:text-white tracking-wider uppercase flex items-center gap-2">
                <span className="h-2 w-2 rounded-full bg-[#6D57EC]"></span>
                {seo.featuresTitle}
              </h2>
              <ul className="flex flex-col gap-3">
                {seo.features.map((feat, index) => (
                  <li key={index} className="flex items-start gap-2.5 text-xs text-zinc-600 dark:text-[#9B9BA6] leading-relaxed">
                    <Check className="h-4 w-4 text-[#8B78FF] shrink-0 mt-0.5" />
                    <span>{feat}</span>
                  </li>
                ))}
              </ul>
            </div>

            {/* Guide Card */}
            <div className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-white dark:bg-[#1A1A1E]/40 p-6 shadow-sm backdrop-blur-sm flex flex-col gap-4">
              <h2 className="text-sm font-bold text-zinc-900 dark:text-white tracking-wider uppercase flex items-center gap-2">
                <span className="h-2 w-2 rounded-full bg-[#6D57EC]"></span>
                {seo.guideTitle}
              </h2>
              <ol className="flex flex-col gap-4">
                {seo.guideSteps.map((step, index) => (
                  <li key={index} className="flex gap-3 text-xs text-zinc-600 dark:text-[#9B9BA6] leading-relaxed">
                    <span className="flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-[#6D57EC] text-[10px] font-bold text-white">
                      {index + 1}
                    </span>
                    <span>{step}</span>
                  </li>
                ))}
              </ol>
            </div>

            {/* Privacy Shield Info */}
            <div className="rounded-2xl border border-zinc-200 dark:border-[#2E2E35] bg-[#6D57EC]/5 p-5 border-dashed flex gap-3">
              <Info className="h-5 w-5 text-[#8B78FF] shrink-0" />
              <div className="flex flex-col gap-1">
                <span className="text-xs font-bold text-zinc-900 dark:text-white">100% Privacy Shield Enabled</span>
                <p className="text-[10px] text-zinc-600 dark:text-[#9B9BA6] leading-relaxed">
                  We collect $0 from subscriptions because we spend $0 on cloud compute servers. Your files never leaves this browser sandbox.
                </p>
              </div>
            </div>

          </div>
        </section>

      </main>

      {/* Footer navigation links */}
      <WorkspaceFooter />
    </div>
  );
}
