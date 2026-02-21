<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted, nextTick } from "vue";
import type { Statement, OutputMode, IndexedResult } from "@/types";
import CodeEditorView from "./CodeEditorView.vue";
import CodeEditorRepl from "./CodeEditorRepl.vue";
import { setScope, registerKeyboardShortcut, unregisterKeyboardShortcut, normalizeKey, type UnregisteredShortcutBinding } from "@/stores/keyboardShortcuts";
import { assertNever } from "@/utils";

type Mode = 'editor' | 'repl';

interface Props {
  starterCode: string[] | undefined
}

const props = defineProps<Props>()

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

const selectedMode = ref<Mode>('editor');
const replInput = ref<string>("");
const replOutputs = ref<Statement[]>([]);
const interpreterOutputMode = ref<OutputMode>("interpreter");
const statements = ref<Statement[]>(initStarterCode());
const programResults = ref<IndexedResult<string[]> | undefined>(undefined);

const editorShortcutBindingIds = ref<string[]>([]);
const replShortcutBindingIds = ref<string[]>([]);

const toggleInterpreterOutputMode = () => {
  if (interpreterOutputMode.value === "lexer") {
    interpreterOutputMode.value = "parser";
  } else if (interpreterOutputMode.value === "parser") {
    interpreterOutputMode.value = "interpreter";
  } else if (interpreterOutputMode.value === "interpreter") {
    interpreterOutputMode.value = "lexer";
  } else {
    assertNever(interpreterOutputMode.value);
  }
}

const updateCode = (event: InputEvent, rowNumber: number) => {
  const input = event.target as HTMLInputElement;
  const row = statements.value[rowNumber];
  if (!row) {
    throw new Error("Statement not found");
  }
  row.code = input.value;
}

const runCode = () => {
  if (!window.interpretProgram) {
    throw new Error("Interpreter not loaded");
  }
  const code = statements.value.map((s) => s.code).join("\n");
  const result = window.interpretProgram(code, interpreterOutputMode.value);
  if (result.ok === false) {
    console.error(result.error);
  }
  programResults.value = {
    ...result,
    index: new Date().getTime(),
  }
}

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

  replInput.value = "";
  replOutputs.value.push({
    id: inputId,
    code: codeInput,
    printOutput: result,
  });
}

const focusReplInput = () => {
  const replInputContainer = document.querySelector(".repl-input") as HTMLInputElement;
  replInputContainer.focus();
}

const focusEditorInput = () => {
  const editorInputContainer = document.querySelector(".statement-input-0") as HTMLInputElement;
  editorInputContainer.focus();
  editorInputContainer.setSelectionRange(0, 0);
}

const resetReplContext = () => {
  if (!window.resetReplContext) {
    throw new Error("Interpreter not loaded");
  }
  window.resetReplContext();
  replOutputs.value = [];
  replInput.value = "";

  focusReplInput();
}

const handleReplInput = (event: InputEvent) => {
  replInput.value = (event.target as HTMLInputElement).value;
}

const enableReplMode = () => {
  selectedMode.value = 'repl';
}
const enableEditorMode = () => {
  selectedMode.value = 'editor';
}

const editorNavigateToPreviousPageBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "Escape", hasCtrlOrMetaKey: false }),
  handler: () => window.location.href = "/tutorial",
  scope: "editor",
  description: "Navigate to previous page",
};

const editorSwitchTabKeyBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "Tab", hasCtrlOrMetaKey: false }),
  handler: enableReplMode,
  scope: "editor",
  description: "Switch to REPL",
};

const editorSwitchInterpreterModeKeyBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "i", hasCtrlOrMetaKey: true }),
  handler: toggleInterpreterOutputMode,
  scope: "editor",
  description: "Switch interpreter output mode",
};

const editorRunProgramBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "e", hasCtrlOrMetaKey: true }),
  handler: runCode,
  scope: "editor",
  description: "Run program",
};

const replNavigateToPreviousPageBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "Escape", hasCtrlOrMetaKey: false }),
  handler: () => window.location.href = "/tutorial",
  scope: "repl",
  description: "Navigate to previous page",
};

const replSwitchTabKeyBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "Tab", hasCtrlOrMetaKey: false }),
  handler: enableEditorMode,
  scope: "repl",
  description: "Switch to editor",
};

const replExecuteCommandBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "Enter", hasCtrlOrMetaKey: false }),
  handler: executeReplCommand,
  scope: "repl",
  description: "Execute current line",
};

const replResetContextBinding: UnregisteredShortcutBinding = {
  key: normalizeKey({ key: "r", hasCtrlOrMetaKey: true }),
  handler: resetReplContext,
  scope: "repl",
  description: "Reset REPL context",
};

const registerEditorShortcutBindings = () => {
  editorShortcutBindingIds.value = [
    registerKeyboardShortcut(editorSwitchTabKeyBinding),
    registerKeyboardShortcut(editorSwitchInterpreterModeKeyBinding),
    registerKeyboardShortcut(editorNavigateToPreviousPageBinding),
    registerKeyboardShortcut(editorRunProgramBinding),
  ]
}

const registerReplShortcutBindings = () => {
  replShortcutBindingIds.value = [
    registerKeyboardShortcut(replSwitchTabKeyBinding),
    registerKeyboardShortcut(replExecuteCommandBinding),
    registerKeyboardShortcut(replResetContextBinding),
    registerKeyboardShortcut(replNavigateToPreviousPageBinding),
  ]
}

const unregisterEditorShortcutBindings = () => {
  editorShortcutBindingIds.value.forEach(id => unregisterKeyboardShortcut(id));
  editorShortcutBindingIds.value = [];
}

const unregisterReplShortcutBindings = () => {
  replShortcutBindingIds.value.forEach(id => unregisterKeyboardShortcut(id));
  replShortcutBindingIds.value = [];
}

onMounted(() => {
  registerEditorShortcutBindings();
  setScope("editor");
  nextTick(() => {
    focusEditorInput();
  });
})

watch(selectedMode, (newMode, oldMode) => {
  if (oldMode === 'editor') unregisterEditorShortcutBindings();
  if (oldMode === 'repl') unregisterReplShortcutBindings();

  if (newMode === 'editor') {
    setScope("editor");
    registerEditorShortcutBindings();
    nextTick(() => {
      focusEditorInput();
    });
  }
  if (newMode === 'repl') {
    setScope("repl");
    registerReplShortcutBindings();
    nextTick(() => {
      focusReplInput();
    });
  }
})

onUnmounted(() => {
  unregisterEditorShortcutBindings();
  unregisterReplShortcutBindings();
})

</script>

<template>
  <div class="editor-container" :class="{
    'editor-container-view-layout': selectedMode === 'editor', 'editor-container-repl-layout': selectedMode
      === 'repl'
  }">
    <div class="editor-mode-container">
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'editor' }"
        @click="enableEditorMode()">Editor</button>
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'repl' }"
        @click="enableReplMode()">REPL</button>
    </div>
    <CodeEditorView v-if="selectedMode === 'editor'" :interpreterOutputMode="interpreterOutputMode"
      :toggleInterpreterOutputMode="toggleInterpreterOutputMode" :updateCode="updateCode" :runCode="runCode"
      :statements="statements" :programResults="programResults" />
    <CodeEditorRepl v-if="selectedMode === 'repl'" :replOutputs="replOutputs" :replInput="replInput"
      :resetReplContext="resetReplContext" :handleReplInput="handleReplInput" />
  </div>
</template>

<style scoped>
button:focus,
button:focus-visible {
  outline: none;
}

.editor-container {
  display: grid;
  grid-template-rows: auto minmax(0, 1fr) auto minmax(0, 1fr);
  border: 2px solid var(--sky-900);
  height: 100%;
  min-height: 0;
}

.editor-container-view-layout {
  grid-template-rows: auto minmax(0, 1fr) auto minmax(0, 1fr);
}

.editor-container-repl-layout {
  grid-template-rows: auto minmax(0, 1fr) auto;
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
</style>
