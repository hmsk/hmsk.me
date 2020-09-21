import sass from "rollup-plugin-sass";
import elm from "rollup-plugin-elm";
import copy from "rollup-plugin-copy";
import serve from "rollup-plugin-serve";
import svgSprite from "rollup-plugin-svg-sprite";
import { terser } from "rollup-plugin-terser";

const plugins = [
  svgSprite({
    outputFolder: 'dist',
    minify: false
  }),
  sass({
    insert: true
  }),
  elm({
    exclude: "elm_stuff/**",
    compiler: {
      optimize: process.env.BUILD === "production",
      debug: process.env.BUILD !== "production"
    }
  }),
  terser(),
  copy({
    targets: [
      { src: "src/index.html", dest: "dist" },
      { src: "assets/*", dest: "dist" }
    ],
    verbose: true
  })
];

if (process.env.BUILD !== "production") plugins.push(serve("dist"));

export default {
  input: "src/index.js",
  output: {
    file: "dist/bundle.js",
    format: "iife"
  },
  watch: {
    include: "src/*"
  },
  plugins
};
