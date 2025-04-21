export interface TootiPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
