<?php 
require_once("Settings/config.php");
require_once("Classes/Helper.php");
require_once("Models/Response/SingleItemResponse.php");
require_once("Models/Response/MultipleItemsResponse.php");
require_once("PasswordHash.php");
require_once("Models/Post.php");
$hasher = new PasswordHash(8, TRUE); // initialize the PHPass class


class User
{
    public static function GetImageUrl($userID, $image)
    {
        if(!empty($image))
        {
          if(strncmp($image, "http://", strlen("http://")) &&
              strncmp($image, "https://", strlen("https://")))
          {
            $image = BASE_URL . UPLOAD_LOCATION_PICS  . (!empty($userID) ? $userID . "/"  : "") . $image;
          }            
        }

        return $image;
    }

    /**
    * Gets the user info by login
    */
    public static function Login($username, $password, $device_token)
    {
        global $hasher;

        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $user = new stdClass;
        $username = $mysqli->real_escape_string($username);
        $password = $mysqli->real_escape_string($password);

        if($result = $mysqli -> query("SELECT u.userID, u.password FROM users u WHERE u.username = '{$username}' ")) 
        {            
            if($result->num_rows > 0) 
            {
                $row = $result->fetch_object();

                if($hasher->CheckPassword($password, $row->password))
                {                    
                    $mysqli -> query("UPDATE users SET resetToken='{$device_token}' WHERE userID = '{$row->userID}'");
                    /* Login OK */
                    $data = User::Profile(0, $row->userID);
                    $response->status = $data->status;
                    $user = $data->item;
                }
                else
                {
                   /* Unathorized, login failed */
                   $response->status = 401;
                }
            }
            else 
            {
              /* Not found */
              $response->status = 404;
            }

         
            /* Close statement */
            $result -> close();
        }
        else {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();
        unset($hasher);

        $response->item = $user;
        return $response;
    }

    /**
    * Register users
    */
    public static function Register($username, $password,
        $userLat = "",
        $userLong = "",
        $userAddress = "",
        $userPhone = "",
        $device_token = "")
    {
        global $hasher;

        $response = new SingleItemResponse();
        $user = new stdClass;
        $user->username = $username;
        
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);

        /* Create a prepared statement */
        if($stmt = $mysqli -> prepare("INSERT INTO users SET username = ?, password = ?, userPhone = ?, userLat = ?, userLong = ?, userAddress = ?, resetToken = ?")) 
        //if($stmt = $mysqli -> prepare("INSERT INTO users SET username = ?, password = ?")) 
        {
            /* Bind parameters
             s - string, b - boolean, i - int, etc */
            $stmt->bind_param("sssssss", $username, $hasher->HashPassword($password), $userPhone, $userLat, $userLong, $userAddress, $device_token);

            /* Execute it */
            if($stmt->execute()) {
                $response->status = 201;
                $userID = $mysqli->insert_id;

                $old = umask(0);
                mkdir(Helper::GetPath() . UPLOAD_LOCATION_PICS . $userID, 0777);
                umask($old);

                if(Helper::PostedFile("userAvatar"))
                {
                    $userAvatar = $mysqli->real_escape_string(Helper::UploadFile("userAvatar", UPLOAD_LOCATION_PICS . $userID . "/", "user-avatar-{$userID}"));
                    $mysqli->query("UPDATE users SET userAvatar = '{$userAvatar}' WHERE userID = {$userID}");
                }

                $user = User::Profile(0, $userID)->item;
            }
            else {
                $response->status = 409;
                //$response->status = $mysqli->error;
            }

            /* Close statement */
            $stmt->close();
        }
        else {

            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        
        $mysqli->close();
        unset($hasher);

        $response->item = $user;
        return $response;
    }

    /**
    * Gets the user profile (for $forUserID)
    */
    public static function Profile($userID, $forUserID)
    {
        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $forUserID = $mysqli->real_escape_string($forUserID);
        $userID = $mysqli->real_escape_string($userID);

        if($result = $mysqli -> query("SELECT 	u.userID,
                                                u.username,
                                                u.userLat,
                                                u.userLong,
                                                u.userAddress,
                                                u.userPhone,
                                                u.created,
                                                u.resetToken,
                                                u.userAvatar
                                            FROM users u 
                                            WHERE u.userID = {$forUserID}")) 
        {
            if($result->num_rows > 0) 
            {
                $response->status = 200;
                $row = $result->fetch_object();
                $row->timeAgo = Helper::TimeAgo($row->created);
                $row->userAvatar = User::GetImageUrl($forUserID, $row->userAvatar);
               
                $response->item = $row;
            }
            else 
            {
              /* Not found */
              $response->status = 404;
            }

            $result -> close();
        }
        else
        {
            /* Service unavailable */
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }
         
        $mysqli->close();
        return $response;
    }

    /**
    * Updates the user profile 
    */
    public static function UpdateProfile(
        $userID,
        $email,
        $username = "",
		$userFullname = "",
		$userInfo = "",
		$userAvatar = "",
		$userTypeID = 1,
		$userLat = "",
		$userLong = "",
		$userAddress = "",
		$userPhone = "",
		$userWeb = "",
		$userEmail = "")
    {
        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $username = $mysqli->real_escape_string($username);
        $email = $mysqli->real_escape_string($email);
        $userFullname = $mysqli->real_escape_string($userFullname);
        $userAvatar = $mysqli->real_escape_string($userAvatar);
        $userLat = $mysqli->real_escape_string($userLat);
        $userLong = $mysqli->real_escape_string($userLong);
        $userAddress = $mysqli->real_escape_string($userAddress);
        $userPhone = $mysqli->real_escape_string($userPhone);

        $ok = true;
        if(!empty($username) && !is_null($username) && $username != "")
        {
            if($available = $mysqli -> query("SELECT userID, 
                                                (SELECT COUNT(*) FROM users WHERE username = '{$username}') AS total 
                                              FROM users WHERE username = '{$username}' ")) {
                $row = $available->fetch_object();

                if($row->total > 0 && $row->userID != $userID) {
                    $ok = false;
                }

                $available->close();
            }
            else
            {
                /* Service unavailable */
                $response->status = 503;
                $log = Helper::GetLogger();
                $log->logError($mysqli->error);
            }
        }

        if($ok) 
        {
            $sql = "UPDATE users SET email = '{$email}', userFullname = '{$userFullname}',
            modified = NOW(), userPhone = '{$userPhone}', userLat = '{$userLat}', userLong = '{$userLong}', 
            userAddress = '{$userAddress}' ";

            if(!empty($username) && !is_null($username) && $username != "")
            {
                $sql .= ", username = '{$username}' ";
            }

            if(!empty($userAvatar) && !is_null($userAvatar) && $userAvatar != "")
            {
                $sql .= ", userAvatar = '{$userAvatar}' ";
            }
               
            $sql .= " WHERE userID = {$userID}";

            if($result = $mysqli -> query($sql)) 
            {
                $response->item = User::Profile(0, $userID)->item;
                $response->status = 200;
            }
            else
            {
                if($mysqli->errno == 1169 || $mysqli->errno == 1586 || $mysqli->errno == 1062)
                {
                    /* Duplicate entry */
                    $response->status = 409;
                }
                else
                {
                    /* Service unavailable */
                    $response->status = 503;
                }

                $log = Helper::GetLogger();
                $log->logError($mysqli->error);
            }
        }
        else
        {
            $response->status = 409;
        }

        $mysqli->close();
        return $response;
    }
    
    /**
    * Updates the user PN settings 
    */
    public static function SetPN(
        $userID,        
        $PN = 1)
    {
        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $PN = $mysqli->real_escape_string($PN);

        $sql = "UPDATE users SET pnOn = {$PN} WHERE userID = {$userID}";

        if($result = $mysqli -> query($sql)) 
        {
            $response->item = User::Profile(0, $userID)->item;
            $response->status = 200;
        }
        else
        {
            /* Service unavailable */
            $response->status = 503;

            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();
        return $response;
    }
    
    /**
    * Updates the user lat/long
    */
    public static function SetLatLong(
        $userID,        
        $latitude = 0.0, $longitude = 0.0)
    {
        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $latitude = $mysqli->real_escape_string($latitude);
        $longitude = $mysqli->real_escape_string($longitude);

        $sql = "UPDATE users SET userLat = {$latitude}, userLong = {$longitude} WHERE userID = {$userID}";

        if($result = $mysqli -> query($sql)) 
        {
            $response->item = User::Profile(0, $userID)->item;
            $response->status = 200;
        }
        else
        {
            /* Service unavailable */
            $response->status = 503;

            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();
        return $response;
    }

    /**
    * Get latest users
    */
    public function GetLatestUsers($userID, $take = 50)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);

        $sql = "SELECT u.userID    
                FROM users u 
                ORDER BY userID DESC 
                LIMIT 0, ?"; 

        $items = array();
        if ($stmt = $mysqli->prepare($sql))
        {
            $stmt->bind_param("i", $take);

            if($stmt->execute()) {
                /* Bind results to variables */
                $stmt->bind_result($uid);
                
                /* fetch values */
                while ($stmt->fetch()) {
                    $item = User::Profile($userID, $uid)->item;
                    $items[] = $item;
                }

                $response->status = 200;
            }
            else
            {
                $response->status = 400;
            }

            /* Close statement */
            $stmt->close();
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();

        $response->items = $items;
        return $response;
    }

    /**
    * Search users 
    */
    public function SearchUsers($userID, $searchTerm, $page = 1, $take = 50)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $searchTerm = $mysqli->real_escape_string($searchTerm);
        $take = $mysqli->real_escape_string($take);
        $from = $mysqli->real_escape_string(($page - 1) * $take);
        $items = array();

        $sql = "SELECT u.userID    
                FROM users u 
                WHERE (
                	lower(u.username) LIKE lower('%{$searchTerm}%') OR
                	lower(u.userFullname) LIKE lower('%{$searchTerm}%')
                )
                ORDER BY u.userID DESC 
                LIMIT {$from}, {$take}"; 


        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0)
            {
                $response->status = 200;
                while($row = $result->fetch_object())
                {
                    $item = User::Profile($userID, $row->userID)->item;
                    $items[] = $item;
                }
            }
            else
            {
                $response->status = 404;
            }

            $result->close();
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();

        $response->items = $items;
        return $response;
    }

    /**
    * Get locations
    */
    public static function GetLocationsForLatLong($userID, $latitude, $longitude, $distance = 50, $page = 1, $take = 50)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $latitude = $mysqli->real_escape_string($latitude);
        $longitude = $mysqli->real_escape_string($longitude);
        $distance = $mysqli->real_escape_string($distance);
        $take = $mysqli->real_escape_string($take);
        $from = $mysqli->real_escape_string(($page - 1) * $take);
        $items = array();

        $sql = "SELECT * FROM (
                    SELECT u.userID,
                    (((acos(sin(({$latitude}*pi()/180)) * sin((u.userLat*pi()/180))+cos(({$latitude}*pi()/180)) * 
                    cos((u.userLat*pi()/180)) * cos((({$longitude} - u.userLong)*pi()/180))))*180/pi())*60*1.1515*1.609344) as distance
                FROM users u 
                WHERE u.userTypeID = 2 
                ORDER BY distance ASC 
                LIMIT {$from}, {$take}
                ) t where distance <= {$distance}"; 


        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows >0)
            {
                $response->status = 200;
                while($row = $result->fetch_object())
                {
                    $item = User::Profile($userID, $row->userID)->item;
                    $item->distance = $row->distance;

                    $items[] = $item;
                }
            }
            else
            {
                $response->status = 404;
            }

            $result->close();
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();

        $response->items = $items;
        return $response;
    }


    /**
    * Get the timeline
    */
    public static function Timeline($userID, $clubID, $forUserID, $latitude, $longitude, $locationMode, $sortByMode, $page = 1, $take = 10)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $forUserID = $mysqli->real_escape_string($forUserID);
        $userID = $mysqli->real_escape_string($userID);
        $clubID = $mysqli->real_escape_string($clubID);
        $take = $mysqli->real_escape_string($take);
        $from = ($mysqli->real_escape_string($page) - 1) * $take;

        $items = array();
        
        $locationQuery = "";
        if($locationMode == "local"){
            $locationQuery = "p.userID IN (
                                        SELECT a.userID FROM 
                                        (
                                            SELECT userID, 
                                            (
                                              3959 * acos (
                                                cos ( radians({$latitude}) )
                                                * cos( radians( userLat ) )
                                                * cos( radians( userLong ) - radians({$longitude}) )
                                                + sin ( radians({$latitude}) )
                                                * sin( radians( userLat ) )
                                              )
                                            ) AS distance 
                                            FROM users
                                            HAVING distance < 1
                                        ) AS a
                                        ) AND ";
        }
        
        $querySelect = "SELECT p.postID, p.userID "
                . "FROM posts AS p "
                . "WHERE {$locationQuery} p.clubID = {$clubID} "
                . "ORDER BY p.postDate DESC "
                . "LIMIT {$from}, {$take}";              
                                                   
        if($sortByMode == "hot"){
            $querySelect = "SELECT p.postID, p.userID,COUNT(l.likeID) AS likesCount 
                FROM posts AS p LEFT JOIN likes AS l ON p.postID=l.postID 
                WHERE {$locationQuery} clubID = {$clubID} "
                . "GROUP BY p.postID "
                . "ORDER BY likesCount DESC LIMIT {$from}, {$take}";
        }
        
        if($result = $mysqli -> query($querySelect)) 
        {
            if($result->num_rows > 0) 
            {
                while($row = $result->fetch_object())
                {
                    $post = Post::GetPost($row->userID, $row->postID, $userID);
                    if($post->status == 200)
                    {
                        $items[] = $post->item;
                    }
                }
            }
            else
            {
                $response->status = 404;
            }

            $result -> close();
        }
        else
        {
            /* Service unavailable */
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }
        
        
        $response->items = $items;
         
        $mysqli->close();
        return $response;
    }
    
    /**
    * Get My Posts
    */
    public static function myPosts($userID, $page = 1, $take = 10)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $take = $mysqli->real_escape_string($take);
        $from = ($mysqli->real_escape_string($page) - 1) * $take;

        $items = array();
        if($result = $mysqli -> query("SELECT postID, userID FROM posts WHERE userID = {$userID} ORDER BY postDate DESC LIMIT {$from}, {$take}")) 
        {
            if($result->num_rows > 0) 
            {
                while($row = $result->fetch_object())
                {
                    $post = Post::GetPost($row->userID, $row->postID, $userID);
                    if($post->status == 200)
                    {
                        $items[] = $post->item;
                    }
                }
            }
            else
            {
                $response->status = 404;
            }

            $result -> close();
        }
        else
        {
            /* Service unavailable */
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }
        
        
        $response->items = $items;
         
        $mysqli->close();
        return $response;
    }    
    
}
?>