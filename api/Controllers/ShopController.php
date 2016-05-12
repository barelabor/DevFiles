<?php 
require_once("Classes/Helper.php");
require_once("Models/Shop.php");

class ShopController
{
    /**
    * Find Near Shop
    */
    public function FindNearShop($lat, $lng)
    {
        if(Helper::APIKeyValid())
        {
            if(isset($_POST['lat']) && isset($_POST['lng']))
            {
                $response = Shop::FindNearShop($lat, $lng);
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