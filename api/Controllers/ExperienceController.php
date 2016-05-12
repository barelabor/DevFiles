<?php 
require_once("Classes/Helper.php");
require_once("Models/Experience.php");

class ExperienceController
{
    /**
    * Get Make from Year
    */
    public function SubmitExperience($userID, $type, $answers, $name, $email, $shop_name, $comments)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['type']))
            {
                $response = Experience::SubmitExperience($userID, $type, $answers, $name, $email, $shop_name, $comments);
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