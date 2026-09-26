# Vercel Deployment Instructions for SahuStartup Flutter Web

## 1. Build Flutter Web Locally

Run this command on your machine to build with Supabase credentials:

```bash
flutter build web --release --dart-define=SUPABASE_URL=https://fnwplerkqpixjmrzflhr.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZud3BsZXJrcXBpeGptcnpmbGhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyMzMxNzksImV4cCI6MjA5NTgwOTE3OX0.G6vWT1BeXCyE2tD-JPfAVqtHobO1n1nBVQ4rcc31ztY
```

## 2. Commit Built Files to GitHub

```bash
git add build/web/*
git commit -m "Add built web assets for Vercel"
git push origin main
```

## 3. Deploy on Vercel

Vercel will automatically:
- Serve the `build/web` directory
- Handle SPA routing for Flutter web

## Important Notes

- **Supabase ANON keys are public** and safe for web apps
- Credentials are only embedded in the built JavaScript files
- No credentials in source code
- Vercel just serves pre-built static files

## To Update Website

1. Make code changes
2. Run build command above
3. Commit build/web changes
4. Push to GitHub
5. Vercel auto-deploys
