<?php

namespace App\Services\Broker;

use Illuminate\Support\Facades\Http;
use RuntimeException;

class AngelOneSmartApiBroker implements BrokerInterface
{
    private string $baseUrl;
    private ?string $jwt;
    private ?string $refreshToken;

    public function __construct(?string $jwt = null, ?string $refreshToken = null)
    {
        $this->baseUrl = rtrim(config('services.angelone.base_url', 'https://apiconnect.angelone.in'), '/');
        $this->jwt = $jwt;
        $this->refreshToken = $refreshToken;
    }

    public function authenticate(string $clientCode, string $password, string $totp): array
    {
        return $this->request('/rest/auth/angelbroking/user/v1/loginByPassword', [
            'clientcode' => $clientCode,
            'password' => $password,
            'totp' => $totp,
        ], false);
    }

    public function profile(): array { return $this->get('/rest/secure/angelbroking/user/v1/getProfile'); }

    public function funds(): array { return $this->get('/rest/secure/angelbroking/user/v1/getRMSLimits'); }

    public function holdings(): array { return $this->get('/rest/secure/angelbroking/portfolio/v1/getAllHolding'); }

    public function positions(): array { return $this->get('/rest/secure/angelbroking/order/v1/getPosition'); }

    public function quote(string $exchange, string $tradingsymbol, string $symbolToken): array
    {
        return $this->request('/rest/secure/angelbroking/order/v1/getLtpData', compact('exchange', 'tradingsymbol', 'symbolToken'));
    }

    public function orders(): array { return $this->get('/rest/secure/angelbroking/order/v1/getOrderBook'); }

    public function trades(): array { return $this->get('/rest/secure/angelbroking/order/v1/getTradeBook'); }

    public function placeOrder(array $order): array
    {
        return $this->request('/rest/secure/angelbroking/order/v1/placeOrder', $order);
    }

    public function cancelOrder(string $orderId, string $variety = 'NORMAL'): array
    {
        return $this->request('/rest/secure/angelbroking/order/v1/cancelOrder', [
            'variety' => $variety,
            'orderid' => $orderId,
        ]);
    }

    private function get(string $path): array
    {
        return $this->request($path, [], true, 'GET');
    }

    private function request(string $path, array $payload = [], bool $secure = true, string $method = 'POST'): array
    {
        $headers = [
            'Accept' => 'application/json',
            'Content-Type' => 'application/json',
            'X-UserType' => 'USER',
            'X-SourceID' => 'WEB',
            'X-PrivateKey' => config('services.angelone.api_key'),
            'X-ClientLocalIP' => config('services.angelone.client_local_ip', '127.0.0.1'),
            'X-ClientPublicIP' => config('services.angelone.client_public_ip'),
            'X-MACAddress' => config('services.angelone.mac_address', '00:00:00:00:00:00'),
        ];

        if ($secure && $this->jwt) $headers['Authorization'] = 'Bearer ' . $this->jwt;

        $request = Http::timeout(30)->withHeaders($headers);
        $response = $method === 'GET'
            ? $request->get($this->baseUrl . $path)
            : $request->post($this->baseUrl . $path, $payload);

        if ($response->failed()) {
            throw new RuntimeException('Angel One SmartAPI HTTP error: ' . $response->status());
        }

        $json = $response->json();
        if (!is_array($json)) throw new RuntimeException('Invalid Angel One SmartAPI response.');
        if (($json['status'] ?? null) === false) {
            throw new RuntimeException(($json['message'] ?? 'Angel One SmartAPI request failed') . ' [' . ($json['errorcode'] ?? 'UNKNOWN') . ']');
        }

        return $json;
    }
}
