import { atom, computed } from 'nanostores'

const MODIFIER_KEYS = new Set(['ctrl', 'shift', 'alt'])
const INPUT_TAGS = new Set(['input', 'textarea'])

/**
  * A type for a function that is called when a shortcut is triggered.
  */
export type ShortcutHandler = (event: KeyboardEvent) => void

/**
 * A type for a shortcut scope.
 */
export type ShortcutScope = 'global' | 'editor' | 'modal' | "menu"

/**
 * A type for a normalized shortcut key.
 */
export type NormalizedShortcutKey = string & { __normalized: true }

/**
 * A type for a shortcut binding.
 */
export interface ShortcutBinding {
  /** The unique identifier for the binding. */
  id: string
  /** The key in normalized string format. */
  key: NormalizedShortcutKey
  /** The handler function for the keyboard shortcut event. */
  handler: ShortcutHandler
  /** The scope where the shortcut should be active. */
  scope: ShortcutScope
  /** The description of what the shortcut does. */
  description: string
  /** Whether to use the raw key value instead of the normalized key. */
  useRawKey?: boolean
}

/**
 * A store for keyboard shortcut bindings.
 */
export const $shortcutBindings = atom<Record<string, ShortcutBinding>>({})

/**
 * A store for currently active shortcut scope.
 */
export const $activeScope = atom<ShortcutScope>('global')

/**
 * A computed store for scoped shortcut bindings.
 */
export const $scopedShortcutBindings = computed(
  [$shortcutBindings, $activeScope],
  (bindings, scope) =>
    Object.values(bindings).filter(
      (b) => b.scope === scope || b.scope === 'global'
    )
)

/**
 * Normalizes a keyboard event into a normalized shortcut key.
 * @param e The keyboard event to normalize.
 * @returns The normalized shortcut key.
 */
function normalizeKey(e: KeyboardEvent): NormalizedShortcutKey {
  const parts: string[] = []
  if (e.ctrlKey || e.metaKey) parts.push('ctrl')
  if (e.shiftKey) parts.push('shift')

  const key = e.key.toLowerCase()
  if (!MODIFIER_KEYS.has(key)) {
    parts.push(key)
  }

  return parts.join('+') as NormalizedShortcutKey
}

/**
 * Checks if the active element is an input or textarea.
 * @returns True if the active element is an input or textarea, false otherwise.
 */
function isInputFocused(): boolean {
  const tag = document.activeElement?.tagName.toLowerCase()
  const isEditable = (document.activeElement as HTMLElement)?.isContentEditable
  return INPUT_TAGS.has(tag ?? '') || isEditable
}

/**
  * Groups the shortcuts by scope.
  * @param bindings The shortcuts to group.
  * @returns The grouped shortcuts.
  */
export function groupShortcutsByScope(bindings: readonly ShortcutBinding[]): Partial<Record<ShortcutScope, ShortcutBinding[]>> {
  const grouped: Partial<Record<ShortcutScope, ShortcutBinding[]>> = {};
  bindings.forEach((binding) => {
    const scope = binding.scope;
    if (!grouped[scope]) {
      grouped[scope] = [];
    }
    grouped[scope].push(binding);
  });
  return grouped;
}


/**
 * Registers a shortcut binding.
 * @param binding The shortcut binding to register.
 * @returns The ID of the registered binding.
 */
export function registerKeyboardShortcut(binding: Omit<ShortcutBinding, 'id'> & { id?: string }): string {
  const id = binding.id ?? `${binding.scope}:${binding.key}`
  $shortcutBindings.set({
    ...$shortcutBindings.get(),
    [id]: { ...binding, id }
  })
  return id
}

/**
 * Unregisters a shortcut binding.
 * @param id The ID of the binding to unregister.
 */
export function unregisterKeyboardShortcut(id: string): void {
  const current = { ...$shortcutBindings.get() }
  delete current[id]
  $shortcutBindings.set(current)
}

/**
 * Sets the active shortcut scope.
 * @param scope The shortcut scope to set.
 */
export function setScope(scope: ShortcutScope): void {
  $activeScope.set(scope)
}

let initialized = false

/**
 * Initializes the shortcut bindings.
 */
export function initKeyboardShortcuts(): void {
  if (initialized || typeof window === 'undefined') return
  initialized = true

  window.addEventListener('keydown', (e: KeyboardEvent) => {
    if (isInputFocused()) return

    const pressed = normalizeKey(e)
    const match = $scopedShortcutBindings.get().find(b => b.useRawKey ? b.key === e.key : b.key === pressed)

    if (match) {
      e.preventDefault()
      match.handler(e)
    }
  })
}
