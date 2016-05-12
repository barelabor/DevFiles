<?php 
require_once("Classes/Helper.php");
require_once("Models/User.php");

class UsersController
{
    /**
    * Gets the user info by login
    */
    public function Login($username, $password, $device_token)
    {
        if(Helper::APIKeyValid())
        {
            if(isset($_POST['username']) && 
                isset($_POST['password']))
            {
                $response = User::Login($username, $password, $device_token);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }
   
    /**
    * Registers user
    */
    public function Register($username, $password,
        $userLat = "",
        $userLong = "",
        $userAddress = "",
        $userPhone = "",
        $device_token = "")
    {        
    	
        if(Helper::APIKeyValid())
        { 
            if(isset($_POST['username']))
            { 
                $response = User::Register($username, $password,
                            $userLat, $userLong, $userAddress, $userPhone, $device_token);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }


    /**
    * Gets the user profile (for $forUserID)
    */
    public function Profile($userID, $forUserID)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) && 
                isset($_POST['forUserID']))
            {
                $response = User::Profile($userID, $forUserID);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }

    /**
    * Updates the user profile
    */
    public function UpdateProfile($userID,
        $email,
        $username = "",
        $userFullname = "",
        $userInfo = "",
        $userTypeID = 1,
        $userLat = "",
        $userLong = "",
        $userAddress = "",
        $userPhone = "",
        $userWeb = "",
        $userEmail = "")
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) && 
                isset($_POST['email']))
            {   
                $userAvatar = "";
                if(Helper::PostedFile("userAvatar"))
                {
                    $userAvatar = Helper::UploadFile("userAvatar", UPLOAD_LOCATION_PICS . $userID . "/", "user-avatar-{$userID}");
                }

                $response = User::UpdateProfile($userID, $email, $username, $userFullname, $userInfo,
                    $userAvatar, $userTypeID, $userLat, $userLong, $userAddress, $userPhone, $userWeb, $userEmail);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }
    
    /**
    * Updates the user PN Settings
    */
    public function SetPN($userID,
        $PN = 1)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) && isset($_POST['PN']))
            {   
                $response = User::SetPN($userID, $PN);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }
    
    /**
    * Updates the user lat/long
    */
    public function SetLatLong($userID,
        $latitude = 0.0, $longitude = 0.0)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) && isset($_POST['latitude']) && isset($_POST['longitude']))
            {   
                $response = User::SetLatLong($userID, $latitude, $longitude);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }

    /**
    * Get latest users
    */
    public function GetLatestUsers($userID, $take = 50)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']))
            {
                $response = User::GetLatestUsers($userID, $take);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }

    /**
    * Search users
    */
    public function SearchUsers($userID, $searchTerm, $page = 1, $take = 50)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) &&
                isset($_POST['searchTerm']))
            {
                $response = User::SearchUsers($userID, $searchTerm, $page, $take);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }

    /**
    * Get locations
    */
    public function GetLocationsForLatLong($userID, $latitude, $longitude, $distance = 50, $page = 1, $take = 50)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) &&
                isset($_POST['latitude']) &&
                    isset($_POST['longitude']))
            {
                $response = User::GetLocationsForLatLong($userID, $latitude, $longitude, $distance, $page, $take);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }

    
    /**
    * Timeline
    */
    public function Timeline($userID, $clubID, $forUserID, $latitude, $longitude, $locationMode, $sortByMode, $page = 1, $take = 10)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) && 
                isset($_POST['clubID']) && 
                isset($_POST['forUserID']))
            {
                $response = User::Timeline($userID, $clubID, $forUserID, $latitude, $longitude, $locationMode, $sortByMode, $page, $take);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }
    
    /**
    * Get My Posts
    */
    public function getMyPosts($userID, $page = 1, $take = 10)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']))
            {
                $response = User::myPosts($userID, $page, $take);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }
}
?>