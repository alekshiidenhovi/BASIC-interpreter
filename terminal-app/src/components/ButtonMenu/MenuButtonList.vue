<script setup lang="ts">
import { ref, provide, onMounted } from 'vue';
import { buttonMenuInjectionKey } from './injectionKey';
import { useKeyboardShortcut } from "@/composables/useKeyboardShortcuts";
import { normalizeKey, setScope } from "@/stores/keyboardShortcuts";

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
  key: normalizeKey({ key: "ArrowDown", hasCtrlOrMetaKey: false }),
  handler: selectNextButton,
  scope: "menu",
  description: "Select next button",
});

useKeyboardShortcut({
  key: normalizeKey({ key: "ArrowUp", hasCtrlOrMetaKey: false }),
  handler: selectPrevButton,
  scope: "menu",
  description: "Select previous button",
});

useKeyboardShortcut({
  key: normalizeKey({ key: "Enter", hasCtrlOrMetaKey: false }),
  handler: pressButton,
  scope: "menu",
  description: "Press button",
});

if (props.path !== "/") {
  useKeyboardShortcut({
    key: normalizeKey({ key: "Escape", hasCtrlOrMetaKey: false }),
    handler: () => navigateToPage(props.path),
    scope: "menu",
    description: "Navigate to previous page",
  });
}

onMounted(() => {
  setScope("menu");
})
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
