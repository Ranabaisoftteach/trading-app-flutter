<?php

namespace App\Http\Controllers;

use App\Models\KycProfile;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

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

    public function submit(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'max:120'],
            'dob' => ['required', 'date'],
            'pan' => ['required', 'string', 'regex:/^[A-Z]{5}[0-9]{4}[A-Z]$/'],
            'account_number' => ['required', 'string', 'max:34'],
            'ifsc' => ['required', 'string', 'regex:/^[A-Z]{4}0[A-Z0-9]{6}$/'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Invalid KYC details.', 'errors' => $validator->errors()], 422);
        }

        $kyc = KycProfile::updateOrCreate(
            ['user_id' => $request->user()->id],
            [
                'full_name' => $request->name,
                'date_of_birth' => $request->dob,
                'pan_number' => $request->pan,
                'account_number' => $request->account_number,
                'ifsc' => strtoupper($request->ifsc),
                'status' => 'under_review',
                'rejection_reason' => null,
            ]
        );

        return response()->json([
            'status' => $kyc->status,
            'message' => 'KYC submitted for review.',
        ], 202);
    }
}
