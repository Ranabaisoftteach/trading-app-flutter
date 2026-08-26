<?php

namespace App\Http\Controllers;

use App\Services\Broker\AngelOneAuthService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Throwable;

class BrokerConnectController extends Controller
{
    public function angelOneConnect(Request $request, AngelOneAuthService $auth): JsonResponse
    {
        $validated = $request->validate([
            'client_code' => ['required', 'string', 'max:32'],
            'pin' => ['required', 'string', 'max:32'],
            'totp' => ['required', 'digits:6'],
        ]);

        try {
            $result = $auth->login($validated['client_code'], $validated['pin'], $validated['totp']);
            $token = $result['data']['jwtToken'] ?? null;
            $refreshToken = $result['data']['refreshToken'] ?? null;

            if (!$token) {
                return response()->json(['message' => 'Broker token was not returned.'], 502);
            }

            $key = 'broker:angelone:' . $request->user()->id;
            Cache::put($key, [
                'jwt_token' => $token,
                'refresh_token' => $refreshToken,
                'client_code' => $validated['client_code'],
            ], now()->addHours(12));

            return response()->json([
                'connected' => true,
                'broker' => 'angelone',
                'client_code' => $validated['client_code'],
            ]);
        } catch (Throwable $e) {
            report($e);
            return response()->json(['message' => 'Angel One connection failed.'], 502);
        }
    }

    public function angelOneDisconnect(Request $request): JsonResponse
    {
        Cache::forget('broker:angelone:' . $request->user()->id);
        return response()->json(['connected' => false, 'broker' => 'angelone']);
    }
}
