<?php 
require_once("Classes/Helper.php");
require_once("Models/Tire.php");

class TiresController
{
    /**
    * Get Make from Year
    */
    public function GetMake($year)
    {
        if(Helper::APIKeyValid())
        {
            if(isset($_POST['year']))
            {
                $response = Tire::GetMake($year);
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
    * Get Model from Year, Make
    */
    public function GetModel($year, $make)
    {
        if(Helper::APIKeyValid())
        {
            if(isset($_POST['year']) && isset($_POST['make']))
            {
                $response = Tire::GetModel($year, $make);
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
    * Get Features from Year, Make, Model
    */
    public function GetFeatures($year, $make, $model)
    {
        if(Helper::APIKeyValid())
        {
            if(isset($_POST['year']) && isset($_POST['make']) && isset($_POST['model']))
            {
                $response = Tire::GetFeatures($year, $make, $model);
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
    * Get Price from Year, Make, Model, Feature
    */
    public function GetPriceByVehicle($year, $make, $model, $feature)
    {
        if(Helper::APIKeyValid())
        {
            if(isset($_POST['year']) && isset($_POST['make']) && isset($_POST['model']))
            {
                $response = Tire::GetPriceByVehicle($year, $make, $model, $feature);
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
    * Get Price from Width, Ratio, Diameter
    */
    public function GetPriceBySize($width, $ratio, $diameter)
    {
        if(Helper::APIKeyValid())
        {
            if(isset($_POST['width']) && isset($_POST['ratio']) && isset($_POST['diameter']))
            {
                $response = Tire::GetPriceBySize($width, $ratio, $diameter);
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