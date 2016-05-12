<?php
ini_set('max_execution_time', 3000);
error_reporting(0);
require_once("Classes/RestServer.php");
require_once("Controllers/PNController.php");
require_once("Controllers/UsersController.php");
require_once("Controllers/ResetController.php");
require_once("Controllers/TiresController.php");
require_once("Controllers/ExperienceController.php");
require_once("Controllers/ShopController.php");
require_once("Controllers/EstimateController.php");

$mode = 'production'; // 'debug' or 'production'
$server = new RestServer($mode);
//$server->refreshCache(); // uncomment momentarily to clear the cache if classes change in production mode

switch($_GET['method'])
{
	default:
	$data = "It works!";
	break;

	/**
	* Users
	*/
	case "login":
	$users = new UsersController();
	$users->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);
        
	$data = $users->Login($_POST["username"], $_POST["password"], $_POST["device_token"]);
	break;
    
	case "register":
	$users = new UsersController();            
	$users->server = $server;         
        
        $_POST = json_decode(@file_get_contents('php://input'), true);
        
	$data = $users->Register($_POST["username"], $_POST["password"], 
            isset($_POST["userLat"]) ? $_POST["userLat"] : "",
            isset($_POST["userLong"]) ? $_POST["userLong"] : "",
            isset($_POST["userAddress"]) ? $_POST["userAddress"] : "",
            isset($_POST["userPhone"]) ? $_POST["userPhone"] : "",            
            isset($_POST["device_token"]) ? $_POST["device_token"] : "");
	break;
    
        case "getMake":
	$tires = new TiresController();
	$tires->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);        
        
	$data = $tires->GetMake($_POST["year"]);
	break;
    
        case "getModel":
	$tires = new TiresController();
	$tires->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);        
        
	$data = $tires->GetModel($_POST["year"], $_POST["make"]);
	break;
    
        case "getFeatures":
	$tires = new TiresController();
	$tires->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);        
        
	$data = $tires->GetFeatures($_POST["year"], $_POST["make"], $_POST["model"]);
	break;
    
        case "getPriceByVehicle":
	$tires = new TiresController();
	$tires->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);        
        
	$data = $tires->GetPriceByVehicle($_POST["year"], $_POST["make"], $_POST["model"], $_POST["feature"]);
	break;
    
        case "getPriceBySize":
	$tires = new TiresController();
	$tires->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);        
        
	$data = $tires->GetPriceBySize($_POST["width"], $_POST["ratio"], $_POST["diameter"]);
	break;
    
        case "submitExperience":
	$experience = new ExperienceController();
	$experience->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);        
        
	$data = $experience->SubmitExperience($_POST["userID"], $_POST["type"], $_POST["answers"], $_POST["name"], $_POST["email"], $_POST["shop_name"], $_POST["comments"]);
	break;
    
        case "findNearShop":
	$shop = new ShopController();
	$shop->server = $server;
        
        $_POST = json_decode(@file_get_contents('php://input'), true);        
        
	$data = $shop->FindNearShop($_POST["lat"], $_POST["lng"]);
	break;
    
        /**
	* Estimates
	*/
	case "submitEstimate":
	$estimate = new EstimateController();
	$estimate->server = $server;
	$data = $estimate->SubmitEstimate($_POST['userID']); // $_FILE["estimateImage"] (file)
	break;

	case "getProfile":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->Profile($_POST["userID"], $_POST["forUserID"]);
	break;

	case "setProfile":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->UpdateProfile($_POST["userID"], $_POST["email"], // $_FILE["userAvatar"] (FILE)
 		isset($_POST["username"]) ? $_POST["username"] : "",
        isset($_POST["userFullname"]) ? $_POST["userFullname"] : "", 
        isset($_POST["userInfo"]) ? $_POST["userInfo"] : "",
        isset($_POST["userTypeID"]) ? $_POST["userTypeID"] : 1, 
        isset($_POST["userLat"]) ? $_POST["userLat"] : "", 
        isset($_POST["userLong"]) ? $_POST["userLong"] : "",
        isset($_POST["userAddress"]) ? $_POST["userAddress"] : "",
        isset($_POST["userPhone"]) ? $_POST["userPhone"] : "", 
        isset($_POST["userWeb"]) ? $_POST["userWeb"] : "",
        isset($_POST["userEmail"]) ? $_POST["userEmail"] : "");
	break;
    
        case "setPN":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->SetPN($_POST["userID"], $_POST["PN"]);
	break;
    
        case "setLatLong":
        $users = new UsersController();
	$users->server = $server;
	$data = $users->SetLatLong($_POST["userID"], $_POST["latitude"], $_POST["longitude"]);
	break;

	case "getNewUsers":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->GetLatestUsers($_POST["userID"], isset($_POST["take"]) ? $_POST["take"] : 50);
	break;

	case "findUsers":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->SearchUsers($_POST["userID"], $_POST["searchTerm"], isset($_POST["page"]) ? $_POST["page"] : 1, isset($_POST["take"]) ? $_POST["take"] : 50);
	break;

	case "getLocationsForLatLong":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->GetLocationsForLatLong($_POST["userID"], $_POST["latitude"], $_POST["latitude"], 
		isset($_POST["distance"]) ? $_POST["distance"] : 50, isset($_POST["page"]) ? $_POST["page"] : 1, isset($_POST["take"]) ? $_POST["take"] : 50);
	break;

	case "getTimeline":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->Timeline($_POST["userID"], $_POST["clubID"], $_POST["forUserID"], $_POST["latitude"], $_POST["longitude"], $_POST["locationMode"], $_POST["sortByMode"], isset($_POST["page"]) ? $_POST["page"] : 1, isset($_POST["take"]) ? $_POST["take"] : 10);
	break;
    
        case "getMyPosts":
	$users = new UsersController();
	$users->server = $server;
	$data = $users->getMyPosts($_POST["userID"], isset($_POST["page"]) ? $_POST["page"] : 1, isset($_POST["take"]) ? $_POST["take"] : 10);
	break;
    
    	/**
	* Reset
	*/
	case "checkToken":
	$reset = new ResetController();
	$reset->server = $server;
	$data = $reset->GetTokenValid($_POST['username'], $_POST['token']);
	break;

	case "changePassword":
	$reset = new ResetController();
	$reset->server = $server;
	$data = $reset->ChangePassword($_POST['username'], $_POST['token'], $_POST['password']);
	break;

	case "forgotPassword":
	$reset = new ResetController();
	$reset->server = $server;
	$data = $reset->ResetPassword($_POST['email']);
	break;

	/**
	* Posts
	*/
	case "sendPost":
	$post = new PostsController();
	$post->server = $server;
	$data = $post->SendPost($_POST['userID'], $_POST['clubID'], $_POST["postTitle"], isset($_POST["postKeywords"]) ? $_POST["postKeywords"] : ""); // $_FILE["postImage"] (file)
	break;

	case "getRecentPosts":
	$post = new PostsController();
	$post->server = $server;
	$data = $post->GetRecentPosts($_POST['userID'], isset($_POST["take"]) ? $_POST["take"] : 50);
	break;

	case "getPopularPosts":
	$post = new PostsController();
	$post->server = $server;
	$data = $post->GetPopularPosts($_POST['userID'], isset($_POST["page"]) ? $_POST["page"] : 1, isset($_POST["take"]) ? $_POST["take"] : 50);
	break;
    
        case "deletePost":
	$post = new PostsController();
	$post->server = $server;
	$data = $post->DeletePost($_POST['postID']);
	break;
    
}
$server->sendData($data);
?>