import proxy from 'http2-proxy';

/** @type {import("snowpack").SnowpackUserConfig } */
export default {
  mount: {
    // directory name: 'build directory'
    public: '/_/',
    client: '/_/',
  },
  plugins: [
    '@snowpack/plugin-svelte',
    '@snowpack/plugin-postcss'
  ],
  routes: [
    {
      match: 'routes',
      src: '.*',
      dest: (req, res) => {
        return proxy.web(req, res, {
          hostname: 'localhost',
          port: 8081,
        });
      },
    },
  ],
  optimize: {
    /* Example: Bundle your final build: */
    // "bundle": true,
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {
    tailwindConfig: './tailwind.config.js',
    port: 3000
  },
  buildOptions: {
    /* ... */
  },
};
