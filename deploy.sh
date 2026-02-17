#!/usr/bin/env bash
set -euo pipefail

INTERPRETER_IN="interpreter/web/main.dart"
INTERPRETER_OUT="terminal-app/public/basic_interpreter.js"

echo "▶ Compiling Dart interpreter to JS..."
dart compile js $INTERPRETER_IN -o "$INTERPRETER_OUT" -O2 --no-source-maps
rm -f "$INTERPRETER_OUT".deps

echo "▶ Installing terminal dependencies..."
cd terminal-app
pnpm install

echo "▶ Building Astro app..."
pnpm build

echo "▶ Deploying to Cloudflare Workers..."
pnpm run deploy

echo "✓ Build complete"
