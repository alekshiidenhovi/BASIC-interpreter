#!/usr/bin/env bash
set -euo pipefail

INTERPRETER_IN="web/main.dart"
INTERPRETER_OUT="../terminal-app/public/basic_interpreter.js"

echo "▶ Compiling Dart interpreter to JS..."
cd interpreter
dart pub get
dart compile js $INTERPRETER_IN -o "$INTERPRETER_OUT" -O2 --no-source-maps
rm -f "$INTERPRETER_OUT".deps

echo "▶ Installing terminal dependencies..."
cd ../terminal-app
pnpm install --frozen-lockfile

echo "▶ Building Astro app..."
pnpm build

echo "▶ Deploying to Cloudflare Workers..."
pnpm run deploy

echo "✓ Build complete"
