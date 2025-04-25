import { registerPlugin } from '@capacitor/core';

import type { TootiPlugin } from './definitions';

const Tooti = registerPlugin<TootiPlugin>('Tooti');

export * from './definitions';
export { Tooti };
