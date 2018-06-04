<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UserBadges extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'user_badges';
    
    /* Add the fillable property into the Badges Model */
    protected $fillable = ['user_id', 'badge_id'];
}
