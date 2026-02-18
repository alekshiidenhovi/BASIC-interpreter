<script setup lang="ts">
interface Props {
  path: string;
}
const { path: fullPath } = defineProps<Props>();
const pathParts = fullPath
  .split("/")
  .filter((part) => part !== "")
  .map((segment, index, arr) => ({
    label: segment.toUpperCase(),
    href: "/" + arr.slice(0, index + 1).join("/") + "/",
  }))
</script>

<template>
  <nav>
    <a href="/">Home</a>
    <template v-for="part in pathParts">
      <span>/</span>
      <a :href="part.href">{{ part.label }}</a>
    </template>
  </nav>
</template>

<style scoped>
nav {
  display: flex;
  align-items: center;
  justify-content: start;
  gap: 1rem;
}

a {
  color: inherit;
  text-decoration: none;
  font-size: inherit;
  outline: none;
  border: none;
  padding: 0;
}
</style>
