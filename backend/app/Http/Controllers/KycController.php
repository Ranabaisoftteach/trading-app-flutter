<?php

namespace App\Http\Controllers;

use App\Models\KycProfile;
use App\Services\Kyc\HyperVergeKycProvider;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Throwable;

class KycController extends Controller
{
    public function status(Request $request): JsonResponse
    {
        $kyc = KycProfile::where('user_id', $request->user()->id)->first();

        return response()->json([
            'status' => $kyc?->status ?? 'not_started',
            'message' => $kyc?->rejection_reason ?? '',
        ]);
    }

    public function submit(Request $request, HyperVergeKycProvider $provider): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'max:120'],
            'dob' => ['required', 'date'],
            'pan' => ['required', 'string', 'regex:/^[A-Za-z]{5}[0-9]{4}[A-Za-z]$/'],
            'account_number' => ['required', 'string', 'max:34'],
            'ifsc' => ['required', 'string', 'regex:/^[A-Za-z]{4}0[A-Za-z0-9]{6}$/'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Invalid KYC details.', 'errors' => $validator->errors()], 422);
        }

        $kyc = KycProfile::updateOrCreate(
            ['user_id' => $request->user()->id],
            [
                'full_name' => $request->name,
                'date_of_birth' => $request->dob,
                'pan_number' => strtoupper($request->pan),
                'account_number' => $request->account_number,
                'ifsc' => strtoupper($request->ifsc),
                'status' => 'under_review',
                'rejection_reason' => null,
            ]
        );

        try {
            $result = $provider->verifyPanAndBank([
                'name' => $kyc->full_name,
                'dob' => $kyc->date_of_birth->format('Y-m-d'),
                'pan' => $kyc->pan_number,
                'account_number' => $kyc->account_number,
                'ifsc' => $kyc->ifsc,
            ]);

            $status = $this->mapProviderStatus($result);
            $kyc->update([
                'status' => $status,
                'rejection_reason' => $status === 'rejected' ? $this->providerMessage($result) : null,
            ]);

            return response()->json([
                'status' => $kyc->status,
                'message' => $status === 'verified' ? 'KYC verified successfully.' : ($status === 'rejected' ? 'KYC verification failed.' : 'KYC submitted for review.'),
            ], $status === 'rejected' ? 422 : 200);
        } catch (Throwable $e) {
            report($e);
            $kyc->update(['status' => 'under_review']);

            return response()->json([
                'status' => 'under_review',
                'message' => 'Verification provider is temporarily unavailable. KYC remains under review.',
            ], 202);
        }
    }

    private function mapProviderStatus(array $result): string
    {
        $raw = strtolower((string) ($result['status'] ?? $result['result']['status'] ?? $result['data']['status'] ?? ''));
        if (in_array($raw, ['success', 'verified', 'approved', 'valid'], true)) return 'verified';
        if (in_array($raw, ['failure', 'failed', 'rejected', 'invalid', 'declined'], true)) return 'rejected';
        return 'under_review';
    }

    private function providerMessage(array $result): string
    {
        return (string) ($result['message'] ?? $result['error'] ?? $result['result']['message'] ?? 'Verification failed.');
    }
}
