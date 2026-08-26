# Angel One SmartAPI Setup

## Environment

```env
PRIMARY_BROKER=angelone
ANGELONE_BASE_URL=https://apiconnect.angelone.in
ANGELONE_API_KEY=your_api_key
ANGELONE_CLIENT_LOCAL_IP=127.0.0.1
ANGELONE_CLIENT_PUBLIC_IP=your_registered_public_ip
ANGELONE_MAC_ADDRESS=your_mac_address
```

Keep credentials out of Git. Production order APIs must originate from the registered primary static IP required by Angel One's current SmartAPI rules.

## Login inputs

The SmartAPI authentication flow uses the Angel One client code, password/PIN, and TOTP. Store the resulting access/refresh tokens securely server-side.

## Adapter capabilities

- Profile
- RMS/Funds
- Holdings
- Positions
- LTP quote
- Order book
- Trade book
- Place order
- Cancel order

Use sandbox/paper testing and broker-approved production access before enabling live order execution.
