<script setup lang="ts">
import { ref, nextTick } from "vue";
import { assertNever } from "@/utils";
import { Icon } from "@iconify/vue";
import type { OutputMode, Result, Statement } from "@/types";

type IndexedResult<T> = Result<T> & { index: number };

interface Props {
  starterCode: string[] | undefined
}
const props = defineProps<Props>();

const initStarterCode = (): Statement[] => {
  if (props.starterCode) {
    return props.starterCode.map(code => ({
      id: window.crypto.randomUUID(),
      code,
    }))
  } else {
    return [{ id: window.crypto.randomUUID(), code: "LET A" }];
  }
}

const statements = ref<Statement[]>(initStarterCode());
const results = ref<IndexedResult<string[]> | undefined>(undefined);
const outputMode = ref<OutputMode>("interpreter");

const runCode = (outputMode: OutputMode) => {
  if (!window.interpretProgram) {
    throw new Error("Interpreter not loaded");
  }
  const code = statements.value.map((s) => s.code).join("\n");
  const result = window.interpretProgram(code, outputMode);
  if (!result.ok) {
    console.error(result.error);
  }
  results.value = {
    ...result,
    index: new Date().getTime(),
  }
}

const toggleOutputMode = () => {
  if (outputMode.value === "lexer") {
    outputMode.value = "parser";
  } else if (outputMode.value === "parser") {
    outputMode.value = "interpreter";
  } else if (outputMode.value === "interpreter") {
    outputMode.value = "lexer";
  } else {
    assertNever(outputMode.value);
  }
}

/** Track the desired cursor column across vertical movements */
const desiredColumn = ref<number | null>(null);

const handleStatementKeydown = (event: KeyboardEvent, index: number) => {
  const input = event.target as HTMLInputElement;
  const cursorPos = input.selectionStart ?? 0;
  const textLength = input.value.length;

  if (event.key === 'ArrowUp' && index > 0) {
    event.preventDefault();
    if (desiredColumn.value === null) {
      desiredColumn.value = cursorPos;
    }
    focusStatement(index - 1, desiredColumn.value);
  }

  else if (event.key === 'ArrowDown' && index < statements.value.length - 1) {
    event.preventDefault();
    if (desiredColumn.value === null) {
      desiredColumn.value = cursorPos;
    }
    focusStatement(index + 1, desiredColumn.value);
  }

  else if (event.key === 'ArrowLeft' && cursorPos === 0 && index > 0) {
    event.preventDefault();
    const prevStatement = statements.value[index - 1];
    if (!prevStatement) {
      console.warn('No previous statement found on left key press');
      return;
    }
    focusStatement(index - 1, prevStatement.code.length);
    desiredColumn.value = null;
  }

  else if (event.key === 'ArrowRight' && cursorPos === textLength && index < statements.value.length - 1) {
    event.preventDefault();
    focusStatement(index + 1, 0);
    desiredColumn.value = null;
  }

  else if (event.key === 'Enter') {
    event.preventDefault();
    statements.value.splice(index + 1, 0, { id: window.crypto.randomUUID(), code: '' });
    nextTick(() => {
      focusStatement(index + 1, 0);
      desiredColumn.value = null;
    });
  }

  else if (event.key === 'Backspace' && cursorPos === 0 && textLength === 0 && statements.value.length > 1) {
    event.preventDefault();
    statements.value.splice(index, 1);
    const prevIndex = index - 1;
    if (prevIndex >= 0) {
      nextTick(() => {
        focusStatement(prevIndex, statements.value[prevIndex]?.code.length as number);
        desiredColumn.value = null;
      });
    }
  }

  else if (event.key === 'ArrowLeft' || event.key === 'ArrowRight' || event.key === 'ArrowUp' || event.key === 'ArrowDown') {
    desiredColumn.value = null;
  }

  else if (event.key.length === 1) {
    desiredColumn.value = null;
  }
};

const focusStatement = (index: number, column: number) => {
  nextTick(() => {
    const input = document.querySelector(`.statement-input-${index}`) as HTMLInputElement;
    if (input) {
      input.focus();
      const maxColumn = input.value.length;
      const targetColumn = Math.min(column, maxColumn);
      input.setSelectionRange(targetColumn, targetColumn);
    }
  });
};

</script>

<template>
  <div class="editor-content">
    <div class="editor-statement" v-for="(statement, index) in statements" :key="statement.id">
      <span class="line-number-display" type="number">{{ index + 1 }}</span>
      <input v-model="statements[index].code" :class="['statement-input', `statement-input-${index}`]"
        @keydown="handleStatementKeydown($event, index)" />
    </div>
  </div>
  <div class="editor-run-container">
    <button class="editor-run-button" @click="runCode(outputMode)">
      <Icon class="icon" :icon="'lucide:play'" />
    </button>
    <button class="editor-output-mode-button" @click="toggleOutputMode">
      <span>Output Mode: </span>
      <span>{{ outputMode }}</span>
    </button>
  </div>
  <div class="editor-print-container">
    <p v-if="results?.ok === true" class="editor-print-line" v-for="line in results.output" :key="results.index">{{ line
    }}</p>
    <p v-if="results?.ok === false" class="editor-print-line editor-print-line-error" :key="results.index">{{
      results.error }}</p>
  </div>
</template>

<style scoped>
button:focus,
button:focus-visible {
  outline: none;
}

.editor-run-container {
  display: grid;
  grid-template-columns: auto 1fr;
}

.icon {
  width: 1.25rem;
  height: 1.25rem;
  color: var(--sky-700);
}

.editor-run-button {
  background-color: transparent;
  color: var(--sky-700);
  padding: 1rem;
  font-size: 1rem;
  cursor: pointer;
  text-transform: uppercase;
  border: none;
  letter-spacing: 2px;
}

.editor-run-button:nth-child(1) {
  border-right: 2px solid var(--sky-900);
}


.editor-output-mode-button {
  background-color: transparent;
  color: var(--sky-600);
  padding: 1rem;
  font-size: 1rem;
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
