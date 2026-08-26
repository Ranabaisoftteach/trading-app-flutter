<?php

return [
    'hyperverge' => [
        'app_id' => env('HYPERVERGE_APP_ID'),
        'app_key' => env('HYPERVERGE_APP_KEY'),
        'vendor_validation_url' => env('HYPERVERGE_VENDOR_VALIDATION_URL', 'https://ind-engine.thomas.hyperverge.co/v1/async/vendorValidation'),
    ],
    'angelone' => [
        'base_url' => env('ANGELONE_BASE_URL', 'https://apiconnect.angelone.in'),
        'api_key' => env('ANGELONE_API_KEY'),
        'client_local_ip' => env('ANGELONE_CLIENT_LOCAL_IP', '127.0.0.1'),
        'client_public_ip' => env('ANGELONE_CLIENT_PUBLIC_IP'),
        'mac_address' => env('ANGELONE_MAC_ADDRESS', '00:00:00:00:00:00'),
    ],
];
