<?php
require_once("Models/Reset.php");
require_once("Classes/Helper.php");

class ResetController
{
	public function getTokenValid($username, $token)
	{
		if(isset($_SERVER['HTTP_API_KEY']))
        {
            if(isset($_POST['username']) && isset($_POST['token']) && strlen($_POST['token']) > 0)
            {
                $reset = Reset::TokenValid($username, $token);
            }
            else
            {
                $reset->status = 400;
            }  
		}
		else 
		{
			 $reset->status = 400;
		}

		$this->server->setStatus($reset->status);
	    $reset->status = Helper::getCustomStatus($reset->status, $this->server);

	    return $reset; 
	}

	public function getToken($usernameEmail)
	{
		if(isset($_SERVER['HTTP_API_KEY']))
        {
            if(isset($_POST['usernameEmail']))
            {
                $reset = Reset::GetToken($usernameEmail);
            }
            else
            {
                $reset->status = 400;
            }  
		}
		else 
		{
			 $reset->status = 400;
		}

		$this->server->setStatus($reset->status);
	    $reset->status = Helper::getCustomStatus($reset->status, $this->server);

	    return $reset; 
	}

	public function ResetPassword($email)
	{
		if(Helper::APIKeyValid())
        {
            if(isset($_POST['email']))
            {
                $reset = Reset::ResetPassword($email);
            }
            else
            {
                $reset->status = 400;
            }  
		}
		else 
		{
			 $reset->status = 400;
		}

		$this->server->setStatus($reset->status);
	    $reset->status = Helper::getCustomStatus($reset->status, $this->server);

	    return $reset; 
	}

	public function setToken($userID, $token)
	{
		if(isset($_SERVER['HTTP_API_KEY']))
        {
            if(isset($_POST['userID']) && isset($_POST['token']) && strlen($_POST['token']) > 0)
            {
                $reset = Reset::SetToken($userID, $token);
            }
            else
            {
                $reset->status = 400;
            }  
		}
		else 
		{
			 $reset->status = 400;
		}

		$this->server->setStatus($reset->status);
	    $reset->status = Helper::getCustomStatus($reset->status, $this->server);

	    return $reset; 
	}

	public function changePassword($username, $token, $password)
	{
		if(isset($_SERVER['HTTP_API_KEY']))
        {
			if(isset($_POST['username']) && isset($_POST['token']) && strlen($_POST['token']) > 0 
				&& isset($_POST['password']) && strlen($_POST['password']) >  5)
			{
				$reset = Reset::ChangePassword($username, $token, $password);
			}
		}
		else {
			$reset->status = 400;
		}

		$this->server->setStatus($reset->status);
	    $reset->status = Helper::getCustomStatus($reset->status, $this->server);

	    return $reset; // returning the updated or newly created user object
	}

}

?>