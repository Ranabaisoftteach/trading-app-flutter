<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\KycController;
use App\Http\Controllers\AutomaticKycController;
use App\Http\Controllers\BrokerConnectController;
use App\Http\Controllers\AngelOneDataController;
use App\Http\Controllers\AngelOneOrderController;
use App\Http\Controllers\HyperVergeWebhookController;

Route::post('/auth/register', [RegisterController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/webhooks/hyperverge/kyc', [HyperVergeWebhookController::class, 'handle']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/kyc/status', [KycController::class, 'status']);
    Route::post('/kyc/submit', [KycController::class, 'submit']);
    Route::post('/kyc/pan/verify', [AutomaticKycController::class, 'verifyPan']);
    Route::post('/kyc/aadhaar/start', [AutomaticKycController::class, 'startAadhaar']);

    Route::post('/broker/angelone/connect', [BrokerConnectController::class, 'angelOneConnect']);
    Route::post('/broker/angelone/disconnect', [BrokerConnectController::class, 'angelOneDisconnect']);
    Route::get('/broker/angelone/profile', [AngelOneDataController::class, 'profile']);
    Route::get('/broker/angelone/funds', [AngelOneDataController::class, 'funds']);
    Route::get('/broker/angelone/holdings', [AngelOneDataController::class, 'holdings']);
    Route::get('/broker/angelone/positions', [AngelOneDataController::class, 'positions']);
    Route::get('/broker/angelone/orders', [AngelOneDataController::class, 'orders']);
    Route::get('/broker/angelone/trades', [AngelOneDataController::class, 'trades']);
    Route::post('/broker/angelone/quote', [AngelOneDataController::class, 'quote']);
    Route::post('/broker/angelone/orders', [AngelOneOrderController::class, 'place']);
    Route::post('/broker/angelone/orders/{orderId}/cancel', [AngelOneOrderController::class, 'cancel']);
});
