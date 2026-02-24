<script setup lang="ts">
import { Icon } from "@iconify/vue";
import type { Statement } from "@/types";

interface Props {
  replInput: string
  replOutputs: Statement[]
  resetReplContext: () => void
  handleReplInput: (event: InputEvent) => void
}

const { replInput, replOutputs, resetReplContext, handleReplInput } = defineProps<Props>();
</script>

<template>
  <div class="repl-print-container">
    <div class="repl-print-line-container" v-for="statement in replOutputs" :key="statement.id">
      <p class="repl-print-code" :class="{ 'repl-print-code-pending': statement.printOutput?.pending }">{{
        statement.printOutput?.pending ? '...' : '>' }} {{ statement.code }}</p>
      <p v-if="statement.printOutput?.ok === true && !statement.printOutput?.pending && statement.printOutput.output.length > 0"
        class="repl-print-output">
        {{ statement.printOutput.output }}</p>
      <p v-if="statement.printOutput?.ok === false" class="repl-print-output repl-print-line-error">{{
        statement.printOutput.error
      }}</p>
    </div>
  </div>
  <div class="bottom-row-container">
    <div type="text" class="repl-input-container">
      <span class="repl-prompt">$</span>
      <input :value="replInput" @input="handleReplInput" class="repl-input" />
    </div>
    <button class="icon-container" @click="resetReplContext">
      <Icon class="icon" :icon="'lucide:refresh-cw'" />
    </button>
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

.repl-print-code-pending {
  color: var(--sky-500);
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
  display: flex;
  align-items: center;
  font-size: 1rem;
  line-height: 1;
  padding: 1rem;
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
  display: grid;
  grid-template-columns: 1fr auto;
}

.icon-container {
  background-color: transparent;
  border: none;
  padding: 1rem;
  cursor: pointer;
}

.icon {
  width: 1.25rem;
  height: 1.25rem;
  color: var(--sky-500);
}
</style>
