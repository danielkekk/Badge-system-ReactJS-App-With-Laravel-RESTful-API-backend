<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
Route::post('login', 'API\PassportController@login');
Route::post('register', 'API\PassportController@register');
Route::post('logout', 'API\PassportController@logout');

/*Admin functions*/
Route::group(['middleware' => ['auth:api' , 'scope:admin']], function() {
    Route::get('getbadges', 'API\PassportController@getBadges');
    Route::get('badge/{id}', 'API\PassportController@getBadgeById');
    Route::post('badge', 'API\PassportController@createBadge');
    Route::patch('badge/{id}', 'API\PassportController@updateBadgeById');
    Route::delete('badge/{id}', 'API\PassportController@deleteBadgeById');
    
    Route::get('getusers', 'API\PassportController@getUsers');
    Route::patch('user/{id}', 'API\PassportController@updateUserById');
    Route::delete('user/{id}', 'API\PassportController@deleteUserById');
    
    Route::post('/user/{userId}/badge/{badgeId}', 'API\PassportController@addBadgeToUser');
    Route::delete('/user/{userId}/badge/{badgeId}', 'API\PassportController@removeBadgeFromUser');
    Route::post('fileupload', 'API\PassportController@storeBadgeImage');
});

/*Dashboard statistics*/
Route::group(['middleware' => ['auth:api' , 'scope:admin']], function() {
    Route::get('getallusersbadgenum', 'API\PassportController@getAllUsersBadgeNum'); //legtöbb badge-dzsel rendelkező felhasználók: egy assoc tömbben visszaadjuk melyik user mennyi db badgel rendelkezik
    Route::get('getallusersxpnum', 'API\PassportController@getAllUsersXpNum'); //adott usernek mennyi xpje van
    Route::get('getallbadgesnum', 'API\PassportController@getAllBadgesNum'); //melyik badge van meg a legtöbb felhasználónak: adott badge hány darab felhasználóhoz tartozik
});

/*User functions*/
Route::group(['middleware' => ['auth:api' , 'scope:user']], function() {
    Route::post('user', 'API\PassportController@getUserById');
    Route::post('userbadges', 'API\PassportController@getBadgesByUserId');
});
