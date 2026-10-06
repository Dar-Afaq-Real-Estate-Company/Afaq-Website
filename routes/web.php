<?php

use Illuminate\Support\Facades\Route;
use Mcamara\LaravelLocalization\Facades\LaravelLocalization;

Auth::routes(['verify' => true]);

//منع المستخدم من تسجيل الدخول لو الايميل مش متحقق
Route::group([
    'middleware' => ['auth', 'verified']
], function () {
    Route::get('/home', [HomeController::class, 'index']);
});

Route::group(
[
	'prefix' => LaravelLocalization::setLocale(),
	'middleware' => [ 'localeSessionRedirect', 'localizationRedirect', 'localeViewPath' ]
], function(){
 Route::POST('verifystore/', [App\Http\Controllers\verifyController::class,'update'])->name('verify.store');
 Route::POST('Mailsendstore/', [App\Http\Controllers\HomeController::class,'send'])->name('verify.send');
 Route::POST('userr/', [App\Http\Controllers\verifyController::class,'create'])->name('userr.create');

 Route::get('/Verifyphone', [App\Http\Controllers\HomeController::class,'Verifyphone'])->name('Verifyphone');
 Route::get('/Mailsend', [App\Http\Controllers\HomeController::class,'Mailsend'])->name('Mailsend');

///////////////هنا كان مكانها


Route::get('/Aboutus', [App\Http\Controllers\detailsController::class, 'Aboutus'])->name('Aboutus');
Route::get('/', [App\Http\Controllers\SiteController::class, 'home'])->name('welcome');
Route::get('/properties-list', [App\Http\Controllers\SiteController::class, 'properties'])->name('site.properties');
Route::get('/property/{id}', [App\Http\Controllers\SiteController::class, 'property'])->whereNumber('id')->name('site.property');
Route::get('/section/{kind}', [App\Http\Controllers\SiteController::class, 'directory'])
    ->whereIn('kind', ['contracting', 'jobs', 'companies', 'engineering', 'hotels'])->name('site.section');
Route::get('/section/{kind}/{id}', [App\Http\Controllers\SiteController::class, 'directoryShow'])
    ->whereIn('kind', ['contracting', 'jobs', 'companies', 'engineering', 'hotels'])->whereNumber('id')->name('site.section.show');
Route::get('/services', [App\Http\Controllers\SiteController::class, 'services'])->name('site.services');
Route::get('/plans', [App\Http\Controllers\SiteController::class, 'plans'])->name('site.plans');
Route::get('/policy', [App\Http\Controllers\NotificationsController::class, 'policy'])->name('policy');

Route::get('/show/{section?}/{type?}/{region?}', [App\Http\Controllers\advertisementController::class, 'show'])
    ->name('sections.show');
Route::get('/explore-ads/{section}/{type}', [App\Http\Controllers\advertisementController::class, 'filterAds'])
    ->name('browse.ads');
Route::get('/search', [App\Http\Controllers\detailsController::class, 'search'])->name('search');

Route::get('/details/{id}', [App\Http\Controllers\detailsController::class, 'show'])
     ->name('details.show');
Route::get('/Aboutus', [App\Http\Controllers\HomeController::class, 'Aboutus'])->name('Aboutus');
});

Route::group(
[
	'prefix' => LaravelLocalization::setLocale(),
	'middleware' => [ 'localeSessionRedirect', 'localizationRedirect', 'localeViewPath','auth','verified','Verifyphone' ]
], function(){
    Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
 Route::get('/Quick', [App\Http\Controllers\detailsController::class, 'Quick'])->name('Quicks');
Route::put('/profile/update', [App\Http\Controllers\ProfileControllerController::class, 'update'])->name('profile.update');
Route::get('/advertisement', [App\Http\Controllers\HomeController::class, 'advertisement'])->name('advertisement');
Route::post('/advertisement_stor', [App\Http\Controllers\advertisementController::class, 'store'])->name('advertisement.stor');
Route::post('/advertisement_update', [App\Http\Controllers\advertisementController::class, 'update'])->name('advertisement.update');
Route::get('/notifications', [App\Http\Controllers\NotificationsController::class, 'index'])->name('notifications');
// هذا الراوت لعرض الصفحة الرئيسية مع ميزة الفلترة والبحث
Route::get('/properties', [App\Http\Controllers\advertisementController::class, 'search'])->name('properties.index');

Route::get('/details', [App\Http\Controllers\detailsController::class, 'index'])->name('details');
Route::get('/detail/{id}', [App\Http\Controllers\detailsController::class, 'destroy'])->name('destroy.detail');
});

use Illuminate\Support\Facades\Mail;

Route::get('/test-mail', function () {

    try {

        Mail::raw('اختبار إرسال بريد من آفاق العقاري', function ($message) {
            $message->to('hanibaghawitah@gmail.com');
            $message->subject('اختبار البريد');
        });

        return 'Mail Sent Successfully';

    } catch (\Exception $e) {

        return $e->getMessage();
    }
});
