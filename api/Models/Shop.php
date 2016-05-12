<?php 
require_once("Settings/config.php");
require_once("Classes/Helper.php");
require_once("Models/Response/SingleItemResponse.php");
require_once("Models/Response/MultipleItemsResponse.php");
require_once("Models/Response/BooleanResponse.php");
require_once("Models/User.php");

class Shop
{
    /**
    * Find Near Shop
    */
    public static function FindNearShop($lat, $lng)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $lat = $mysqli->real_escape_string($lat);
        $lng = $mysqli->real_escape_string($lng);
        
        $items = array();
        
        $sql = "SELECT *, 
            3956 * 2 * ASIN(SQRT( POWER(SIN(($lat -
            abs( 
            f_lat)) * pi()/180 / 2),2) + COS($lat * pi()/180 ) * COS( 
            abs
            (f_lat) *  pi()/180) * POWER(SIN(($lng - f_lng) *  pi()/180 / 2), 2) ))

            as distance 
            FROM shop having distance < 100 ORDER BY distance limit 10";                

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {                
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = $row;
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
}
?>