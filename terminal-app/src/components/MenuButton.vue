<script setup lang="ts">
interface Props {
  buttonText: string;
  href: string;
}
const props = defineProps<Props>();
</script>

<template>
  <a :href="props.href">
    {{ props.buttonText }}
  </a>
</template>

<style>
a {
  text-decoration: none;
  border: 2px solid color-mix(in srgb, var(--sky-500), transparent 50%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.875rem 1.5rem;
  border-radius: 4px;
  color: var(--sky-600);
  font-size: 1.5rem;
  letter-spacing: 1px;
  width: 100%;
  text-transform: uppercase;
}
</style>
