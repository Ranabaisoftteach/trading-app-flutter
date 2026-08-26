<?php

namespace App\Http\Controllers;

use App\Services\Broker\AngelOneInstrumentService;
use Illuminate\Http\Request;

class AngelOneInstrumentController extends Controller
{
    public function search(Request $request, AngelOneInstrumentService $service)
    {
        $data = $request->validate(['q' => ['required','string','min:1','max:50']]);
        return response()->json(['status' => true, 'data' => $service->search($data['q'])]);
    }
}
