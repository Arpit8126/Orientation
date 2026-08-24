'use client';

import React, { useState, useRef, useEffect } from 'react';

interface BeforeAfterSliderProps {
  beforeUrl: string;
  afterUrl: string;
  className?: string;
}

export function BeforeAfterSlider({ beforeUrl, afterUrl, className = '' }: BeforeAfterSliderProps) {
  const [sliderPosition, setSliderPosition] = useState(50); // percentage (0 - 100)
  const [isDragging, setIsDragging] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const handleMove = (clientX: number) => {
    if (!containerRef.current) return;
    const rect = containerRef.current.getBoundingClientRect();
    const x = clientX - rect.left;
    const percentage = Math.max(0, Math.min(100, (x / rect.width) * 100));
    setSliderPosition(percentage);
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!isDragging) return;
    handleMove(e.clientX);
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (!isDragging) return;
    if (e.touches.length > 0) {
      handleMove(e.touches[0].clientX);
    }
  };

  useEffect(() => {
    const handleMouseUp = () => setIsDragging(false);
    window.addEventListener('mouseup', handleMouseUp);
    window.addEventListener('touchend', handleMouseUp);
    return () => {
      window.removeEventListener('mouseup', handleMouseUp);
      window.removeEventListener('touchend', handleMouseUp);
    };
  }, [isDragging]);

  return (
    <div
      ref={containerRef}
      className={`relative select-none overflow-hidden rounded-xl border border-[#2E2E35] bg-[#1A1A1E] cursor-ew-resize ${className}`}
      onMouseDown={(e) => {
        e.preventDefault();
        setIsDragging(true);
        handleMove(e.clientX);
      }}
      onTouchStart={() => setIsDragging(true)}
      onMouseMove={handleMouseMove}
      onTouchMove={handleTouchMove}
    >
      {/* Before Image (Left Side Visible, occupying 0 to sliderPosition) */}
      <img
        src={beforeUrl}
        alt="Before"
        className="pointer-events-none h-full w-full object-contain"
        draggable="false"
      />

      {/* After Image (Right Side Visible, clipped) */}
      <div
        className="absolute inset-0 pointer-events-none select-none overflow-hidden"
        style={{
          clipPath: `polygon(${sliderPosition}% 0, 100% 0, 100% 100%, ${sliderPosition}% 100%)`,
        }}
      >
        <img
          src={afterUrl}
          alt="After"
          className="h-full w-full object-contain"
          draggable="false"
        />
      </div>

      {/* Slider Handle Line */}
      <div
        className="absolute top-0 bottom-0 w-[2px] -ml-[1px] bg-[#6D57EC] shadow-[0_0_10px_rgba(109,87,236,0.6)] pointer-events-none"
        style={{ left: `${sliderPosition}%` }}
      >
        {/* Drag Circle Handle */}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 flex h-8 w-8 items-center justify-center rounded-full border border-[#2E2E35] bg-[#1A1A1E]/95 text-white shadow-lg backdrop-blur-md transition-transform duration-150 hover:scale-110 active:scale-95">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={2.5}
            stroke="currentColor"
            className="h-4 w-4 text-[#8B78FF] rotate-90"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"
            />
          </svg>
        </div>
      </div>

      {/* Before Badge */}
      <span className="absolute bottom-3 left-3 rounded-md bg-[#121214]/80 px-2.5 py-1 text-xs font-medium text-[#9B9BA6] backdrop-blur-sm border border-[#2E2E35] pointer-events-none">
        Before
      </span>

      {/* After Badge */}
      <span className="absolute bottom-3 right-3 rounded-md bg-[#6D57EC]/90 px-2.5 py-1 text-xs font-medium text-white backdrop-blur-sm border border-[#8B78FF]/30 pointer-events-none">
        Enhanced
      </span>
    </div>
  );
}
