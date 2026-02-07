<script setup lang="ts">
import { Icon } from "@iconify/vue";
import { ref } from "vue";

interface Props {
  code: string;
}

const { code } = defineProps<Props>();
const state = ref<"default" | "copied">("default");
const selectIcon = () => {
  if (state.value === "default") {
    return "lucide:clipboard";
  } else {
    return "lucide:clipboard-check";
  }
}
const handleCopy = async () => {
  try {
    await navigator.clipboard.writeText(code);
    state.value = "copied";
    setTimeout(() => {
      state.value = "default";
    }, 1250);
  } catch (err) {
    console.error("Failed to copy text: ", err);
  }
};
</script>


<template>
  <code>
    <span>
      {{ code }}
    </span>
    <Icon :icon="selectIcon()" @click="handleCopy" class="icon" />
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
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.icon {
  color: color-mix(in srgb, var(--sky-300), transparent 25%);
  width: 1.25rem;
  height: 1.25rem;
  cursor: pointer;
}
</style>
