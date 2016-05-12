<?php 
require_once("Settings/config.php");
require_once("Classes/Helper.php");
require_once("Models/Response/SingleItemResponse.php");
require_once("Models/Response/MultipleItemsResponse.php");
require_once("Models/Response/BooleanResponse.php");
require_once("Models/User.php");

class Tire
{
    /**
    * Get Make from Year
    */
    public static function GetMake($year)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $year = $mysqli->real_escape_string($year);

        $items = array();

        $sql = "SELECT DISTINCT (
            t_autoMake
            )
            FROM  `tirerack` 
            WHERE t_autoYear =$year";

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = $row->t_autoMake;
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
    * Get Models from Year, Make
    */
    public static function GetModel($year, $make)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $year = $mysqli->real_escape_string($year);
        $make = $mysqli->real_escape_string($make);

        $items = array();

        $sql = "SELECT DISTINCT (
            t_autoModel
            )
            FROM  `tirerack` 
            WHERE t_autoYear=$year
            AND t_autoMake='$make'";        

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = $row->t_autoModel;
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
    * Get Features from Year, Make, Model
    */
    public static function GetFeatures($year, $make, $model)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $year = $mysqli->real_escape_string($year);
        $make = $mysqli->real_escape_string($make);
        $model = $mysqli->real_escape_string($model);

        $items = array();

        $sql = "SELECT DISTINCT (
            t_autoModClar
            )
            FROM  `tirerack` 
            WHERE t_autoYear=$year
            AND t_autoMake='$make'
            AND t_autoModel='$model'";        

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = $row->t_autoModClar;
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
    * Get Price from Year, Make, Model, Feature
    */
    public static function GetPriceByVehicle($year, $make, $model, $feature)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $year = $mysqli->real_escape_string($year);
        $make = $mysqli->real_escape_string($make);
        $model = $mysqli->real_escape_string($model);
        $feature = $mysqli->real_escape_string($feature);

        $items = array();

        $sql = "SELECT DISTINCT (
            t_price
            )
            FROM  `tirerack` 
            WHERE t_autoYear=$year
            AND t_autoMake='$make'
            AND t_autoModel='$model'
            AND t_autoModClar='$feature'";        

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = $row->t_price;
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
    * Get Price from Width, Ratio, Diameter
    */
    public static function GetPriceBySize($width, $ratio, $diameter)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $width = $mysqli->real_escape_string($width);
        $ratio = $mysqli->real_escape_string($ratio);
        $diameter = $mysqli->real_escape_string($diameter);

        $items = array();

        $sql = "SELECT DISTINCT (
            t_price
            )
            FROM  `tirerack` 
            WHERE t_width='$width/'
            AND t_ratio=$ratio
            AND t_diameter=$diameter";

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = $row->t_price;
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