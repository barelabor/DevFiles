<?php
require_once("Settings/config.php");
require_once("Classes/Helper.php");
require_once("Classes/Email.php");
require_once("Models/Response/SingleItemResponse.php");
require_once("Models/Response/BooleanResponse.php");
require_once("PasswordHash.php");
$hasher = new PasswordHash(8, TRUE); // initialize the PHPass class

class Reset 
{
	public static function TokenValid($username, $token)
	{
		$response = new BooleanResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);

		$user = Helper::Clean($username);
		$token = Helper::Clean($token);

		if($stmt = $mysqli -> prepare("SELECT userID FROM users WHERE username = ? AND resetToken = ?")) 
	    {
            $stmt -> bind_param("ss", $user, $token);

            if($stmt -> execute())
            {
                $stmt -> store_result();
                $stmt -> bind_result($userID);
                $stmt -> fetch();

                if($stmt->num_rows > 0) 
              	{
              		$response->status = 200;
				}
				else 
                {
              		$response->status = 404;
				}
			}
		}
		else
		{
			$response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
		}

		return $response;
	}

    /* Gets the reset password token */
    public static function GetRandomToken()
    {   
        $underscores = 2; // Maximum number of underscores allowed in password
        $length = 10; // Length of password
         
        $p ="";
        for ($i=0;$i<$length;$i++)
        {   
          $c = mt_rand(1,7);
          switch ($c)
          {
            case ($c<=2):
              // Add a number
              $p .= mt_rand(0,9);   
            break;
            case ($c<=4):
              // Add an uppercase letter
              $p .= chr(mt_rand(65,90));   
            break;
            case ($c<=6):
              // Add a lowercase letter
              $p .= chr(mt_rand(97,122));   
            break;
            case 7:
               $len = strlen($p);
              if ($underscores>0&&$len>0&&$len<($length-1)&&$p[$len-1]!="_")
              {
                $p .= "_";
                $underscores--;   
              }
              else
              {
                $i--;
                continue;
              }
            break;       
          }
        }
        return $p;
    }

	public static function GetToken($usernameEmail)
	{
		$response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);

		$input = Helper::Clean($usernameEmail);

		$sql = "SELECT userID, email, username FROM users WHERE email = ?";
		if(!filter_var($input, FILTER_VALIDATE_EMAIL))
		{
			$sql = "SELECT userID, email, username FROM users WHERE username = ?";
		}

		if($stmt = $mysqli -> prepare($sql)) 
        {
            $stmt -> bind_param("s", $input);

            /* Execute it */
            if($stmt -> execute())
            {
                $stmt -> store_result();
                $stmt -> bind_result($userID, $email, $username);

                /* Fetch the value */
                $stmt -> fetch();

                if($stmt->num_rows > 0) {
                	$response->status = 200;

                	$user = new stdClass;
                	$user->userID = $userID;
                	$user->email = $email;
                	$user->username = $username;
                	$user->resetToken = md5("{$userID} | {$username} | {$email}" . Reset::GetRandomToken());

                	$response->item = $user;
                }
                else {
                 	$response->status = 409;
                }
            }
            else
            {
                $response->status = 503;
            }
         
            $stmt -> close();
        }
        else {
        	$response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();
		return $response;
	}


    public static function ResetPassword($email)
    {
        $response = new BooleanResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);

        $token = Reset::GetToken($email);
        $response->status = $token->status;

        if($token->status == 200)
        {
            $mail = new Email($token->item->email, $token->item->username, EMAIL, EMAIL_FROM, "ALIBI - Reset password", 
            "<!DOCTYPE html>
             <html>
                <head>
                    <meta charset=\"utf-8\" />
                    <style type=\"text/css\">
                            body {font: 12px sans-serif;}
                    </style>
                </head>
                <body>
                    <a href=\"" . BASE_WEB_URL . "/reset?username={$token->item->username}&token={$token->item->resetToken}\" alt=\"Reset password\">" 
                        . BASE_WEB_URL . "/reset/{$token->item->username}/{$token->item->resetToken}/
                    </a>
                </body>
            </html>");
            
            if($mail->Send())
            {
                $ret = Reset::SetToken($token->item->userID, $token->item->resetToken);
                $response->status = $ret->status;
            }
            else
            {
                $response->status = 503;
                $log = Helper::GetLogger();
                $log->logError($mail->ErrorMessage());
            }
        }

        $mysqli->close();
        return $response;
    }


	public function SetToken($userID, $token)
	{
		$response = new BooleanResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);

		$userID = Helper::Clean($userID);
		$token = Helper::Clean($token);

		if($stmt = $mysqli -> prepare("UPDATE users SET resetToken = ? WHERE userID = ?")) 
		{
			$stmt -> bind_param("ss", $token, $userID);
			if($stmt -> execute())
			{
				$response->status = 200;
			}
			else
			{
				$response->status = 503;
                $log = Helper::GetLogger();
                $log->logError("Set token: " .  $stmt->error);
			}

			$stmt-> close();
		}
        else 
        {
         	$response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();
		return $response;
	}

	public function ChangePassword($username, $token, $password)
	{
        global $hasher;
		$response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
		$username = Helper::Clean($username);
		$token = Helper::Clean($token);

        if(Reset::TokenValid($username, $token)->status == 200)
        {
            if($stmt = $mysqli->prepare("UPDATE users SET password = ? WHERE username = ? AND resetToken = ?")) 
            {
                $stmt -> bind_param("sss", $hasher->HashPassword($password), $username, $token);
                if($stmt -> execute())
                {
                    if($stmt2 = $mysqli->prepare("UPDATE users SET resetToken = '' WHERE username = ?")) 
                    {
                        $stmt2->bind_param("s", $username);
                        $stmt2 -> execute();
                        $stmt2->close();
                    }

                    $response->status = 200;
                }
                else
                {
                    $response->status = 503;
                    $log = Helper::GetLogger();
                    $log->logError($stmt->error);
                }

                $stmt->close();
            }
            else
            {
                $response->status = 503;
                $log = Helper::GetLogger();
                $log->logError($mysqli->error);
            }
        }
        else
        {
            $response->status = 403;
        }


        $mysqli->close();
        unset($hasher);
		return $response;
	}

}

?>