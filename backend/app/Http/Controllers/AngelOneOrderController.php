<?php

namespace App\Http\Controllers;

use App\Services\Broker\AngelOneSmartApiBroker;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;
use Throwable;

class AngelOneOrderController extends Controller
{
    public function place(Request $request): JsonResponse
    {
        $data = $request->validate([
            'variety' => ['required', 'string', 'in:NORMAL,STOPLOSS,ROBO,AMO'],
            'tradingsymbol' => ['required', 'string', 'max:40'],
            'symboltoken' => ['required', 'string', 'max:30'],
            'transactiontype' => ['required', 'string', 'in:BUY,SELL'],
            'exchange' => ['required', 'string', 'in:NSE,BSE,NFO,MCX'],
            'ordertype' => ['required', 'string', 'in:MARKET,LIMIT,STOPLOSS_LIMIT,STOPLOSS_MARKET'],
            'producttype' => ['required', 'string', 'in:DELIVERY,CARRYFORWARD,MARGIN,INTRADAY,BO'],
            'duration' => ['required', 'string', 'in:DAY,IOC'],
            'price' => ['nullable', 'numeric', 'min:0'],
            'triggerprice' => ['nullable', 'numeric', 'min:0'],
            'quantity' => ['required', 'integer', 'min:1'],
        ]);

        if (in_array($data['ordertype'], ['LIMIT', 'STOPLOSS_LIMIT'], true) && empty($data['price'])) {
            return response()->json(['message' => 'Price is required for limit orders.'], 422);
        }

        if (in_array($data['ordertype'], ['STOPLOSS_LIMIT', 'STOPLOSS_MARKET'], true) && empty($data['triggerprice'])) {
            return response()->json(['message' => 'Trigger price is required for stop-loss orders.'], 422);
        }

        $userId = $request->user()->id;
        $jwt = Cache::get("angelone:jwt:$userId");
        if (!$jwt) return response()->json(['message' => 'Angel One account is not connected.'], 401);

        $idempotency = $request->header('Idempotency-Key') ?: (string) Str::uuid();
        $cacheKey = "angelone:order:$userId:$idempotency";
        if ($existing = Cache::get($cacheKey)) return response()->json($existing);

        try {
            $broker = new AngelOneSmartApiBroker($jwt, Cache::get("angelone:refresh:$userId"));
            $result = $broker->placeOrder([
                'variety' => $data['variety'],
                'tradingsymbol' => $data['tradingsymbol'],
                'symboltoken' => $data['symboltoken'],
                'transactiontype' => $data['transactiontype'],
                'exchange' => $data['exchange'],
                'ordertype' => $data['ordertype'],
                'producttype' => $data['producttype'],
                'duration' => $data['duration'],
                'price' => (string) ($data['price'] ?? 0),
                'triggerprice' => (string) ($data['triggerprice'] ?? 0),
                'squareoff' => '0',
                'stoploss' => '0',
                'quantity' => (string) $data['quantity'],
            ]);

            $response = ['message' => 'Order submitted to Angel One.', 'data' => $result, 'idempotency_key' => $idempotency];
            Cache::put($cacheKey, $response, now()->addMinutes(10));
            return response()->json($response, 201);
        } catch (Throwable $e) {
            report($e);
            return response()->json(['message' => 'Order submission failed.'], 502);
        }
    }

    public function cancel(Request $request, string $orderId): JsonResponse
    {
        $data = $request->validate(['variety' => ['nullable', 'string', 'in:NORMAL,STOPLOSS,ROBO,AMO']]);
        $userId = $request->user()->id;
        $jwt = Cache::get("angelone:jwt:$userId");
        if (!$jwt) return response()->json(['message' => 'Angel One account is not connected.'], 401);

        try {
            $broker = new AngelOneSmartApiBroker($jwt, Cache::get("angelone:refresh:$userId"));
            return response()->json([
                'message' => 'Cancel request submitted.',
                'data' => $broker->cancelOrder($orderId, $data['variety'] ?? 'NORMAL'),
            ]);
        } catch (Throwable $e) {
            report($e);
            return response()->json(['message' => 'Cancel request failed.'], 502);
        }
    }
}
