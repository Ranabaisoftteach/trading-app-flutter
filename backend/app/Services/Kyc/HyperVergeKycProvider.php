<?php

namespace App\Services\Kyc;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;
use RuntimeException;

class HyperVergeKycProvider
{
    public function verifyPanAndBank(array $data): array
    {
        $appId = config('services.hyperverge.app_id');
        $appKey = config('services.hyperverge.app_key');
        $url = config('services.hyperverge.vendor_validation_url');

        if (!$appId || !$appKey || !$url) {
            throw new RuntimeException('HyperVerge KYC provider is not configured.');
        }

        $response = Http::timeout(30)
            ->withHeaders([
                'appId' => $appId,
                'appKey' => $appKey,
                'transactionid' => (string) Str::uuid(),
                'Accept' => 'application/json',
            ])
            ->post($url, [
                'pan' => strtoupper($data['pan']),
                'nameOnCard' => $data['name'],
                'dateOfBirth' => $data['dob'],
                'accountNumber' => $data['account_number'],
                'ifsc' => strtoupper($data['ifsc']),
            ]);

        if ($response->failed()) {
            throw new RuntimeException('KYC provider request failed: HTTP '.$response->status());
        }

        return $response->json();
    }
}
