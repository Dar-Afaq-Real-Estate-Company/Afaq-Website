<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Auth\Notifications\VerifyEmail;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        VerifyEmail::toMailUsing(function ($notifiable, $url) {

            return (new \Illuminate\Notifications\Messages\MailMessage)
                ->subject('تفعيل الحساب')
                ->line('اضغط على الزر التالي لتفعيل حسابك')
                ->action('تفعيل الحساب', $url)
                ->line('شكراً لاستخدامك منصة آفاق');
        });
    }
}