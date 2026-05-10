<template>
  <NuxtRouteAnnouncer />
  <div
    class="min-h-screen bg-linear-to-b from-slate-950 via-slate-900 to-slate-950 text-slate-100"
  >
    <main
      class="mx-auto flex min-h-screen w-full max-w-4xl items-center px-6 py-16"
    >
      <section
        class="w-full rounded-2xl border border-white/10 bg-white/5 p-8 shadow-2xl shadow-cyan-900/20 backdrop-blur"
      >
        <p
          class="mb-3 inline-flex items-center rounded-full border border-cyan-300/30 bg-cyan-300/10 px-3 py-1 text-xs font-semibold uppercase tracking-wider text-cyan-200"
        >
          Ignitr v0.1.5
        </p>

        <h1 class="text-3xl font-bold leading-tight md:text-4xl">
          A mini Flutter framework to kickstart any project with ease.
        </h1>

        <p class="mt-4 max-w-2xl text-sm leading-6 text-slate-300 md:text-base">
          Ignitr is a mini flutter framework that uses modular structure for
          your apps, it comes with some awesome features out of the box.
        </p>

        <div class="mt-8 flex flex-wrap items-center gap-3">
          <a
            href="https://pub.dev/packages/ignitr_cli"
            rel="noreferrer"
            target="_blank"
            class="inline-flex items-center rounded-lg bg-cyan-400 px-4 py-2 text-sm font-semibold text-slate-950 shadow-lg shadow-cyan-900/30 transition duration-200 hover:-translate-y-0.5 hover:bg-cyan-300"
          >
            View on pub.dev
          </a>
          <a
            href="https://github.com/ignitr-dev/ignitr_cli"
            rel="noreferrer"
            target="_blank"
            class="inline-flex items-center rounded-lg border border-slate-500/70 bg-slate-900/50 px-4 py-2 text-sm font-semibold text-slate-200 transition duration-200 hover:-translate-y-0.5 hover:border-slate-300 hover:text-white"
          >
            GitHub
          </a>
          <a
            href="/docs/"
            class="inline-flex items-center rounded-lg border border-cyan-300/40 bg-cyan-400/10 px-4 py-2 text-sm font-semibold text-cyan-200 transition duration-200 hover:-translate-y-0.5 hover:border-cyan-200 hover:bg-cyan-300/20 hover:text-cyan-100"
          >
            Documentation
          </a>
        </div>

        <div class="mt-8 grid gap-3 sm:grid-cols-3">
          <div class="rounded-lg border border-white/10 bg-black/20 p-4">
            <p class="text-sm font-semibold text-white">Easy to Start</p>
            <p class="mt-1 text-xs text-slate-300">
              Kickstart your flutter app development with ease.
            </p>
          </div>
          <div class="rounded-lg border border-white/10 bg-black/20 p-4">
            <p class="text-sm font-semibold text-white">Modular Design</p>
            <p class="mt-1 text-xs text-slate-300">
              Ignitr uses Modular pattern for the app structure.
            </p>
          </div>
          <div class="rounded-lg border border-white/10 bg-black/20 p-4">
            <p class="text-sm font-semibold text-white">Command Line</p>
            <p class="mt-1 text-xs text-slate-300">
              Comes with powerfull commands to easily generate files
            </p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>
