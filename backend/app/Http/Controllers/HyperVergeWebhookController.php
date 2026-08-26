<?php

namespace App\Http\Controllers;

use App\Models\KycProfile;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class HyperVergeWebhookController extends Controller
{
    public function handle(Request $request): JsonResponse
    {
        // Configure the provider's webhook signing secret in production.
        $secret = config('services.hyperverge.webhook_secret');
        if ($secret) {
            $signature = (string) $request->header('X-HV-Signature');
            $expected = hash_hmac('sha256', $request->getContent(), $secret);
            if (!$signature || !hash_equals($expected, $signature)) {
                return response()->json(['message' => 'Invalid webhook signature.'], 401);
            }
        }

        $payload = $request->all();
        Log::info('HyperVerge KYC webhook received', [
            'transaction_id' => $payload['transactionId'] ?? $payload['transaction_id'] ?? null,
            'status' => $payload['status'] ?? $payload['result']['status'] ?? null,
        ]);

        $transactionId = $payload['transactionId'] ?? $payload['transaction_id'] ?? null;
        $status = strtolower((string) ($payload['status'] ?? $payload['result']['status'] ?? $payload['data']['status'] ?? ''));
        $userId = $payload['userId'] ?? $payload['user_id'] ?? null;

        $mapped = match (true) {
            in_array($status, ['success', 'verified', 'approved', 'valid'], true) => 'verified',
            in_array($status, ['failure', 'failed', 'rejected', 'invalid', 'declined'], true) => 'rejected',
            default => 'under_review',
        };

        $query = KycProfile::query();
        if ($userId) {
            $query->where('user_id', $userId);
        } elseif ($transactionId) {
            $query->where('provider_transaction_id', $transactionId);
        } else {
            return response()->json(['message' => 'Webhook identifier missing.'], 422);
        }

        $kyc = $query->first();
        if (!$kyc) {
            return response()->json(['message' => 'KYC record not found.'], 404);
        }

        $kyc->update([
            'status' => $mapped,
            'rejection_reason' => $mapped === 'rejected' ? (string) ($payload['message'] ?? $payload['error'] ?? 'Verification failed.') : null,
        ]);

        return response()->json(['received' => true, 'status' => $mapped]);
    }
}
