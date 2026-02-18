<script setup lang="ts">
import { Icon } from "@iconify/vue";
interface Props {
  prevIndex: number | null;
  nextIndex: number | null;
}
const props = defineProps<Props>();
</script>

<template>
  <hr />
  <nav>
    <div v-if="props.prevIndex" class="prev">
      <Icon :icon="'lucide:chevron-left'" class="icon" />
      <a :href="`/tutorial/${props.prevIndex}`">Prev</a>
    </div>
    <div v-if="props.nextIndex" class="next">
      <a :href="`/tutorial/${props.nextIndex}`">Next</a>
      <Icon :icon="'lucide:chevron-right'" class="icon" />
    </div>
  </nav>
</template>

<style scoped>
nav {
  display: flex;
  align-items: center;
  gap: 1rem;
  text-transform: uppercase;
  width: 100%;
  color: color-mix(in srgb, var(--sky-200) 80%, var(--slate-900));
}

a {
  color: inherit;
  text-decoration: none;
  font-size: 1rem;
}


hr {
  border: none;
  height: 2px;
  background-color: color-mix(in srgb, var(--sky-200) 80%, var(--slate-900));
}

.prev,
.next {
  display: flex;
  align-items: center;
}

.prev {
  justify-self: left;
}

.next {
  justify-self: right;
  margin-left: auto;
}

.icon {
  width: 1.25rem;
  height: 1.25rem;
  color: inherit;
}
</style>
