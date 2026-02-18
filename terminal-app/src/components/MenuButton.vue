<script setup lang="ts">
interface Props {
  label: string;
  href: string;
  textCenter?: boolean;
}
const { label, href, textCenter } = defineProps<Props>();
</script>

<template>
  <a :href="href" :class="{ 'text-center': textCenter }">
    {{ label }}
  </a>
</template>

<style scoped>
a {
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
}
</style>
