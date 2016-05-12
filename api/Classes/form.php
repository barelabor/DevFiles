<?php
ini_set("display_error", 1);
error_reporting(-1);
//require_once("../Settings/config.php");
require_once("Controllers/UsersController.php");
require_once("Controllers/PNController.php");

$mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);

if($_POST['form_id']){
    extract($_POST);
    $sql = "UPDATE `estimate` 
            SET autoYear=$autoYear, autoMake='$autoMake', autoModel='$autoModel', engineSize='$engineSize'
                , autoPart='$autoPart', highCost='$highCost', averageCost='$averageCost', lowCost='$lowCost' 
            WHERE estimateID=$estimateID";
    
    if($mysqli->query($sql)){        
        $submitSuccess = 1;

        $sql = "SELECT * 
            FROM  `estimate` 
            WHERE estimateID=$estimateID";
        if ($result = $mysqli->query($sql))
        {
            if($row = $result->fetch_object())
            { 
                $toUser = User::Profile(0, $row->userID)->item;                
                PNController::SendPushNotification($toUser->resetToken, $row);
            }
            $result->close();
        }       
    }
    else{
        $submitSuccess = 0;        
    }
}
else{
    $submitSuccess = 2;
}
$arrayID = array();

$sql = "SELECT estimateID
            FROM  `estimate` 
            WHERE highCost=0 AND lowCost=0";

if ($result = $mysqli->query($sql))
{
    if($result->num_rows > 0) {
        while($row = $result->fetch_object())
        { 
            $arrayID[] = $row->estimateID;
        }
    }

    $result->close();
}

$mysqli->close();

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>What's The Price</title>
<link rel="stylesheet" type="text/css" href="view.css" media="all">
<script type="text/javascript" src="view.js"></script>

</head>
<body id="main_body" >
	
	<img id="top" src="top.png" alt="">
	<div id="form_container">
	
		<h1><a>What's The Price</a></h1>
                <form id="form_pricing" class="appnitro"  method="post" action="form.php">
					<div class="form_description">
			<h2>What's The Price</h2>
			<p>Please fill the form for pricing the printed estimate.</p>
		</div>						
			<ul >                            
                            <?php
                            if($submitSuccess == 1){
                                echo "<li style='color:blue;'>Successfully sent the pricing to the requested user.<br/><br/></li>";
                            }
                            else if($submitSuccess == 0){
                                echo "<li style='color:red;'>Sorry, an error occured while sending the pricing.<br/><br/></li>";
                            }
                            ?>
                            <li id="li_0">
		<label class="description" for="element_1">Printed Estimate ID</label>
		<div>
                    <select id="estimateID" name="estimateID">
                        <?php
                        foreach($arrayID as $eID){
                            echo '<option value="'.$eID.'">'.$eID.'</option>';
                        }
                        ?>
                    </select>
		</div><p class="guidelines" id="guide_1"><small>ID of the printed estimate submitted to your email</small></p> 
		</li>
			
					<li id="li_1" >
		<label class="description" for="element_1">Year </label>
		<div>
			<input id="autoYear" name="autoYear" class="element text small" type="text" maxlength="255" value=""/> 
		</div><p class="guidelines" id="guide_1"><small>Ex; 2014</small></p> 
		</li>		<li id="li_2" >
		<label class="description" for="element_2">Make </label>
		<div>
			<input id="autoMake" name="autoMake" class="element text medium" type="text" maxlength="255" value=""/> 
		</div><p class="guidelines" id="guide_2"><small>Ex; Ford</small></p> 
		</li>		<li id="li_3" >
		<label class="description" for="element_3">Model </label>
		<div>
			<input id="autoModel" name="autoModel" class="element text medium" type="text" maxlength="255" value=""/> 
		</div><p class="guidelines" id="guide_3"><small>Ex; King Ranch F-150</small></p> 
		</li>		<li id="li_4" >
		<label class="description" for="element_4">Engine Size </label>
		<div>
			<input id="engineSize" name="engineSize" class="element text small" type="text" maxlength="255" value=""/> 
		</div><p class="guidelines" id="guide_4"><small>Ex; 5.0</small></p> 
		</li>		<li id="li_5" >
		<label class="description" for="element_5">Part </label>
		<div>
			<input id="autoPart" name="autoPart" class="element text medium" type="text" maxlength="255" value=""/> 
		</div><p class="guidelines" id="guide_5"><small>Ex; Scorpion Tire Package</small></p> 
		</li>		<li id="li_6" >
		<label class="description" for="element_6">High Cost </label>
		<div>
			<input id="highCost" name="highCost" class="element text small" type="text" maxlength="255" value=""/> 
		</div> 
		</li>		<li id="li_7" >
		<label class="description" for="element_7">Average Cost </label>
		<div>
			<input id="averageCost" name="averageCost" class="element text small" type="text" maxlength="255" value=""/> 
		</div> 
		</li>		<li id="li_8" >
		<label class="description" for="element_8">Low Cost </label>
		<div>
			<input id="lowCost" name="lowCost" class="element text small" type="text" maxlength="255" value=""/> 
		</div> 
		</li>
			
					<li class="buttons">
			    <input type="hidden" name="form_id" value="1097192" />
			    
				<input id="saveForm" class="button_text" type="submit" name="submit" value="Submit" />
		</li>
			</ul>
		</form>	
		<div id="footer">
			Generated by <a href="http://www.barelabor.com/">BareLabor</a>
		</div>
	</div>
	<img id="bottom" src="bottom.png" alt="">
	</body>
</html>