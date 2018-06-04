<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Badges extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'badges';
    
    /* Add the fillable property into the Badges Model */
    protected $fillable = ['name', 'description', 'xp', 'filename'];
}
