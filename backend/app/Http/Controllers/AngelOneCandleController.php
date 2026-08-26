<?php

namespace App\Http\Controllers;

use App\Services\Broker\AngelOneCandleService;
use Illuminate\Http\Request;

class AngelOneCandleController extends Controller
{
    public function candles(Request $request, AngelOneCandleService $service)
    {
        $data = $request->validate([
            'exchange' => ['required','string','max:20'],
            'symboltoken' => ['required','string','max:50'],
            'interval' => ['required','in:ONE_MINUTE,THREE_MINUTE,FIVE_MINUTE,TEN_MINUTE,FIFTEEN_MINUTE,THIRTY_MINUTE,ONE_HOUR,ONE_DAY'],
            'fromdate' => ['required','date_format:Y-m-d H:i'],
            'todate' => ['required','date_format:Y-m-d H:i'],
        ]);
        return response()->json($service->candles(...array_values($data)));
    }
}
