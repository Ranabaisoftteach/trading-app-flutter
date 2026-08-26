<?php

namespace App\Http\Controllers;

use App\Services\Broker\AngelOneMarketDataService;
use Illuminate\Http\Request;

class AngelOneMarketDataController extends Controller
{
    public function ltp(Request $request, AngelOneMarketDataService $service)
    {
        $data = $request->validate([
            'exchange' => ['required','string','max:20'],
            'tradingsymbol' => ['required','string','max:100'],
            'symboltoken' => ['required','string','max:50'],
        ]);

        return response()->json($service->ltp($data['exchange'], $data['tradingsymbol'], $data['symboltoken']));
    }
}
