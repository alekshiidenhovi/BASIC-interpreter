<script setup lang="ts">
import { ref, nextTick } from "vue";
import { Icon } from "@iconify/vue";
import type { OutputMode, Statement, IndexedResult } from "@/types";


interface Props {
  interpreterOutputMode: OutputMode
  toggleInterpreterOutputMode: () => void
  updateCode: (event: InputEvent, rowNumber: number) => void
  runCode: () => void
  statements: Statement[]
  programResults: IndexedResult<string[]> | undefined
}
const { interpreterOutputMode, toggleInterpreterOutputMode, runCode, statements, programResults, updateCode } = defineProps<Props>();

/** Track the desired cursor column across vertical movements */
const desiredColumnNumber = ref<number | null>(null);

const handleArrowLeft = (event: KeyboardEvent, rowNumber: number) => {
  const input = event.target as HTMLInputElement;
  const columnNumber = input.selectionStart ?? 0;
  const isFirstColumn = columnNumber === 0;
  const isNotFirstRow = rowNumber > 0;
  if (isFirstColumn && isNotFirstRow) {
    event.preventDefault();
    const prevStatement = statements[rowNumber - 1];
    if (!prevStatement) {
      console.warn('No previous statement found on left key press');
      return;
    }
    focusStatement(rowNumber - 1, prevStatement.code.length);
  }
  desiredColumnNumber.value = null;
}

const handleArrowRight = (event: KeyboardEvent, rowNumber: number) => {
  const input = event.target as HTMLInputElement;
  const columnNumber = input.selectionStart ?? 0;
  const rowCharacterCount = input.value.length;
  const isLastColumn = columnNumber === rowCharacterCount;
  const isNotTheLastRow = rowNumber < statements.length - 1;
  if (isLastColumn && isNotTheLastRow) {
    event.preventDefault();
    focusStatement(rowNumber + 1, 0);
  }
  desiredColumnNumber.value = null;
}

const handleArrowUp = (event: KeyboardEvent, rowNumber: number) => {
  const input = event.target as HTMLInputElement;
  const columnNumber = input.selectionStart ?? 0;
  const isNotFirstRow = rowNumber > 0;
  if (isNotFirstRow) {
    event.preventDefault();
    if (desiredColumnNumber.value === null) {
      desiredColumnNumber.value = columnNumber;
    }
    focusStatement(rowNumber - 1, desiredColumnNumber.value);
  } else {
    desiredColumnNumber.value = null;
  }
}

const handleArrowDown = (event: KeyboardEvent, rowNumber: number) => {
  const input = event.target as HTMLInputElement;
  const columnNumber = input.selectionStart ?? 0;
  const isNotLastRow = rowNumber < statements.length - 1;
  if (isNotLastRow) {
    event.preventDefault();
    if (desiredColumnNumber.value === null) {
      desiredColumnNumber.value = columnNumber;
    }
    focusStatement(rowNumber + 1, desiredColumnNumber.value);
  } else {
    desiredColumnNumber.value = null;
  }
}

const handleEnter = (event: KeyboardEvent, rowNumber: number) => {
  event.preventDefault();
  statements.splice(rowNumber + 1, 0, { id: window.crypto.randomUUID(), code: '' });
  nextTick(() => {
    focusStatement(rowNumber + 1, 0);
    desiredColumnNumber.value = null;
  });
}

const handleBackspace = (event: KeyboardEvent, rowNumber: number) => {
  const input = event.target as HTMLInputElement;
  const rowCharacterCount = input.value.length;
  const isEmptyRow = rowCharacterCount === 0;
  const isNotOnlyRow = statements.length > 1;
  if (isEmptyRow && isNotOnlyRow) {
    event.preventDefault();
    statements.splice(rowNumber, 1);
    const prevIndex = rowNumber - 1;
    if (prevIndex >= 0) {
      nextTick(() => {
        focusStatement(prevIndex, statements[prevIndex]?.code.length as number);
        desiredColumnNumber.value = null;
      });
    }
  }
}

const handleSingleCharacterKey = (event: KeyboardEvent, rowNumber: number) => {
  desiredColumnNumber.value = null;
}

const handleStatementKeydown = (event: KeyboardEvent, rowNumber: number) => {
  if (event.key === 'ArrowUp') {
    handleArrowUp(event, rowNumber);
  }

  else if (event.key === 'ArrowDown') {
    handleArrowDown(event, rowNumber);
  }

  else if (event.key === 'ArrowLeft') {
    handleArrowLeft(event, rowNumber);
  }

  else if (event.key === 'ArrowRight') {
    handleArrowRight(event, rowNumber);
  }

  else if (event.key === 'Enter') {
    handleEnter(event, rowNumber);
  }

  else if (event.key === 'Backspace') {
    handleBackspace(event, rowNumber);
  }

  else if (event.key.length === 1) {
    handleSingleCharacterKey(event, rowNumber);
  }
};

const handleCodeInput = (event: InputEvent, rowNumber: number) => {
  updateCode(event, rowNumber);
  desiredColumnNumber.value = null;
}

const focusStatement = (rowNumber: number, columnNumber: number) => {
  nextTick(() => {
    const input = document.querySelector(`.statement-input-${rowNumber}`) as HTMLInputElement;
    if (input) {
      input.focus();
      const maxColumnNumber = input.value.length;
      const targetColumnNumber = Math.min(columnNumber, maxColumnNumber);
      input.setSelectionRange(targetColumnNumber, targetColumnNumber);
    }
  });
};

</script>

<template>
  <div class="editor-content">
    <div class="editor-statement" v-for="(statement, index) in statements" :key="statement.id">
      <span class="line-number-display" type="number">{{ index + 1 }}</span>
      <input :value="statements[index]?.code" @input="handleCodeInput($event, index)"
        :class="['statement-input', `statement-input-${index}`]" @keydown="handleStatementKeydown($event, index)" />
    </div>
  </div>
  <div class="editor-print-container">
    <p v-if="programResults?.ok === true" class="editor-print-line" v-for="line in programResults.output"
      :key="programResults.index">{{ line }}</p>
    <p v-if="programResults?.ok === false" class="editor-print-line editor-print-line-error"
      :key="programResults.index">{{
        programResults.error }}</p>
  </div>
  <div class="editor-run-container">
    <button class="editor-output-mode-button" @click="toggleInterpreterOutputMode">
      <span>Output Mode: </span>
      <span>{{ interpreterOutputMode }}</span>
    </button>
    <button class="icon-container" @click="runCode">
      <Icon class="icon" :icon="'lucide:play'" />
    </button>
  </div>
</template>

<style scoped>
button:focus,
button:focus-visible {
  outline: none;
}

.editor-run-container {
  display: grid;
  grid-template-columns: 1fr auto;
}

.icon-container {
  background-color: transparent;
  padding: 1rem;
  cursor: pointer;
  border: none;
}

.icon {
  width: 1.25rem;
  height: 1.25rem;
  color: var(--sky-500);
}

.editor-output-mode-button:nth-child(1) {
  border-right: 2px solid var(--sky-900);
}

.editor-output-mode-button {
  background-color: transparent;
  color: var(--sky-500);
  padding: 1rem;
  font-size: 1rem;
  line-height: 1;
  cursor: pointer;
  text-transform: uppercase;
  border: none;
  letter-spacing: 2px;
  text-align: left;
}

.editor-content,
.editor-print-container {
  padding: 0.5rem 0;
  overflow-y: auto;
}

.editor-statement {
  font-size: 1.25rem;
  display: flex;
  gap: 1rem;
  padding: 0.25rem 0.75rem;
}

.line-number-display {
  color: var(--sky-600);
  width: 3rem;
  font-family: inherit;
  font-size: inherit;
  user-select: none;
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

.editor-print-line-error {
  color: var(--red-600);
}
</style>
