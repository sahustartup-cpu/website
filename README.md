# SahuStartup Website

A professional Flutter web application for SahuStartup — showcasing web design, mobile app development, AI agents, and branding services.

## 🚀 Features

- **Responsive Design**: Optimized for desktop and mobile
- **Supabase Backend**: Dynamic content management for projects, reviews, and contact forms
- **Modern UI**: Material 3, Google Fonts (Syne & DM Sans), smooth animations
- **Trust-Focused Sections**:
  - Hero with clear value proposition
  - About section with stats
  - Detailed services breakdown
  - How It Works process
  - FAQ section
  - Project portfolio
  - Client reviews
  - Contact form

## 🛠️ Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase
- **Fonts**: Google Fonts
- **Animations**: flutter_animate
- **State Management**: StatefulWidget

## 📦 Setup

1. **Clone the repository**:
   ```bash
   git clone git@github.com:sahustartup-cpu/website.git
   cd website
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**:
   Create a `.env` file in the root directory:
   ```env
   SUPABASE_URL=your_supabase_url_here
   SUPABASE_ANON_KEY=your_supabase_anon_key_here
   ```

4. **Run the app**:
   ```bash
   flutter run -d chrome --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
   ```

## 🗄️ Supabase Schema

Required tables:
- `hero` - Hero section content
- `projects` - Portfolio projects
- `reviews` - Client testimonials
- `contact_messages` - Contact form submissions
- `project_submissions` - Project inquiry submissions
- `social_links` - Footer social links

## 📝 License

© 2026 SahuStartup. All rights reserved.

## 📧 Contact

- Email: sahustartup@gmail.com
- Website: [Coming Soon]

---

Built with ❤️ by Manoj Sahu
