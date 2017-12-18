import elm from "rollup-plugin-elm";
import copy from "rollup-plugin-copy";

export default {
  input: "src/index.js",
  output: {
    file: "dist/bundle.js",
    format: "es"
  },
  plugins: [
    elm({
      exclude: "elm_stuff/**"
    }),
    copy({
      "src/index.html": "dist/index.html",
      "assets": "dist/",
      verbose: true
    })
  ]
};
