<?php

namespace App\Http\Controllers;
use Schema;
use DB;
use App\User;
use App\Badges;

class InitDbController extends Controller
{
    public function initDb() {
        
        if (Schema::hasTable('user_badges')) {
            Schema::table('user_badges', function ($table) {
                $table->dropForeign('user_badges_user_id_foreign');
                $table->dropForeign('user_badges_badge_id_foreign');
            });
        }
        
        
        /*Létrehozás*/
        Schema::dropIfExists('users');
        Schema::dropIfExists('badges');
        Schema::dropIfExists('user_badges');
        
        Schema::create('users', function($table)
        {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->string('name');
            $table->string('email')->unique();
            $table->string('password');
            $table->rememberToken();
            $table->timestamps();
            $table->text('api_token')->nullable();
            $table->tinyInteger('role')->unsigned()->default(2);
        });
        
        Schema::create('badges', function($table)
        {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->string('description');
            $table->string('name');
            $table->smallInteger('xp')->unsigned()->default(100);
            $table->string('filename')->default('nopic.png');
        });
        
        Schema::enableForeignKeyConstraints();
        Schema::create('user_badges', function($table)
        {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('badge_id');
            $table->unsignedInteger('user_id');
            $table->foreign('badge_id')->references('id')->on('badges')->onDelete('cascade')->onUpdate('cascade');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade')->onUpdate('cascade');
        });

        
        /*Feltöltés*/
        $initUsers = $this->openJsonToAssocArray('initUser');
        foreach($initUsers as $user) {
            $usertable = new User;
            $usertable->email = $user['email'];
            $usertable->name = $user['name'];
            $usertable->role = $user['role'];
            $usertable->password = bcrypt($user['password']);
            $usertable->save();
            
            //DB::table('users')->insert($user);
        }
        
        $initBadges = $this->openJsonToAssocArray('initBadge');
        foreach($initBadges as $badge) {
            DB::table('badges')->insert($badge);
        }
    }
    
    private function openJsonToAssocArray($filename) {
        $path = resource_path('initdata/' . $filename . '.json');
        $json = json_decode(file_get_contents($path), true); 
        
        return $json;
    }
}
