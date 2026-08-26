<?php

return [
    'hyperverge' => [
        'app_id' => env('HYPERVERGE_APP_ID'),
        'app_key' => env('HYPERVERGE_APP_KEY'),
        'vendor_validation_url' => env('HYPERVERGE_VENDOR_VALIDATION_URL', 'https://ind-engine.thomas.hyperverge.co/v1/async/vendorValidation'),
    ],
];
