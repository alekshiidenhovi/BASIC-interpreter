<script setup lang="ts">
interface Props {
  code: string;
}

const { code } = defineProps<Props>();
</script>


<template>
  <code>
    {{ code }}
  </code>
</template>

<style>
pre,
code {
  margin: 0;
  padding: 0;
}

code {
  border: 2px solid color-mix(in srgb, var(--sky-300), transparent 50%);
  color: var(--sky-300);
  padding: 1rem;
  border-radius: 4px;
  overflow-x: auto;
  line-height: 1.0;
  font-size: 1.25rem;
}
</style>
