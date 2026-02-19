import type { InjectionKey, Ref } from 'vue';

export const buttonMenuInjectionKey = Symbol('buttonMenuState') as InjectionKey<{
  selectedIndex: Ref<number>;
  setIndex: (val: number) => void;
}>

