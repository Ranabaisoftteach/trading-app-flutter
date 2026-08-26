<?php

namespace App\Services\Broker;

use Illuminate\Support\Facades\Http;

class AngelOneMarketDataService
{
    public function ltp(string $exchange, string $tradingsymbol, string $symboltoken): array
    {
        $token = app(AngelOneSmartApiBroker::class)->accessToken();
        $response = Http::withHeaders([
            'Authorization' => 'Bearer '.$token,
            'X-PrivateKey' => config('services.angelone.api_key'),
            'X-UserType' => 'USER',
            'X-SourceID' => 'WEB',
            'Accept' => 'application/json',
            'Content-Type' => 'application/json',
        ])->post('https://apiconnect.angelone.in/rest/secure/angelbroking/order/v1/getLtpData', [
            'exchange' => $exchange,
            'tradingsymbol' => $tradingsymbol,
            'symboltoken' => $symboltoken,
        ]);

        if ($response->failed()) {
            throw new \RuntimeException($response->json('message') ?? 'Angel One LTP request failed');
        }

        return $response->json();
    }
}
