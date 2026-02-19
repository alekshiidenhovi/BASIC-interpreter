<script setup lang="ts">
import { ref, onMounted, onUnmounted, provide, nextTick } from 'vue';
import { buttonMenuInjectionKey } from './injectionKey';

interface Props {
  initialIndex: number;
}

const props = defineProps<Props>();

const selectedIndex = ref(props.initialIndex);
const menuContainer = ref<HTMLDivElement | null>(null);

provide(buttonMenuInjectionKey, {
  selectedIndex,
  setIndex: (val: number) => (selectedIndex.value = val)
});

const handleKeyDown = (e: KeyboardEvent) => {
  const buttons = menuContainer.value?.querySelectorAll('.menu-button-item') as NodeListOf<HTMLButtonElement>;
  const buttonCount = buttons.length || 0;
  if (buttonCount === 0) {
    console.error('No menu buttons found');
    return;
  }

  if (e.key === 'ArrowDown') {
    e.preventDefault();
    selectedIndex.value = (selectedIndex.value + 1) % buttonCount;
  } else if (e.key === 'ArrowUp') {
    e.preventDefault();
    selectedIndex.value = (selectedIndex.value - 1 + buttonCount) % buttonCount;
  } else if (e.key === "Escape") {
    e.preventDefault();
    window.location.href = "/";
  } else if (e.key === 'Enter') {
    const selectedEl = menuContainer.value?.querySelector('[data-selected="true"]') as HTMLElement;
    selectedEl?.click();
  }
};

onMounted(async () => {
  await nextTick();
  window.addEventListener('keydown', handleKeyDown);
});

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyDown);
});
</script>

<template>
  <div ref="menuContainer" class="menu-button-list">
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
