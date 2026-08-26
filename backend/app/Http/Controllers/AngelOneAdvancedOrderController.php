<?php

namespace App\Http\Controllers;

use App\Services\Broker\AngelOneAdvancedOrderService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Throwable;

class AngelOneAdvancedOrderController extends Controller
{
    public function modify(Request $request, AngelOneAdvancedOrderService $service): JsonResponse
    {
        $data = $request->validate([
            'orderid' => ['required','string','max:50'], 'variety' => ['required','string','in:NORMAL,STOPLOSS,ROBO,AMO'],
            'tradingsymbol' => ['required','string','max:40'], 'symboltoken' => ['required','string','max:30'],
            'transactiontype' => ['required','in:BUY,SELL'], 'exchange' => ['required','in:NSE,BSE,NFO,MCX'],
            'ordertype' => ['required','in:MARKET,LIMIT,STOPLOSS_LIMIT,STOPLOSS_MARKET'],
            'producttype' => ['required','in:DELIVERY,CARRYFORWARD,MARGIN,INTRADAY,BO'], 'duration' => ['required','in:DAY,IOC'],
            'price' => ['nullable','numeric','min:0'], 'triggerprice' => ['nullable','numeric','min:0'], 'quantity' => ['required','integer','min:1'],
        ]);
        $jwt = Cache::get('angelone:jwt:'.$request->user()->id);
        if (!$jwt) return response()->json(['message'=>'Angel One account is not connected.'],401);
        try { return response()->json(['message'=>'Order modification submitted.','data'=>$service->modify($jwt,$data)]); }
        catch (Throwable $e) { report($e); return response()->json(['message'=>'Order modification failed.'],502); }
    }

    public function status(Request $request, string $orderId, AngelOneAdvancedOrderService $service): JsonResponse
    {
        $jwt = Cache::get('angelone:jwt:'.$request->user()->id);
        if (!$jwt) return response()->json(['message'=>'Angel One account is not connected.'],401);
        try { return response()->json(['data'=>$service->status($jwt,$orderId)]); }
        catch (Throwable $e) { report($e); return response()->json(['message'=>'Unable to fetch order status.'],502); }
    }

    public function book(Request $request, AngelOneAdvancedOrderService $service): JsonResponse
    {
        $jwt = Cache::get('angelone:jwt:'.$request->user()->id);
        if (!$jwt) return response()->json(['message'=>'Angel One account is not connected.'],401);
        try { return response()->json($service->book($jwt)); }
        catch (Throwable $e) { report($e); return response()->json(['message'=>'Unable to fetch order book.'],502); }
    }
}
