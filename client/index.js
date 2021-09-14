import { createInertiaApp } from '@inertiajs/inertia-svelte'
import { InertiaProgress } from '@inertiajs/progress'
import './index.css'

InertiaProgress.init()

createInertiaApp({
  resolve: name => import(`./Pages/${name}.svelte.js`),
  setup({ el, App, props }) {
    new App({ target: el, props })
  },
})