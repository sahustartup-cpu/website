#!/bin/bash
set -e

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter
export PATH="/opt/flutter/bin:$PATH"

echo "Running flutter doctor..."
flutter doctor

echo "Getting dependencies..."
flutter pub get

echo "Building web app..."
flutter build web --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
