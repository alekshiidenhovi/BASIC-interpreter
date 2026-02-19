<script setup lang="ts">
import { inject, computed } from 'vue';
import { buttonMenuInjectionKey } from './injectionKey';

interface Props {
  label: string;
  href: string;
  index: number;
  textCenter?: boolean;
  openInNewTab?: boolean;
}
const { label, href, textCenter, index, openInNewTab } = defineProps<Props>();

const menuListState = inject(buttonMenuInjectionKey);

const isSelected = computed(() => menuListState?.selectedIndex.value === index);

const handleHover = () => {
  menuListState?.setIndex(index);
}
</script>

<template>
  <a :href="href" :class="['menu-button-item', { 'text-center': textCenter, 'selected': isSelected }]"
    :target="openInNewTab ? '_blank' : '_self'" :data-selected="isSelected" @mouseover="handleHover">
    {{ label }}
  </a>
</template>

<style scoped>
.menu-button-item {
  color: var(--sky-400);
  background-color: color-mix(in srgb, var(--slate-900) 50%, transparent);
  border-radius: 2px;
  padding: 1.25rem 2rem;
  text-decoration: none;
  text-transform: uppercase;
  font-size: 1.25rem;
  border: 2px solid var(--sky-400);
  width: 100%;
  display: flex;
  align-items: center;
}

.text-center {
  justify-content: center;
  text-align: center;
}

.selected {
  background-color: color-mix(in srgb, var(--sky-800) 50%, transparent);
}
</style>
