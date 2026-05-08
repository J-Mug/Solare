/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import { Folder, FileCode, CheckCircle2, Layers, Cpu, Code2, Globe, Monitor, Terminal, Activity, Package } from 'lucide-react';
import { motion } from 'motion/react';

export default function App() {
  const structure = [
    { name: 'core/', items: ['auth', 'drive', 'firebase', 'db', 'sync', 'platform'] },
    { name: 'features/', items: ['notes', 'branch_tree', 'characters', 'wiki', 'episodes', 'moodboard', 'timeline', 'collaboration'] },
    { name: 'shared/', items: ['widgets', 'utils'] },
  ];

  const packages = [
    'google_sign_in', 'googleapis', 'firebase_core', 'drift', 'appflowy_editor', 'flutter_riverpod', 'go_router'
  ];

  return (
    <div className="flex h-screen bg-editorial-bg text-editorial-dark font-sans overflow-hidden">
      {/* Left Navigation Rail (Technical Sidebar) */}
      <aside className="w-64 bg-editorial-sidebar text-[#E4E3E0] flex flex-col justify-between p-8">
        <div>
          <motion.div 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="mb-12"
          >
            <h1 className="text-3xl tracking-tighter font-serif italic mb-1">Solare</h1>
            <p className="text-[10px] uppercase tracking-[0.2em] opacity-50">Cross-Platform Engine</p>
          </motion.div>
          
          <nav className="space-y-8">
            <section>
              <h3 className="text-[11px] uppercase tracking-[0.2em] opacity-40 mb-4">Core Systems</h3>
              <ul className="space-y-3 font-mono text-xs">
                <li className="flex items-center gap-2 opacity-70">auth_service.dart</li>
                <li className="flex items-center gap-2 text-editorial-accent">
                  <div className="w-1.5 h-1.5 rounded-full bg-editorial-accent"></div> firebase_config.dart
                </li>
                <li className="opacity-70">drive_service.dart</li>
                <li className="opacity-70">app_database.dart</li>
              </ul>
            </section>

            <section>
              <h3 className="text-[11px] uppercase tracking-[0.2em] opacity-40 mb-4">Feature Modules</h3>
              <ul className="space-y-3 font-mono text-xs">
                <li className="opacity-70 italic">/notes_editor</li>
                <li className="opacity-70 italic">/branch_tree</li>
                <li className="opacity-70 italic">/wiki_atlas</li>
              </ul>
            </section>
          </nav>
        </div>

        <div className="pt-8 border-t border-white/10">
          <div className="flex items-center justify-between mb-4">
            <span className="text-[10px] uppercase tracking-widest opacity-50">Cloud Status</span>
            <span className="text-[10px] bg-editorial-accent/20 text-editorial-accent px-2 py-0.5 rounded">ACTIVE</span>
          </div>
          <div className="flex flex-col gap-2 opacity-40">
            <div className="flex items-center gap-2 text-[10px] font-mono leading-tight">
              <Monitor size={10} /> Target: Windows x64
            </div>
            <div className="flex items-center gap-2 text-[10px] font-mono leading-tight">
              <Globe size={10} /> Deployment: GitHub Pages
            </div>
          </div>
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col overflow-hidden">
        {/* Header Bar */}
        <header className="h-20 border-b border-editorial-border flex items-center justify-between px-10 bg-white/50 backdrop-blur-sm shrink-0">
          <div className="flex items-center gap-8">
            <div className="text-sm uppercase tracking-widest font-bold flex items-center gap-2">
              <span className="w-2 h-2 bg-orange-500 rounded-full animate-pulse"></span>
              Project: Solare Workspace
            </div>
            <div className="h-4 w-px bg-editorial-border"></div>
            <div className="flex -space-x-2">
              <div className="w-8 h-8 rounded-full bg-[#D1D1C4] border-2 border-editorial-bg flex items-center justify-center text-[10px] font-bold">JD</div>
              <div className="w-8 h-8 rounded-full bg-[#A3A392] border-2 border-editorial-bg flex items-center justify-center text-[10px] font-bold text-white">IA</div>
              <div className="w-8 h-8 rounded-full border-2 border-editorial-bg border-dashed flex items-center justify-center text-[14px] opacity-40 bg-slate-100">+</div>
            </div>
          </div>
          <div className="flex gap-4">
            <button className="px-5 py-2 border border-editorial-dark text-[11px] uppercase tracking-widest font-bold hover:bg-editorial-dark hover:text-white transition-all duration-300">
              Inspector
            </button>
            <button className="px-5 py-2 bg-editorial-dark text-white text-[11px] uppercase tracking-widest font-bold hover:bg-editorial-accent transition-colors duration-300 shadow-lg shadow-black/10">
              Compile EXE
            </button>
          </div>
        </header>

        {/* Content Grid */}
        <div className="flex-1 p-10 grid grid-cols-12 gap-8 overflow-y-auto">
          {/* Big Editorial Block (Branch Tree) */}
          <motion.div 
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="col-span-12 lg:col-span-8 bg-white border border-editorial-border p-8 flex flex-col relative group"
          >
            <span className="text-[11px] uppercase tracking-[0.3em] text-editorial-accent font-bold mb-4 flex items-center gap-2">
              <Activity size={14} /> Visual Branching
            </span>
            <h2 className="text-6xl font-serif leading-[0.9] tracking-tight mb-8">
              Structure of <br /><span className="italic">Narrative Logic</span>
            </h2>
            
            {/* Flowchart Placeholder */}
            <div className="flex-1 min-h-[300px] border border-dashed border-[#D1D1C4] rounded-sm p-6 relative bg-[#FAF9F6] overflow-hidden">
              <div className="absolute top-10 left-10 w-32 h-16 bg-white border border-editorial-dark flex items-center justify-center text-[11px] font-mono shadow-[4px_4px_0px_#C4B491] z-10 transition-transform group-hover:translate-x-1 group-hover:translate-y-1">Root: Project</div>
              <div className="absolute top-28 left-48 w-32 h-16 bg-white border border-editorial-dark flex items-center justify-center text-[11px] font-mono z-10">/lib/core</div>
              <div className="absolute top-10 left-80 w-32 h-16 bg-white border border-editorial-dark flex items-center justify-center text-[11px] font-mono z-10">/lib/features</div>
              
              <svg className="absolute inset-0 w-full h-full opacity-20 pointer-events-none">
                <path d="M160 65 L200 120" stroke="black" fill="none" strokeWidth="1" />
                <path d="M160 65 L320 65" stroke="black" fill="none" strokeWidth="1" />
                <path d="M120 120 L80 160" stroke="#C4B491" fill="none" strokeWidth="1" strokeDasharray="4 4" />
              </svg>
              
              <div className="absolute bottom-4 right-4 opacity-10 scale-150 rotate-12">
                <Package size={120} />
              </div>
            </div>
            
            <div className="mt-6 flex justify-between items-center text-[11px] opacity-60 font-mono">
              <div className="flex items-center gap-4">
                <span className="flex items-center gap-1"><Terminal size={12} /> flutter_flow_chart ^0.0.9</span>
                <span className="flex items-center gap-1"><Cpu size={12} /> Riverpod ^2.5.1</span>
              </div>
              <span className="font-bold">Active System Nodes: 17</span>
            </div>
          </motion.div>

          {/* Secondary Column */}
          <div className="col-span-12 lg:col-span-4 flex flex-col gap-8">
            {/* Status Card */}
            <motion.div 
              initial={{ opacity: 0, x: 30 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.2 }}
              className="flex-1 bg-editorial-dark text-white p-8 flex flex-col"
            >
              <div className="flex justify-between items-start mb-6">
                <div className="w-12 h-12 bg-editorial-accent rounded-full flex items-center justify-center text-editorial-dark">
                  <CheckCircle2 size={24} />
                </div>
                <span className="text-[10px] border border-white/20 px-2 py-1 uppercase tracking-widest opacity-60">Status: Completed</span>
              </div>
              <h3 className="text-3xl font-serif italic mb-2">Workspace Assembled</h3>
              <p className="text-xs leading-relaxed opacity-70 mb-6">
                Your Flutter project structure is complete. Logic for Auth, Riverpod Routing, SQLite + Drive + Firebase Sync Engine is set up. You can now download the `.zip` from AI Studio to run it locally.
              </p>
              
              <div className="mt-auto space-y-4">
                <div className="flex items-center justify-between text-[11px] border-b border-white/10 pb-2">
                  <span className="opacity-50 font-mono">Dependencies</span>
                  <span className="font-bold">17 Installed</span>
                </div>
                <div className="flex items-center justify-between text-[11px] border-b border-white/10 pb-2">
                  <span className="opacity-50 font-mono">Structure</span>
                  <span className="font-bold">24 Folders</span>
                </div>
              </div>
            </motion.div>

            {/* Quick Packages Card */}
            <motion.div 
              initial={{ opacity: 0, x: 30 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.3 }}
              className="h-48 bg-editorial-accent p-6 flex flex-col justify-between group cursor-pointer"
            >
               <div className="flex justify-between items-start">
                 <span className="text-[11px] font-bold uppercase tracking-widest text-editorial-dark flex items-center gap-1">
                   <Layers size={14} /> Package Registry
                 </span>
                 <span className="font-mono text-[10px] text-editorial-dark opacity-60 italic">manifest.yaml</span>
               </div>
               <div>
                 <h4 className="text-xl font-bold tracking-tighter text-editorial-dark leading-none mb-1 group-hover:translate-x-1 transition-transform">
                   Native SDK Integration
                 </h4>
                 <div className="flex flex-wrap gap-1 mt-3">
                   {packages.slice(0, 4).map((p, i) => (
                     <span key={i} className="text-[9px] bg-black/5 px-2 py-0.5 rounded font-mono">
                       {p.split('_')[0]}
                     </span>
                   ))}
                   <span className="text-[9px] opacity-40 font-mono">...</span>
                 </div>
               </div>
            </motion.div>
          </div>
        </div>

        {/* Timeline Footer */}
        <footer className="h-24 bg-white border-t border-editorial-border flex items-center px-10 shrink-0">
          <div className="text-[11px] uppercase tracking-widest font-bold w-32 shrink-0 flex items-center gap-2">
            <Code2 size={14} /> Dev Stages
          </div>
          <div className="flex-1 flex items-center relative h-full">
            <div className="absolute w-full h-[1px] bg-editorial-border"></div>
            <div className="flex justify-between w-full relative">
              <div className="flex flex-col items-center group">
                <div className="w-2 h-2 rounded-full bg-editorial-dark mb-2 z-10 group-hover:scale-125 transition-transform"></div>
                <span className="text-[9px] font-mono opacity-50 uppercase">Define</span>
              </div>
              <div className="flex flex-col items-center group">
                <div className="w-2 h-2 rounded-full bg-editorial-dark mb-2 z-10 group-hover:scale-125 transition-transform"></div>
                <span className="text-[9px] font-mono opacity-50 uppercase">Scaffold</span>
              </div>
              <div className="flex flex-col items-center">
                <div className="w-2 h-2 rounded-full bg-editorial-dark mb-2 z-10 group-hover:scale-125 transition-transform"></div>
                <span className="text-[9px] font-mono opacity-50 uppercase">Logic</span>
              </div>
              <div className="flex flex-col items-center opacity-30">
                <div className="w-2 h-2 rounded-full bg-editorial-dark mb-2 z-10 group-hover:scale-125 transition-transform"></div>
                <span className="text-[9px] font-mono opacity-50 uppercase">Sync</span>
              </div>
              <div className="flex flex-col items-center">
                <div className="w-2 h-2 rounded-full bg-editorial-accent mb-2 z-10 scale-150 ring-4 ring-editorial-accent/20"></div>
                <span className="text-[9px] font-mono font-bold uppercase">Ready</span>
              </div>
            </div>
          </div>
          <div className="w-48 text-right">
            <span className="text-[11px] font-mono opacity-40 italic">Structural Sync: Complete</span>
          </div>
        </footer>
      </main>
    </div>
  );
}

