<?php

namespace App\Http\Controllers;

use App\Services\Kyc\AutomaticKycService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Throwable;

class AutomaticKycController extends Controller
{
    public function verifyPan(Request $request, AutomaticKycService $kyc): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'pan' => ['required', 'string', 'regex:/^[A-Za-z]{5}[0-9]{4}[A-Za-z]$/'],
        ]);
        if ($validator->fails()) return response()->json(['message' => 'Enter a valid PAN number.', 'errors' => $validator->errors()], 422);

        try {
            $result = $kyc->verifyPan($request->pan);
            return response()->json(['status' => 'verified', 'data' => $result]);
        } catch (Throwable $e) {
            report($e);
            return response()->json(['status' => 'failed', 'message' => 'PAN verification could not be completed.'], 502);
        }
    }

    public function startAadhaar(Request $request, AutomaticKycService $kyc): JsonResponse
    {
        try {
            return response()->json($kyc->startAadhaarVerification());
        } catch (Throwable $e) {
            report($e);
            return response()->json(['status' => 'failed', 'message' => 'Aadhaar verification is not available.'], 503);
        }
    }
}
