<?php
namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\User;
use App\UserBadges;
use App\Badges;
use Illuminate\Support\Facades\Auth;
use Validator;
use DB;
use File;
use App\Mail\BadgeMail;
use Mail;
use Log;

class PassportController extends Controller
{
    public $successStatus = 200;

    private function createErrorMessages($errorBag) {
        $errors = '';
        foreach($errorBag as $error) {
            $errors .= $error . ' ';
        }
        return $errors;
    }
    
    private function sendBadgeEmail($newBadge, $userId) {
        try{
            $user = User::findOrFail($userId);
            Mail::to($user->email)->send(new BadgeMail($user, $newbadge));
        } catch(Exception $e) {
            //log
        }
    }
    /**
     * login api
     *
     * @return \Illuminate\Http\Response
     */
    public function login(Request $request) 
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);
        
        if ($validator->fails()) {
            $errors = $this->createErrorMessages($validator->errors()->all());          
            return response()->json(['message'=>$errors], 401);            
        }
        
        $input = $request->all();
        
        if(Auth::attempt(['email' => $input['email'], 'password' => $input['password']])){
            $user = Auth::user();
            //lekérdezzük milyen joga van...ha van admin jog akkor admint adunk neki ha nincs akkor usert
            $scope = ((string)$user->role === '1') ? 'admin' : 'user';
            $success['token'] =  $user->createToken('MyApp', [$scope])->accessToken;
            $success['role'] = $user->role;
            $success['userid'] = $user->id;
            $success['name'] = $user->name;
            
            Log::info('User (id: '. $user->id .') logged in to the app.');
            
            return response()->json(['success' => $success], $this->successStatus);
        }
        else{
            return response()->json(['message'=>'Unauthorised'], 401);
        }
    }
    
    public function logout(Request $request)
    {
        try {
            $input = $request->all();
            $userIdByEmail = DB::select('SELECT id FROM users WHERE id = ? LIMIT 1', [$input['userid']]);
            if (empty($userIdByEmail)) {
                return response()->json(['message'=>'Nincs ilyen id-jű felhasználó'], 401);
            }
            
            $deletedRowNum = DB::delete('DELETE FROM oauth_access_tokens WHERE user_id = ?', [$input['userid']]);
            Log::info('User (id: '. $input['userid'] .') logged out.');
            return response()->json(['success' => $deletedRowNum], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }

    /**
     * Register api
     *
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        $input = $request->all();
        $validator = Validator::make($input, [
            'name' => 'required',
            'email' => 'required|email',
            'password' => 'required',
            'cpassword' => 'required|same:password',
        ]);

        if ($validator->fails()) {
            $errors = $this->createErrorMessages($validator->errors()->all());
            return response()->json(['message'=>$errors], 401);
        }

        $userWithSameEmail = DB::select('SELECT id FROM users WHERE email = ?', [$input['email']]);
        if (!empty($userWithSameEmail)) {
            return response()->json(['message'=>'A megadott email címmel már regisztráltak'], 401);
        }
        
        $input['password'] = bcrypt($input['password']);
        $user = User::create($input);
        $scope = ((string)$user->role === '1') ? 'admin' : 'user';
        $success['token'] =  $user->createToken('MyApp', [$scope])->accessToken;
        $success['name'] =  $user->name;

        return response()->json(['success'=>$success], $this->successStatus);
    }

    
    public function getBadges()
    {
        try {
            $badges = Badges::all();
            return response()->json(['success' => $badges], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function getBadgesByUserId(Request $request)
    {
        try {
            $input = $request->all();
            $userBadgesIds = UserBadges::select('badge_id')->where('user_id', '=', $input['userid'])->get();
            if (empty($userBadgesIds)) {
                return response()->json(['success' => $userBadgesIds], $this->successStatus);
            }
            
            $badgeids = [];
            foreach($userBadgesIds as $badgeId) {
                $badgeids[] = $badgeId['badge_id'];
            }
            
            $userBadges = Badges::whereIn('id', $badgeids)->get();

            return response()->json(['success' => $userBadges], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function getBadgeById($id)
    {
        try {
            $badge = Badges::where('id', '=', $id)->get();
            return response()->json(['success' => $badge], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function createBadge(Request $request)
    {
        $input = $request->all();
        $validator = Validator::make($input, [
            'name' => 'required',
            'description' => 'required',
            'xp' => 'required|integer|between:100,10000',
        ]);

        if ($validator->fails()) {
            $errors = $this->createErrorMessages($validator->errors()->all());
            return response()->json(['message'=>$errors], 401);            
        }
        
        try {       
            $badgeWithSameName = DB::select('SELECT id FROM badges WHERE name = ?', [$input['name']]);
            if (!empty($badgeWithSameName)) {
                return response()->json(['message'=>'Error'], 401);
            }
            
            $badge = DB::insert('INSERT INTO badges (name, description, xp) values (?, ?, ?)', [$input['name'],$input['description'],$input['xp']]);
            return response()->json(['success' => 'inserted'], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function updateBadgeById(Request $request, $id)
    {
        $input = $request->all();
        $validator = Validator::make($input, [
            'name' => 'required',
            'description' => 'required',
            'xp' => 'required|integer|between:100,10000',
        ]);

        if ($validator->fails()) {
            $errors = $this->createErrorMessages($validator->errors()->all());
            return response()->json(['message'=>$errors], 401);            
        }
        
        try {           
            $badgeWithSameName = DB::select('SELECT id FROM badges WHERE name = ?', [$input['name']]);
            if (!empty($badgeWithSameName)) {
                return response()->json(['message'=>'A megadott név már létezik'], 401);
            }
            
            $badgeRowNum = DB::update('UPDATE badges SET name = ?, description = ?, xp = ? WHERE id = ?', [$input['name'],$input['description'],$input['xp'],(int)$input['id']]);
            return response()->json(['success' => $badgeRowNum], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function deleteBadgeById($id)
    {
        try {
            $badge_exists = DB::select('SELECT filename FROM badges WHERE id = ? LIMIT 1', [$id]);
            if (empty($badge_exists)) {
                return response()->json(['message'=>'Nincs ilyen idjű badge.'], 401);
            }
            $deletedRowNum = DB::delete('DELETE FROM badges WHERE id = ?', [$id]);
            $img_filename = $badge_exists[0]->filename;
            File::delete(public_path('uploads/' . $img_filename));
            
            return response()->json(['success' => $deletedRowNum], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function kepTorles($id) {
        //TODO ha egy olyan dolgot törlünk ami elsődlege volt mi lesz az elsődleges?
        //töröljük az id értékű képet 
        $getEgyHirdetesKep = ModelController::getHirdetesControllerEgyHirdetesKep($id);

        if ($getEgyHirdetesKep) {
            $fajlnev = $getEgyHirdetesKep[0]->fajlnev;
            ModelController::deleteHirdetesControllerEgyHirdetesKep($id);
            File::delete('uploads/' . 'hirdetes_' . $getEgyHirdetesKep[0]->idHirdetesek . '/' . $fajlnev);
            //kitöröljük a képet is
            return redirect()->back();
        }   
    }
    
    
    /*Users functions */
    public function getUsers()
    {
        try {
            $users = User::all();
            
            foreach($users as $user) {
                $user['badges'] = DB::select('SELECT b.* FROM user_badges AS ub, badges AS b WHERE ub.badge_id = b.id AND ub.user_id = ?', [$user['id']]);
            }
            return response()->json(['success' => $users], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function getUserById(Request $request)
    {
        try {
            $input = $request->all();
            $user = User::where('id', '=', $input['userid'])->get();
            if (empty($user)) {
                return response()->json(['message'=>'Nincs ilyen id-val felhasználó'], 401);
            }
            
            return response()->json(['success' => $user[0]], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function addBadgeToUser($userId, $badgeId)
    {
        try {
            $badgeDoesNotExist = DB::select('SELECT id FROM badges WHERE id = ?', [$badgeId]);
            if (empty($badgeDoesNotExist)) {
                return response()->json(['message'=>'Ilyen idjű badge nem létezik'], 401);
            }
            
            $userDoesNotExist = DB::select('SELECT id FROM users WHERE id = ?', [$userId]);
            if (empty($userDoesNotExist)) {
                return response()->json(['message'=>'Ilyen idjű felhasználó nem létezik'], 401);
            }
            
            $badgeExists = DB::select('SELECT id FROM user_badges WHERE user_id = ? AND badge_id = ?', [$userId, $badgeId]);
            if (!empty($badgeExists)) {
                return response()->json(['message'=>'Ilyen már meg van adva a felhasználóhoz'], 401);
            }
            
            $insertedRowNum = DB::delete('INSERT INTO user_badges (user_id, badge_id) VALUES (?, ?)', [$userId, $badgeId]);
            
            try{
                $user = User::findOrFail($userId);
                Mail::to($user->email)->send(new BadgeMail($user, 1));
            } catch(Exception $e) {
                //log
            }
            
            return response()->json(['success' => $insertedRowNum], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function removeBadgeFromUser($userId, $badgeId)
    {
        try {
            $badgeExists = DB::select('SELECT id FROM user_badges WHERE user_id = ? AND badge_id = ?', [(int)$userId, (int)$badgeId]);
            if (empty($badgeExists)) {
                return response()->json(['message'=>'Error'], 401);
            }
            
            $deletedRowNum = DB::delete('DELETE FROM user_badges WHERE user_id = ? AND badge_id = ?', [(int)$userId, (int)$badgeId]);
            
            try{
                $user = User::findOrFail($userId);
                Mail::to($user->email)->send(new BadgeMail($user, 0));
            } catch(Exception $e) {
                //log
            }
            
            return response()->json(['success' => $deletedRowNum], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function updateUserById(Request $request, $id)
    {
        $input = $request->all();
        $validator = Validator::make($input, [
            'name' => 'required',
            'email' => 'required|email',
            'role' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['message'=>'Error'], 401);            
        }
        
        try {           
            $userExists = User::where('id', $id)->get();
            if (empty($userExists)) {
                return response()->json(['message'=>'Ilyen id-val nem létezik user'], 401);
            }
            
            $userUpdatedRowNum = DB::update('UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?', [$input['name'], $input['email'], $input['role'], $id]);
            return response()->json(['success' => $userUpdatedRowNum], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function deleteUserById($id)
    {
        try {
            $deletedRowNum = DB::delete('DELETE FROM users WHERE id = ?', [$id]);
            return response()->json(['success' => $deletedRowNum], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    /*Store a badge image */
    public function storeBadgeImage(Request $request)
    {
        $file = $request->file('file');
        $badgeid = (int)$request->input('badgeid');
        
        if (isset($file) && $badgeid > 0) {
            try {
                /*Kép metaadatok ellenőrzése*/
                if (strtolower($file->getClientOriginalExtension()) !== 'png') {
                    return response()->json(['message' => 'Feltölthető formátum: PNG'], 401);  
                }
                if ((int)$file->getSize() > 500000) {
                    return response()->json(['message' => 'Max méret: 0.5MB'], 401); 
                }
                list($width, $height) = getimagesize($file);
                if( !(($width>99 && $width<1025) && ($height>99 && $height<1025)) ) {
                    return response()->json(['message' => 'Min méret: 100x100 pixel, Max méret: 1024x1024 pixel'], 401); 
                }
                
                /*Ha a kép elfogadható elkezdődht a feltöltés*/
                $result = DB::select('SELECT filename FROM badges WHERE id = ? LIMIT 1', [$badgeid]); //ha van már feltöltve hozzá kép (nem az alapértelmezett) a fájlnév ugyanaz lesz, hogy felülíródjon           
                if (!empty($result)) {
                    $filename = (string)$result[0]->filename;
                    $name = ($filename === 'nopic.png' || strlen($filename) === 0) ? 'img_' . time() . '.png' : (string)$filename;
                } else {
                    return response()->json(['message'=>'Ilyen id-jű badge nem létezik'], 401);
                }
                
                $path = public_path('\uploads');
                if(!File::exists($path)) {
                    File::makeDirectory($path, $mode = 0777, true, true);
                }
                $file->move($path, $name);
                
                try {
                    $result = DB::update('UPDATE badges SET filename = ? WHERE id = ?', [$name, $badgeid]);
                    return response()->json(['success' => $result], $this->successStatus);
                } catch (Exception $e) {
                    return response()->json(['message'=>'Adatbázis hiba'], 401);            
                }
                
            } catch (Exception $e) {
                return response()->json(['message'=>'Fájlfeltöltés hiba'], 401);            
            }
        } else {
            return response()->json(['message'=>'Fájlfeltöltés hiba'], 401);
        }
    }
    
    
    
    /*Dashboard statistics*/
    public function getAllUsersBadgeNum()
    {
        try {
            $result = DB::select('SELECT u.name AS name, COUNT(ub.user_id) AS badge_pcs FROM user_badges AS ub INNER JOIN users AS u ON ub.user_id=u.id GROUP BY ub.user_id');
            
            return response()->json(['success' => $result], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    //
    public function getAllUsersXpNum()
    {
        try {
            $result = DB::select('SELECT u.name AS name, CAST(SUM(b.xp) AS UNSIGNED) AS xp_sum FROM user_badges AS ub INNER JOIN users AS u ON ub.user_id=u.id INNER JOIN badges AS b ON ub.badge_id=b.id GROUP BY u.name ORDER BY u.name');
            
            return response()->json(['success' => $result], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
    
    public function getAllBadgesNum()
    {
        try {
            $result = DB::select('SELECT b.name AS name, COUNT(ub.badge_id) AS badge_pcs FROM user_badges AS ub INNER JOIN badges AS b ON ub.badge_id=b.id GROUP BY ub.badge_id');
            
            return response()->json(['success' => $result], $this->successStatus);
        } catch (Exception $e) {
            return response()->json(['message'=>'Error'], 401);            
        }
    }
}