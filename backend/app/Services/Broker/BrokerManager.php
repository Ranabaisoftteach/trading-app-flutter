<?php

namespace App\Services\Broker;

use RuntimeException;

class BrokerManager
{
    public function primary(?string $jwt = null, ?string $refreshToken = null): BrokerInterface
    {
        return match (config('broker.primary', 'angelone')) {
            'angelone' => new AngelOneSmartApiBroker($jwt, $refreshToken),
            default => throw new RuntimeException('Unsupported primary broker.'),
        };
    }
}
