<?php

namespace App\Http\Controllers;

use App\Services\Broker\AngelOneSmartApiBroker;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Throwable;

class AngelOneDataController extends Controller
{
    public function profile(Request $request): JsonResponse { return $this->call($request, fn (AngelOneSmartApiBroker $broker) => $broker->profile()); }
    public function funds(Request $request): JsonResponse { return $this->call($request, fn (AngelOneSmartApiBroker $broker) => $broker->funds()); }
    public function holdings(Request $request): JsonResponse { return $this->call($request, fn (AngelOneSmartApiBroker $broker) => $broker->holdings()); }
    public function positions(Request $request): JsonResponse { return $this->call($request, fn (AngelOneSmartApiBroker $broker) => $broker->positions()); }
    public function orders(Request $request): JsonResponse { return $this->call($request, fn (AngelOneSmartApiBroker $broker) => $broker->orders()); }
    public function trades(Request $request): JsonResponse { return $this->call($request, fn (AngelOneSmartApiBroker $broker) => $broker->trades()); }

    public function quote(Request $request): JsonResponse
    {
        $request->validate([
            'exchange' => ['required', 'string'],
            'tradingsymbol' => ['required', 'string'],
            'symbol_token' => ['required', 'string'],
        ]);
        return $this->call($request, fn (AngelOneSmartApiBroker $broker) => $broker->quote(
            $request->string('exchange')->toString(),
            $request->string('tradingsymbol')->toString(),
            $request->string('symbol_token')->toString(),
        ));
    }

    private function call(Request $request, callable $callback): JsonResponse
    {
        $userId = $request->user()->id;
        $jwt = Cache::get("angelone:jwt:$userId");
        if (!$jwt) return response()->json(['message' => 'Angel One account is not connected.'], 401);

        try {
            $refresh = Cache::get("angelone:refresh:$userId");
            return response()->json($callback(new AngelOneSmartApiBroker($jwt, $refresh)));
        } catch (Throwable $e) {
            report($e);
            return response()->json(['message' => 'Angel One API request failed.'], 502);
        }
    }
}
