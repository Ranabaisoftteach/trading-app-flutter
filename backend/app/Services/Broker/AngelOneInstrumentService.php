<?php

namespace App\Services\Broker;

use Illuminate\Support\Facades\Http;

class AngelOneInstrumentService
{
    public function search(string $query): array
    {
        $query = trim($query);
        if ($query === '') return [];

        // Instrument master should be downloaded/cached from Angel One and searched locally in production.
        // This method intentionally returns a safe, normalized result shape for the API layer.
        return collect(config('broker.instruments', []))
            ->filter(fn ($item) => str_contains(strtoupper($item['tradingsymbol'] ?? ''), strtoupper($query)))
            ->take(30)
            ->values()
            ->all();
    }
}
