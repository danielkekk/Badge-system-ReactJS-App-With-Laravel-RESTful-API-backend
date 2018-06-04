<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('initdb', 'InitDbController@initDb');

Route::get('sendemail/{newbadge}', function ($newbadge) {
	$user = \App\User::findOrFail(3);
	Mail::to($user->email)->send(new \App\Mail\BadgeMail($user, (int)$newbadge));
});
