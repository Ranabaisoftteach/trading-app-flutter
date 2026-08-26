<?php

namespace App\Services\Broker;

use Illuminate\Support\Facades\Http;

class AngelOneCandleService
{
    public function candles(string $exchange, string $symboltoken, string $interval, string $fromdate, string $todate): array
    {
        $token = app(AngelOneSmartApiBroker::class)->accessToken();
        $response = Http::withHeaders([
            'Authorization' => 'Bearer '.$token,
            'X-PrivateKey' => config('services.angelone.api_key'),
            'X-UserType' => 'USER',
            'X-SourceID' => 'WEB',
            'Accept' => 'application/json',
            'Content-Type' => 'application/json',
        ])->post('https://apiconnect.angelone.in/rest/secure/angelbroking/historical/v1/getCandleData', compact('exchange','symboltoken','interval','fromdate','todate'));

        if ($response->failed()) throw new \RuntimeException($response->json('message') ?? 'Historical candle request failed');
        return $response->json();
    }
}
