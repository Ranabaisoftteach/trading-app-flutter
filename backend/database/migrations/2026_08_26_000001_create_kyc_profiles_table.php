<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('kyc_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->unique()->constrained()->cascadeOnDelete();
            $table->string('full_name', 120);
            $table->date('date_of_birth');
            $table->string('pan_number', 10);
            $table->string('account_number', 34);
            $table->string('ifsc', 11);
            $table->string('provider_transaction_id')->nullable()->unique();
            $table->string('status', 30)->default('not_started')->index();
            $table->text('rejection_reason')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kyc_profiles');
    }
};
