import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Ignitr",
  description: "Flutter Ignitr a mini flutter MVC framework",
  cleanUrls: true,
  srcDir: "./src",
  base: "/docs/",
  markdown: {
    lineNumbers: true,
    defaultHighlightLang: "dart",
  },
  head: [
    [
      "link",
      {
        rel: "icon",
        type: "image/x-icon",
        href: "/images/favicon.png",
      },
    ],
    // [
    //   "script",
    //   {
    //     async: "true",
    //     src: "https://www.googletagmanager.com/gtag/js?id=G-HLWB1166W9",
    //   },
    // ],
    // [
    //   "script",
    //   {},
    //   [
    //     "window.dataLayer = window.dataLayer || [];",
    //     "function gtag(){dataLayer.push(arguments);}",
    //     "gtag('js', new Date());",
    //     "gtag('config', 'G-HLWB1166W9');",
    //   ].join("\n"),
    // ],
  ],
  themeConfig: {
    logo: "/images/logo.png",
    search: {
      provider: "local",
    },
    outline: [2, 4],
    socialLinks: [
      { icon: "github", link: "https://github.com/ignitr-dev/ignitr_cli" },
      { icon: "instagram", link: "https://www.instagram.com/iamspydey" },
    ],
    footer: {
      message: "Released under the MIT License.",
      copyright: `Copyright © 2021 - ${new Date().getFullYear()} All rights reserved by devsbuddy.com`,
    },
    nav: [
      {
        text: "Home",
        link: "/",
      },
      {
        text: "Docs",
        link: "/",
      },
    ],

    sidebar: [
      {
        text: "Examples",
        items: [{ text: "Introduction", link: "/introduction" }],
      },
    ],
  },
});
