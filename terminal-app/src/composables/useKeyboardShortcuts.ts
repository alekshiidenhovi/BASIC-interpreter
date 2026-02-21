import { onMounted, onUnmounted, readonly } from 'vue'
import { useStore } from '@nanostores/vue'
import {
  $activeScope,
  $shortcutBindings,
  $scopedShortcutBindings,
  registerKeyboardShortcut,
  setScope,
  unregisterKeyboardShortcut,
  type RegisteredShortcutBinding,
} from '@/stores/keyboardShortcuts'

export function useShortcutRegistry() {
  const bindings = useStore($shortcutBindings)
  const activeScope = useStore($activeScope)
  const scopedBindings = useStore($scopedShortcutBindings)

  return {
    bindings: readonly(bindings),
    activeScope: readonly(activeScope),
    scopedBindings: readonly(scopedBindings),
    setScope,
  }
}

export function useKeyboardShortcut(args: Omit<RegisteredShortcutBinding, 'id'>) {
  let id: string | null = null
  onMounted(() => {
    id = registerKeyboardShortcut(args)
  })
  onUnmounted(() => {
    if (id) unregisterKeyboardShortcut(id)
  })
}
