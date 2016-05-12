<?php 
require_once("Settings/config.php");
require_once("Classes/Helper.php");
require_once("Models/Response/SingleItemResponse.php");
require_once("Models/Response/MultipleItemsResponse.php");
require_once("Models/Response/BooleanResponse.php");
require_once("Models/User.php");

class Estimate
{
    /**
    * Submit a printed estimate
    */
    public static function SubmitEstimate($userID)
    {
         $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);        

        $sql = "INSERT INTO estimate(userID) VALUES ({$userID})";
        if($mysqli -> query($sql)) 
        {
            $file = "estimateImage";
            if(Helper::PostedFile($file))
            {
                $email = new PHPMailer();
                $email->From      = 'support@barelabor.com';
                $email->FromName  = 'BareLabor';
                $email->Subject   = 'Printed Estimate';
                $email->Body      = 'Printed Estimate ID = '.$mysqli->insert_id;
                $email->AddAddress( 'dustin.allen@barelabor.com');
                $email->AddAttachment( $_FILES[$file]['tmp_name'] , $_FILES[$file]['name'] );

                $email->Send();
                
                Helper::UploadFile($file, UPLOAD_LOCATION_ESTIMATES , $mysqli->insert_id);                
                $response->status = 200;
            }                        
            else{
                $response->status = 400;
            }
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