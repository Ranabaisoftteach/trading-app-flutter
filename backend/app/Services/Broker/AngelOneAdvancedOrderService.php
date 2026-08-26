<?php

namespace App\Services\Broker;

use Illuminate\Support\Facades\Http;

class AngelOneAdvancedOrderService
{
    public function modify(string $jwt, array $order): array
    {
        return $this->request($jwt, 'https://apiconnect.angelone.in/rest/secure/angelbroking/order/v1/modifyOrder', $order);
    }

    public function status(string $jwt, string $orderId): array
    {
        return $this->request($jwt, 'https://apiconnect.angelone.in/rest/secure/angelbroking/order/v1/details/'.$orderId, null, 'GET');
    }

    public function book(string $jwt): array
    {
        return $this->request($jwt, 'https://apiconnect.angelone.in/rest/secure/angelbroking/order/v1/getOrderBook', null, 'GET');
    }

    private function request(string $jwt, string $url, ?array $payload, string $method = 'POST'): array
    {
        $http = Http::withHeaders([
            'Authorization' => 'Bearer '.$jwt,
            'X-PrivateKey' => config('services.angelone.api_key'),
            'X-UserType' => 'USER',
            'X-SourceID' => 'WEB',
            'Accept' => 'application/json',
            'Content-Type' => 'application/json',
        ]);
        $response = $method === 'GET' ? $http->get($url) : $http->post($url, $payload ?? []);
        if ($response->failed()) throw new \RuntimeException($response->json('message') ?? 'Angel One order request failed');
        return $response->json();
    }
}
