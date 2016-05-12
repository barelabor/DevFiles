<?php

class RestFormat
{

	const PLAIN = 'text/plain';
	const HTML = 'text/html';
	const AMF = 'applicaton/x-amf';
	const JSON = 'application/json';
	static public $formats = array(
		'plain' => RestFormat::PLAIN,
		'txt' => RestFormat::PLAIN,
		'html' => RestFormat::HTML,
		'amf' => RestFormat::AMF,
		'json' => RestFormat::JSON,
	);
}

/**
 * Description of RestServer
 *
 * @author jacob
 */
class RestServer
{
	public $url;
	public $method;
	public $params;
	public $format;
	public $cacheDir = '.';
	public $realm;
	public $mode;
	public $root;
	
	protected $map = array();
	protected $errorClasses = array();
	protected $cached;

	/**
	 * The constructor.
	 * 
	 * @param string $mode The mode, either debug or production
	 */
	public function  __construct($mode = 'debug', $realm = 'Rest Server')
	{
		$this->mode = $mode;
		$this->realm = $realm;
		$dir = dirname(str_replace($_SERVER['DOCUMENT_ROOT'], '', $_SERVER['SCRIPT_FILENAME']));
		$this->root = ($dir == '.' ? '' : $dir . '/');
	}
	
	public function  __destruct()
	{
		/*
		if ($this->mode == 'production' && !$this->cached) {
			if (function_exists('apc_store')) {
				apc_store('urlMap', $this->map);
			} else {
				file_put_contents($this->cacheDir . '/urlMap.cache', serialize($this->map));
			}
		}
		*/
	}
	
	public function refreshCache()
	{
		$this->map = array();
		$this->cached = false;
	}
	
	public function unauthorized($ask = false)
	{
		if ($ask) {
			header("WWW-Authenticate: Basic realm=\"$this->realm\"");
		}
		throw new RestException(401, "You are not authorized to access this resource.");
	}
	
	public function addErrorClass($class)
	{
		$this->errorClasses[] = $class;
	}
	
	public function handleError($statusCode, $errorMessage = null)
	{
		$method = "handle$statusCode";
		foreach ($this->errorClasses as $class) {
			if (is_object($class)) {
				$reflection = new ReflectionObject($class);
			} elseif (class_exists($class)) {
				$reflection = new ReflectionClass($class);
			}
			
			if ($reflection->hasMethod($method))
			{
				$obj = is_string($class) ? new $class() : $class;
				$obj->$method();
				return;
			}
		}
		
		$message = $this->codes[$statusCode] . ($errorMessage && $this->mode == 'debug' ? ': ' . $errorMessage : '');
		
		$this->setStatus($statusCode);
		$this->sendData(array('error' => array('code' => $statusCode, 'message' => $message, 'dodatno' => $_SERVER['DOCUMENT_ROOT'] , 'dodatno2' => $_SERVER['SCRIPT_FILENAME'], 'dodatno3' => $this->map )));
	}
	
	
	public function getMethod()
	{
		$method = $_SERVER['REQUEST_METHOD'];
		$override = isset($_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE']) ? $_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE'] : (isset($_GET['method']) ? $_GET['method'] : '');
		if ($method == 'POST' && strtoupper($override) == 'PUT') {
			$method = 'PUT';
		} elseif ($method == 'POST' && strtoupper($override) == 'DELETE') {
			$method = 'DELETE';
		}
		return $method;
	}
	
	public function getFormat()
	{
		$format = RestFormat::PLAIN;
		$accept_mod = preg_replace('/\s+/i', '', $_SERVER['HTTP_ACCEPT']); // ensures that exploding the HTTP_ACCEPT string does not get confused by whitespaces
		$accept = explode(',', $accept_mod);

		if (isset($_REQUEST['format']) || isset($_SERVER['HTTP_FORMAT'])) {
			// give GET/POST precedence over HTTP request headers
			$override = isset($_SERVER['HTTP_FORMAT']) ? $_SERVER['HTTP_FORMAT'] : '';
			$override = isset($_REQUEST['format']) ? $_REQUEST['format'] : $override;
			$override = trim($override);
		}
		
		// Check for trailing dot-format syntax like /controller/action.format -> action.json
		if(preg_match('/\.(\w+)$/i', $_SERVER['REQUEST_URI'], $matches)) {
			$override = $matches[1];
		}

		// Give GET parameters precedence before all other options to alter the format
		$override = isset($_GET['format']) ? $_GET['format'] : $override;
		if (isset(RestFormat::$formats[$override])) {
			$format = RestFormat::$formats[$override];
		} elseif (in_array(RestFormat::AMF, $accept)) {
			$format = RestFormat::AMF;
		} elseif (in_array(RestFormat::JSON, $accept)) {
			$format = RestFormat::JSON;
		}
		return $format;
	}
	
	public function getData()
	{
		$data = file_get_contents('php://input');
		
		if ($this->format == RestFormat::AMF) {
			require_once 'Zend/Amf/Parse/InputStream.php';
			require_once 'Zend/Amf/Parse/Amf3/Deserializer.php';
			$stream = new Zend_Amf_Parse_InputStream($data);
			$deserializer = new Zend_Amf_Parse_Amf3_Deserializer($stream);
			$data = $deserializer->readTypeMarker();
		} else {
			$data = json_decode($data);
		}
		
		return $data;
	}
	

	public function sendData($data)
	{
		header("Cache-Control: no-cache, must-revalidate");
		header("Expires: 0");
		header('Content-Type: ' . RestFormat::JSON);
		$data = json_encode($data);
		if ($data && $this->mode == 'debug') {
			$data = $this->json_format($data);
		}
		
		echo $data;
	}

	public function setStatus($code)
	{
		$code .= ' ' . $this->codes[strval($code)];
		header("{$_SERVER['SERVER_PROTOCOL']} $code");
	}
	
	public function getStatus($code)
	{
		return  $this->codes[strval($code)];
	}
	
	// Pretty print some JSON
	private function json_format($json)
	{
		$tab = "  ";
		$new_json = "";
		$indent_level = 0;
		$in_string = false;
		
		$len = strlen($json);
		
		for($c = 0; $c < $len; $c++) {
			$char = $json[$c];
			switch($char) {
				case '{':
				case '[':
					if(!$in_string) {
						$new_json .= $char . "\n" . str_repeat($tab, $indent_level+1);
						$indent_level++;
					} else {
						$new_json .= $char;
					}
					break;
				case '}':
				case ']':
					if(!$in_string) {
						$indent_level--;
						$new_json .= "\n" . str_repeat($tab, $indent_level) . $char;
					} else {
						$new_json .= $char;
					}
					break;
				case ',':
					if(!$in_string) {
						$new_json .= ",\n" . str_repeat($tab, $indent_level);
					} else {
						$new_json .= $char;
					}
					break;
				case ':':
					if(!$in_string) {
						$new_json .= ": ";
					} else {
						$new_json .= $char;
					}
					break;
				case '"':
					if($c > 0 && $json[$c-1] != '\\') {
						$in_string = !$in_string;
					}
				default:
					$new_json .= $char;
					break;					
			}
		}
		
		return $new_json;
	}


	private $codes = array(
		'100' => 'Continue',
		'200' => 'OK',
		'201' => 'Created',
		'202' => 'Accepted',
		'203' => 'Non-Authoritative Information',
		'204' => 'No Content',
		'205' => 'Reset Content',
		'206' => 'Partial Content',
		'300' => 'Multiple Choices',
		'301' => 'Moved Permanently',
		'302' => 'Found',
		'303' => 'See Other',
		'304' => 'Not Modified',
		'305' => 'Use Proxy',
		'307' => 'Temporary Redirect',
		'400' => 'Bad Request',
		'401' => 'Unauthorized',
		'402' => 'Payment Required',
		'403' => 'Forbidden',
		'404' => 'Not Found',
		'405' => 'Method Not Allowed',
		'406' => 'Not Acceptable',
		'409' => 'Conflict',
		'410' => 'Gone',
		'411' => 'Length Required',
		'412' => 'Precondition Failed',
		'413' => 'Request Entity Too Large',
		'414' => 'Request-URI Too Long',
		'415' => 'Unsupported Media Type',
		'416' => 'Requested Range Not Satisfiable',
		'417' => 'Expectation Failed',
		'500' => 'Internal Server Error',
		'501' => 'Not Implemented',
		'503' => 'Service Unavailable'
	);
}

class RestException extends Exception
{
	
	public function __construct($code, $message = null)
	{
		parent::__construct($message, $code);
	}
	
}
