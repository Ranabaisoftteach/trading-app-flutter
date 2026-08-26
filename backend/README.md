# Trading App Laravel 12 Backend

Backend API for the Flutter trading application.

## Setup

```bash
composer create-project laravel/laravel backend
cd backend
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8000
```

## Planned API

- POST /api/auth/login
- POST /api/auth/logout
- GET /api/profile
- GET /api/kyc/status
- POST /api/kyc/submit
- GET /api/market/search
- POST /api/orders
- GET /api/orders
- GET /api/portfolio
- GET /api/funds

Never commit `.env` or production API credentials. Sensitive PAN and bank data must be handled server-side over authenticated HTTPS.
