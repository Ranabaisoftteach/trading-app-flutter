<?php

return [
    'enabled' => [
        'pan' => env('HYPERVERGE_PAN_ENABLED', true),
        'bank' => env('HYPERVERGE_BANK_ENABLED', true),
        'digilocker' => env('HYPERVERGE_DIGILOCKER_ENABLED', false),
        'ckyc' => env('HYPERVERGE_CKYC_ENABLED', false),
        'kra' => env('HYPERVERGE_KRA_ENABLED', false),
        'face_match' => env('HYPERVERGE_FACE_MATCH_ENABLED', false),
        'liveness' => env('HYPERVERGE_LIVENESS_ENABLED', false),
        'esign' => env('HYPERVERGE_ESIGN_ENABLED', false),
        'aml' => env('HYPERVERGE_AML_ENABLED', false),
        'webhooks' => env('HYPERVERGE_WEBHOOKS_ENABLED', true),
    ],
];
