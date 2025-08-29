module.exports = {
  content: ["__site/index.html", "__site/**/*.html", "__site/_layout/*.html"],
  css: ["_css/style.css"],
  output: "__site/css/output.css",
  extractors: [
    {
      // tailwind needs a specific extractor
      extractor: (content) => content.match(/[A-Za-z0-9-_:\/]+/g) || [],
      extensions: ["html"],
    },
  ],
};
