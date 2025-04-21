import { WebPlugin } from '@capacitor/core';

import type { TootiPlugin } from './definitions';

export class TootiWeb extends WebPlugin implements TootiPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
