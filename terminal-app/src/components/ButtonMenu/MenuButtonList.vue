<script setup lang="ts">
import { ref, provide } from 'vue';
import { buttonMenuInjectionKey } from './injectionKey';
import { useKeyboardShortcut } from "@/composables/useKeyboardShortcuts";
import { type NormalizedShortcutKey, setScope } from "@/stores/keyboardShortcuts";

setScope("menu");

interface Props {
  initialIndex: number;
  path: string;
}

const props = defineProps<Props>();

const selectedIndex = ref(props.initialIndex);
const menuContainerRef = ref<HTMLDivElement | null>(null);

provide(buttonMenuInjectionKey, {
  selectedIndex,
  setIndex: (val: number) => (selectedIndex.value = val)
});

const getButtonCount = () => menuContainerRef.value?.querySelectorAll('.menu-button-item').length || 0;
const selectNextButton = () => selectedIndex.value = (selectedIndex.value + 1) % getButtonCount();
const selectPrevButton = () => selectedIndex.value = (selectedIndex.value - 1 + getButtonCount()) % getButtonCount();
const pressButton = () => {
  const selectedEl = menuContainerRef.value?.querySelector('[data-selected="true"]') as HTMLButtonElement
  selectedEl?.click();
};
const navigateToPage = (currentPath: string) => {
  const newPath = currentPath.replace(/\/$/, '').split('/').slice(0, -1).join('/') || '/';
  window.location.href = newPath;
};

useKeyboardShortcut({
  key: "ArrowDown" as NormalizedShortcutKey,
  handler: selectNextButton,
  scope: "menu",
  description: "Select next button",
  useRawKey: true,
});

useKeyboardShortcut({
  key: "ArrowUp" as NormalizedShortcutKey,
  handler: selectPrevButton,
  scope: "menu",
  description: "Select previous button",
  useRawKey: true,
});

useKeyboardShortcut({
  key: "Enter" as NormalizedShortcutKey,
  handler: pressButton,
  scope: "menu",
  description: "Press button",
  useRawKey: true,
});

if (props.path !== "/") {
  useKeyboardShortcut({
    key: "Escape" as NormalizedShortcutKey,
    handler: () => navigateToPage(props.path),
    scope: "menu",
    description: "Navigate to previous page",
    useRawKey: true,
  });
}
</script>

<template>
  <div ref="menuContainerRef" class="menu-button-list">
    <slot />
  </div>
</template>

<style scoped>
.menu-button-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  width: 100%;
}
</style>
