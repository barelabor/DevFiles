<?php
require('Libs/mail/class.phpmailer.php');
require('Libs/mail/class.smtp.php');
require('Libs/mail/class.pop3.php');
class Email {
	var $mail;
	var $pop3 = null;
	var $body;
	var $subject;
	var $from;
	var $from_name;
	var $to;
	var $to_name;
	var $errorMessage = "";
	
	function Email($to, $to_name, $from, $from_name, $subject, $body)
	{
		$this->to = filter_var($to, FILTER_SANITIZE_EMAIL);
		$this->to_name = filter_var($to_name, FILTER_SANITIZE_STRING);
		$this->from = filter_var($from, FILTER_SANITIZE_EMAIL);
		$this->from_name = filter_var($from_name, FILTER_SANITIZE_STRING);
		
		$this->mail = new PHPMailer();
		$this->mail->IsSMTP(); 
		$this->mail->IsHTML(true); 
		$this->mail->CharSet='UTF-8';
		$this->mail->AddAddress($this->to, $this->to_name);
		$this->mail->Body = $body;
		$this->mail->From = $this->from;
		$this->mail->FromName = $this->from_name;
		$this->mail->Subject = $subject;
		$this->SMTPSecure = 'ssl'; // secure transfer enabled REQUIRED for GMail
		$this->mail->Host = MAIL_SERVER;
		$this->mail->Port = MAIL_PORT;
		$this->mail->SMTPAuth = SMTP_AUTH;
		$this->mail->Username = MAIL_USER;
		$this->mail->Password = MAIL_PASS;
	}
	
	function Send()
	{
		if($this->to != "" && $this->to_name != "" && filter_var($this->to, FILTER_VALIDATE_EMAIL) && filter_var($this->from, FILTER_VALIDATE_EMAIL)) 
		{
			if(POP3_AUTH == true)
			{
				if($this->pop3 == null)
				{
					$this->pop3 = new POP3();
				}
				
				$this->pop3->Authorise(POP3_SERVER, POP3_PORT, 30, POP3_USER, POP3_PASS, 1);
			}
			
			return $this->mail->Send();
		}
		else
		{
			$this->errorMessage = "Invalid e-mail parameters.";
		}
	}
	
	function ErrorMessage()
	{
		$error = "";
		if($this->errorMessage != "")
		{
			$error = $this->errorMessage;
		}
		else
		{
			$error = $this->mail->ErrorInfo;
		}
		
		return $error;
	}
}
?>