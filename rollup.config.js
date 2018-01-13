import resolve from 'rollup-plugin-node-resolve';
import commonjs from "rollup-plugin-commonjs";
import sass from "rollup-plugin-sass";
import elm from "rollup-plugin-elm";
import copy from "rollup-plugin-copy";

export default {
  input: "src/index.js",
  output: {
    file: "dist/bundle.js",
    format: "es"
  },
  watch: {
    include: "src/*"
  },
  plugins: [
    resolve(),
    sass({
      insert: true
    }),
    elm({
      exclude: "elm_stuff/**",
      compiler: {
        debug: process.env.BUILD !== "production"
      }
    }),
    commonjs({
      extensions: [".js", ".elm"]
    }),
    copy({
      "src/index.html": "dist/index.html",
      "assets": "dist/",
      verbose: true
    })
  ]
};
