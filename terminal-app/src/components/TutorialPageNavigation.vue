<script setup lang="ts">
import { Icon } from "@iconify/vue";
import { useKeyboardShortcut } from "@/composables/useKeyboardShortcuts";
import { normalizeKey } from "@/stores/keyboardShortcuts";

interface Props {
  prevIndex: number | null;
  nextIndex: number | null;
}

const props = defineProps<Props>();
defineOptions({
  inheritAttrs: false,
})

if (props.prevIndex) {
  useKeyboardShortcut({
    key: normalizeKey({ key: "ArrowLeft", hasCtrlOrMetaKey: true }),
    handler: () => window.location.href = `/tutorial/${props.prevIndex}`,
    scope: "global",
    description: "Previous tutorial",
  });
}

if (props.nextIndex) {
  useKeyboardShortcut({
    key: normalizeKey({ key: "ArrowRight", hasCtrlOrMetaKey: true }),
    handler: () => window.location.href = `/tutorial/${props.nextIndex}`,
    scope: "global",
    description: "Next tutorial",
  });
}
</script>

<template>
  <hr />
  <nav v-bind="$attrs">
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
