# Sri Connect

A comprehensive service booking and appointment management system for Sri Lankan government services. Built with Flutter and Supabase, Sri Connect streamlines the process of booking appointments for various government services like NIC updates, birth certificates, and other administrative services.

## Features

- **Service Booking**: Book appointments for various government services
- **User Management**: Support for Citizens, Officers, and Admins
- **Document Management**: Upload and manage required documents for appointments
- **Time Slot Management**: Dynamic time slot allocation and management
- **Real-time Updates**: Live appointment status updates
- **Multi-language Support**: Localization support for Sinhala and English

## Architecture

- **Frontend**: Flutter (Mobile App)
- **Backend**: Supabase (PostgreSQL + Edge Functions)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage for documents
- **Real-time**: Supabase Realtime subscriptions

## Prerequisites

Before running the application, ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install) (3.6.0 or higher)
- [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/)
- [Node.js](https://nodejs.org/) (18 or higher)
- [Supabase CLI](https://supabase.com/docs/guides/cli)

## 🚀 Quick Start with Docker

The easiest way to run the entire application is using Docker Compose:

```bash
# Clone the repository
git clone https://github.com/moonlander101/NovaNine_SriConnect.git
cd NovaNine_SriConnect

# Start all services
docker-compose up -d

# The application will be available at:
# - Supabase Studio: http://localhost:54323
# - Supabase API: http://localhost:54321
# - Edge Functions: http://localhost:54321/functions/v1
```

## Manual Setup

### 1. Setup Supabase Backend

```bash
# Navigate to supabase directory
cd supabase

# Install dependencies
npm install

# Start Supabase locally
supabase start

# Apply database migrations
supabase db reset

# Deploy edge functions
supabase functions deploy service-booking
```

### 2. Setup Flutter App

```bash
# Navigate to app directory
cd app

# Copy environment file
cp .env.example .env

# Edit .env file with your Supabase credentials
# For local development, use:
# SUPABASE_URL=http://127.0.0.1:54321
# SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0

# Install Flutter dependencies
flutter pub get

# Run the app
flutter run
```

## Running on Different Platforms

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d web-server --web-port 3000
```

### Windows
```bash
flutter run -d windows
```

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Database Schema

The application uses the following main entities:

- **Users**: Citizens, Officers, and Admins
- **Departments**: Government departments offering services
- **Services**: Various government services available for booking
- **Appointments**: Scheduled appointments between citizens and officers
- **Time Slots**: Available time slots for appointments
- **Documents**: Required documents for services
- **Notifications**: System notifications and updates

## 🔧 Environment Variables

### App (.env)
```bash
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Supabase (.env.local)
```bash
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=your_anon_key_here
```

## Available Services

The system currently supports booking for:

- National Identity Card (NIC) updates
- Birth Certificate applications
- Marriage Certificate applications
- Educational document verification
- Business registration services
- And more...

## User Roles

- **Citizens**: Book appointments, upload documents, track status
- **Officers**: Manage assigned appointments, update status, view documents
- **Admins**: Full system access, user management, service configuration

## Troubleshooting

### Common Issues

1. **Flutter build fails**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```

2. **Supabase connection issues**
   - Ensure Supabase is running: `supabase status`
   - Check environment variables in `.env` file
   - Verify network connectivity

3. **Docker issues**
   ```bash
   docker-compose down
   docker-compose up --build
   ```

