<script setup lang="ts">
import { ref } from "vue";

type Mode = 'editor' | 'repl';
type Statement = {
  lineNumber: number;
  statement: string;
}

const selectedMode = ref<Mode>('editor');
const statements = ref<Statement[]>([{
  lineNumber: 10,
  statement: "PRINT \"HELLO WORLD\""
}, {
  lineNumber: 20,
  statement: "LET HELLO_VARIABLE = 10"
}, {
  lineNumber: 30,
  statement: "PRINT HELLO_VARIABLE"
},
{
  lineNumber: 40,
  statement: "END"
}]);
const printLines = ref<string[]>([]);

</script>

<template>
  <div class="editor-container">
    <div class="editor-mode-container">
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'editor' }"
        @click="selectedMode = 'editor'">Editor</button>
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'repl' }"
        @click="selectedMode = 'repl'">REPL</button>
    </div>
    <div class="editor-content">
      <div class="editor-statement" v-for="(statement, index) in statements" :key="index">
        <input v-model.number="statement.lineNumber" class="line-number-input" type="number" />
        <input v-model="statement.statement" class="statement-input"
          @keydown.enter="statements.push({ lineNumber: (statements[statements.length - 1]?.lineNumber || 0) + 10, statement: '' })" />
      </div>
    </div>
    <div class="editor-print-container">
      <p class="editor-print-line" v-for="(line, index) in printLines" :key="index">{{ line }}</p>
    </div>
  </div>
</template>

<style scoped>
.editor-container {
  display: grid;
  grid-template-rows: auto 1fr 1fr;
  border: 2px solid var(--sky-900);
}

.editor-container>*+* {
  border-top: 2px solid var(--sky-900);
}

.editor-mode-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
}

.editor-mode-container>*+* {
  border-left: 2px solid var(--sky-900);
}

.editor-mode-button {
  background-color: transparent;
  color: var(--sky-700);
  padding: 1.5rem;
  font-size: 1.5rem;
  cursor: pointer;
  text-transform: uppercase;
  border: none;
  letter-spacing: 3px;
}

.editor-mode-button:nth-child(1) {
  border-right: 2px solid var(--sky-900);
}

.selected-mode {
  color: var(--sky-500);
  font-weight: 700;
}

.editor-content,
.editor-print-container {
  padding: 0.5rem 0;
}

.editor-statement {
  font-size: 1.25rem;
  display: flex;
  gap: 1rem;
  padding: 0.25rem 0.75rem;
}

.line-number-input {
  background: transparent;
  border: none;
  color: var(--sky-600);
  width: 3rem;
  font-family: inherit;
  font-size: inherit;
  outline: none;
  -moz-appearance: textfield;
}

.line-number-input::-webkit-outer-spin-button,
.line-number-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.statement-input {
  background: transparent;
  border: none;
  color: var(--sky-400);
  flex: 1;
  font-family: inherit;
  font-size: inherit;
  outline: none;
  text-transform: uppercase;
}

.editor-print-line {
  color: var(--sky-200);
  font-size: 1rem;
  text-transform: uppercase;
  padding: 0.25rem 0.75rem;
}
</style>
