<?php

namespace App\Services\Kyc;

use RuntimeException;

class AutomaticKycService
{
    public function verifyPan(string $pan): array
    {
        if (!config('hyperverge_modules.enabled.pan')) {
            throw new RuntimeException('PAN verification is disabled.');
        }

        return app(HyperVergeKycProvider::class)->verifyPan([
            'pan' => strtoupper($pan),
        ]);
    }

    public function startAadhaarVerification(): array
    {
        if (!config('hyperverge_modules.enabled.digilocker')) {
            throw new RuntimeException('Aadhaar/DigiLocker verification is not enabled for this account.');
        }

        return [
            'status' => 'pending',
            'message' => 'Start the authorized DigiLocker/Aadhaar verification flow.',
        ];
    }
}
