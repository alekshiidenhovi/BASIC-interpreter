<script setup lang="ts">
import { ref, onMounted } from "vue";
import { Icon } from "@iconify/vue";

type Line = {
  id: string
  inputCode: string
  printOutput?: string
}

const replLines = ref<Line[]>([]);
const replInput = ref<string>("");

const executeReplCommand = () => {
  const inputCode = replInput.value;
  replLines.value.push({
    id: Date.now().toString(),
    inputCode,
  });
  replInput.value = "";
}

const resetRepl = () => {
  replLines.value = [];
  replInput.value = "";
}

onMounted(() => {
  const input = document.querySelector(".repl-input") as HTMLInputElement;
  input.focus();
})

</script>

<template>
  <div class="repl-print-container">
    <div class="repl-print-line-container" v-for="line in replLines" :key="line.id">
      <p class="repl-print-code">> {{ line.inputCode }}</p>
      <p v-if="line.printOutput" class="repl-print-output">{{ line.printOutput }}</p>
    </div>
  </div>
  <div class="bottom-row-container">
    <div type="text" class="repl-input-container">
      <span class="repl-prompt">$</span>
      <input v-model="replInput" @keydown.enter="executeReplCommand" class="repl-input" />
    </div>
    <div class="icon-container" @click="resetRepl">
      <Icon class="icon" :icon="'lucide:refresh-cw'" />
    </div>
  </div>
</template>

<style scoped>
.repl-print-container {
  padding: 0.5rem 0;
  overflow-y: auto;
}

.repl-print-line-container {
  font-size: 1rem;
  text-transform: uppercase;
  padding: 0.25rem 0.75rem;
}

.repl-print-code {
  color: var(--sky-200);
}

.repl-print-output {
  color: var(--sky-400);
}

.repl-input-container {
  color: var(--sky-400);
  height: 3rem;
  display: flex;
  align-items: center;
  padding: 0.75rem 0.75rem;
  gap: 0.5rem;
  flex-grow: 1;
  border-right: 2px solid var(--sky-900);
}

.repl-input {
  background: transparent;
  border: none;
  color: var(--sky-400);
  font-family: inherit;
  font-size: inherit;
  outline: none;
  text-transform: uppercase;
}

.bottom-row-container {
  display: flex;
  align-items: center;
}

.icon-container {
  height: 3rem;
  width: 3rem;
  padding: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.icon {
  color: var(--sky-700);
}
</style>
