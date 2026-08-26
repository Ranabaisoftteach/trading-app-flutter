<?php

namespace App\Services\Broker;

use Illuminate\Support\Facades\Http;
use RuntimeException;

class AngelOneAuthService
{
    public function login(string $clientCode, string $pin, string $totp): array
    {
        $apiKey = config('broker.angelone.api_key');
        $baseUrl = rtrim(config('broker.angelone.base_url'), '/');

        if (!$apiKey || !$baseUrl) {
            throw new RuntimeException('Angel One API configuration is missing.');
        }

        $response = Http::timeout(20)
            ->withHeaders([
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-PrivateKey' => $apiKey,
                'X-SourceID' => 'WEB',
                'X-ClientLocalIP' => request()->ip() ?? '',
                'X-ClientPublicIP' => config('broker.angelone.public_ip', ''),
                'X-MACAddress' => config('broker.angelone.mac_address', ''),
                'X-UserType' => 'USER',
            ])
            ->post($baseUrl . '/rest/auth/angelbroking/user/v1/loginByPassword', [
                'clientcode' => $clientCode,
                'password' => $pin,
                'totp' => $totp,
            ]);

        if ($response->failed()) {
            throw new RuntimeException('Angel One authentication request failed: HTTP ' . $response->status());
        }

        $data = $response->json();
        if (!is_array($data) || (($data['status'] ?? false) !== true && empty($data['data']['jwtToken']))) {
            throw new RuntimeException($data['message'] ?? 'Angel One login failed.');
        }

        return $data;
    }
}
