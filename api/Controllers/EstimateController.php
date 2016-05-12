<?php 
require_once("Classes/Helper.php");
require_once("Models/Estimate.php");

class EstimateController
{
    /**
    * Submit estimate
    */
    public function SubmitEstimate($userID)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']))
            {
                $response = Estimate::SubmitEstimate($userID);
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