# Trading App Flutter

Groww-inspired trading/investment mobile app starter built with Flutter and designed for a Laravel 12 backend.

## Status

Initial MVP scaffold. Real-money trading is not enabled. Broker/KYC/payment integrations must be configured with compliant providers before production use.

## Planned modules

- Mobile OTP authentication
- Home dashboard
- Stock search and watchlist
- Stock details and charts
- Buy/Sell order UI
- Orders, holdings and positions
- Portfolio and P&L
- Funds
- KYC onboarding
- Notifications
- Laravel REST API integration

## Run

```bash
flutter pub get
flutter run
```

## Architecture

Flutter app -> Laravel 12 REST API -> broker/KYC/payment/market-data providers.

Never commit API secrets. Use environment/configuration management for production credentials.
