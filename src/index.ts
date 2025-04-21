import { registerPlugin } from '@capacitor/core';

import type { TootiPlugin } from './definitions';

const Tooti = registerPlugin<TootiPlugin>('Tooti', {
  web: () => import('./web').then((m) => new m.TootiWeb()),
});

export * from './definitions';
export { Tooti };
