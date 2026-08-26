<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\KycController;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/kyc/status', [KycController::class, 'status']);
    Route::post('/kyc/submit', [KycController::class, 'submit']);
});
