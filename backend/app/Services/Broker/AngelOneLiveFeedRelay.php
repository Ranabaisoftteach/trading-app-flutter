<?php

namespace App\Services\Broker;

/**
 * Defines the server-side contract for the live-feed relay.
 * Keep Angel One feed credentials/tokens on the server; Flutter receives
 * normalized ticks from an authenticated WebSocket endpoint.
 */
class AngelOneLiveFeedRelay
{
    public function normalizeTick(array $tick): array
    {
        return [
            'type' => 'tick',
            'exchange' => $tick['exchange'] ?? null,
            'symboltoken' => $tick['symboltoken'] ?? null,
            'tradingsymbol' => $tick['tradingsymbol'] ?? null,
            'ltp' => isset($tick['ltp']) ? (float) $tick['ltp'] : null,
            'open' => isset($tick['open']) ? (float) $tick['open'] : null,
            'high' => isset($tick['high']) ? (float) $tick['high'] : null,
            'low' => isset($tick['low']) ? (float) $tick['low'] : null,
            'close' => isset($tick['close']) ? (float) $tick['close'] : null,
            'timestamp' => now()->toIso8601String(),
        ];
    }
}
