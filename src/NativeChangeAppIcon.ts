import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  getIcon(): Promise<string>;
  changeIcon(name?: string | null): Promise<string>;
  changeIconSilently(name?: string | null): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ChangeAppIcon');
