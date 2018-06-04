<?php
namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

use App\User;

class BadgeMail extends Mailable
{
    use Queueable, SerializesModels;

	public $user;
	public $newbadge;
	
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct(User $user, int $newbadge)
    {
        $this->user = $user;
		$this->newbadge = $newbadge;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return ($this->newbadge == 1) ? $this->view('emails.addbadgeemail') : $this->view('emails.removebadgeemail');
    }
}
