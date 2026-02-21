<script setup lang="ts">
import { ref, onMounted } from "vue";
import { Icon } from "@iconify/vue";
import type { Statement } from "@/types";

const replOutputs = ref<Statement[]>([]);
const replInput = ref<string>("");

const executeReplCommand = () => {
  const codeInput = replInput.value;
  const inputId = window.crypto.randomUUID();

  if (!window.interpretReplLine) {
    throw new Error("Interpreter not loaded");
  }

  const result = window.interpretReplLine(codeInput);
  if (result.ok === false) {
    console.error(result.error);
  }

  replOutputs.value.push({
    id: inputId,
    code: codeInput,
    printOutput: result,
  });
  replInput.value = "";
}

const resetRepl = () => {
  if (!window.resetReplContext) {
    throw new Error("Interpreter not loaded");
  }
  window.resetReplContext();
  replOutputs.value = [];
  replInput.value = "";

  const replInputContainer = document.querySelector(".repl-input") as HTMLInputElement;
  replInputContainer.focus();
}

onMounted(() => {
  const replInputContainer = document.querySelector(".repl-input") as HTMLInputElement;
  replInputContainer.focus();
})

</script>

<template>
  <div class="repl-print-container">
    <div class="repl-print-line-container" v-for="statement in replOutputs" :key="statement.id">
      <p class="repl-print-code">> {{ statement.code }}</p>
      <p v-if="statement.printOutput?.ok === true && statement.printOutput.output.length > 0" class="repl-print-output">
        {{ statement.printOutput.output }}</p>
      <p v-if="statement.printOutput?.ok === false" class="repl-print-output repl-print-line-error">{{
        statement.printOutput.error
        }}</p>
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
  text-transform: uppercase;
  padding: 0.25rem 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.repl-print-code {
  color: var(--sky-200);
  font-size: 1rem;
}

.repl-print-output {
  color: var(--sky-400);
  font-size: 0.875rem;
}

.repl-print-line-error {
  color: var(--red-600);
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
