<?php 
require_once("Settings/config.php");
require_once("Classes/Helper.php");
require_once("Models/Response/SingleItemResponse.php");
require_once("Models/Response/MultipleItemsResponse.php");
require_once("Models/Response/BooleanResponse.php");
require_once("Models/User.php");

class Experience
{
    /**
    * Submit Experience
    */
    public static function SubmitExperience($userID, $type, $answers, $name, $email, $shop_name, $comments)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $type = $mysqli->real_escape_string($type);
        $answers = $mysqli->real_escape_string($answers);
        $name = $mysqli->real_escape_string($name);
        $email = $mysqli->real_escape_string($email);
        $shop_name = $mysqli->real_escape_string($shop_name);
        $comments = $mysqli->real_escape_string($comments);

        $sql = "INSERT INTO experience(userID, type, answers, name, email, shop_name, comments) VALUES "
                . "({$userID}, {$type}, '{$answers}', '{$name}', '{$email}', '{$shop_name}', '{$comments}')";

        if($mysqli -> query($sql)) 
        {
            $response->status = 200;
            $response->item = "1";
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
}
?>