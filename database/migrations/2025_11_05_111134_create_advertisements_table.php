<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('advertisements', function (Blueprint $table) {
            $table->id();
            $table->Integer('plan_price');
            $table->string('plan_name');
            $table->string('transaction_type');
            $table->Integer('phone');
            $table->string('title');
            $table->string('description');
            $table->string('type');
            $table->string('region');
            $table->Integer('rooms');
            $table->Integer('bathrooms');
            $table->Integer('halls');
            $table->Integer('area');
            $table->Integer('price');
            $table->string('address');
            $table->text('images');
            $table->text('video');
            $table->unsignedBigInteger('user_id')->nullable();
            $table->foreign('user_id')->references('id')->on('users')->nullable()->default(null);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('advertisements');
    }
};
