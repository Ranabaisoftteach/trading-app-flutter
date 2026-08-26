# Angel One SmartAPI setup

## Local configuration

Copy the values from `backend/.env.angelone.example` into your local `backend/.env`.

Required values:

- `ANGELONE_BASE_URL=https://apiconnect.angelone.in`
- `ANGELONE_API_KEY`
- `ANGELONE_CLIENT_CODE`
- `ANGELONE_PIN`
- `ANGELONE_PRIMARY_STATIC_IP`

Never commit real API keys, PINs, TOTP secrets, JWTs, refresh tokens, or feed tokens.

## Login flow

The Laravel backend authenticates the user's Angel One account and keeps broker tokens server-side. The Flutter app should only call the Laravel broker-connect endpoint and must not call SmartAPI directly with the app key.

TOTP is a time-based one-time password. The user's current 6-digit TOTP is used for authentication; the long-lived TOTP secret should never be sent to or stored by the Flutter app unless your approved broker integration explicitly requires a different server-side flow.

## Production

Configure the production server with the registered primary static IPv4 required by the current SmartAPI policy before enabling live order execution. Test authentication, profile, funds, holdings, positions, quotes and order-status flows in the broker's supported environment before enabling real orders.
