export interface TootiPlugin {
  echo(options: { value: string,fromGallery:string}): Promise<{ value: string }>;
}
