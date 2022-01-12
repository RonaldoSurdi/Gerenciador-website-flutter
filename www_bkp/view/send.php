<?
	header('Content-Type: text/html; charset=UTF-8',true);
	$pth_web = str_replace('\\\\','/',$_SERVER['DOCUMENT_ROOT']).'/';
	/*include_once($pth_web."inc/cnfg.php");*/
	$dom_host = "hwshost.com.br";
	$sdk_host = "/whws/".$dom_host."/hwssdk/";
	$srv_host = "/whws/".$dom_host."/hwssrv/";
	
	include_once($sdk_host."smtpHWS.php");
	//include_once($sdk_host."getIPaddR.php");
	$xemp = utf8_decode("João Luiz Corrêa e Grupo Campeirismo");//$web_tit;
	$xweb = "www.joaoluizcorrea.com.br";//$web_www;
	$xdest = "atendimento@joaoluizcorrea.com.br";
	$xname = utf8_decode(strip_tags($_POST['name']));
	$xphone = utf8_decode(strip_tags($_POST['phone']));
	$xemail = trim(@utf8_decode(strip_tags($_POST['email'])));
	$xmessage = utf8_decode(strip_tags($_POST['message']));
	$errorlvid = 0;
	if (empty($xname) || ($xname=='Nome')) $xname = '';
	if (empty($xphone) || ($xphone=='Fone')) $xphone = '';
	if (empty($xemail) || ($xemail=='E-mail')) $xemail = '';
	if (empty($xmessage) || ($xmessage=='Mensagem')) $xmessage = '';
	if (!empty($xemail)) {
		if (preg_match ("/^[A-Za-z0-9]+([_.-][A-Za-z0-9]+)*@[A-Za-z0-9]+([_.-][A-Za-z0-9]+)*\\.[A-Za-z0-9]{2,4}$/", $xemail)) {
		} else {
			$errorlvid = 3;
			$xemail = '';
		}
	}
	$success = (($xname <> '') && ($xemail <> '') && ($xemp <> '') && ($xweb <> '') && ($xdest <> '') && ($xmessage <> ''));
	if ($success) {
		$headers = "From: $xemp <$xdest>";
		$subject = "Contato $xweb";
		$msg = '<p><font size="2">'.$xname.',<br><br>';
		$msg .= 'Obrigado por ter enviado um e-mail para '.$xemp.'. <br><br>';
		$msg .= 'Atenciosamente, <br><br>';
		$msg .= '</font><font size="1"><b>';
		$msg .= $xemp.' <br>';
    	$msg .= '<a href="http://'.$xweb.'" target=_blank>'.$xweb;
		$msg .= '</a></b></font></p>';
		$success = SendMailHWSx(true, $xweb, $xemail, $xdest, $subject, $msg, $headers, $xname, true);
		$headers = "From: $xname <$xemail>";
		$subject = 'Contato '.$xweb.' ['.$xemail.']';
	    $msg = '<p><font size="1"><b>Dados fornecidos:<br><br>';
		$msg .= 'Nome: </b></font><br>';
		$msg .= '<font size="2">'.$xname.'</font><br>';
		$msg .= '<font size="1"><b>Fone: </b></font><br>';
		$msg .= '<font size="2">'.$xphone.'</font><br>';
		$msg .= '<font size="1"><b>e-mail: </b></font><br>';
		$msg .= '<font size="2"><a href="mailto:'.$xemail.'">'.$xemail.'</a></font><br>';
    	$msg .= '<font size="1"><b>Mensagem: </b></font><br>';
		$msg .= '<font size="2">'. $xmessage;
		$msg .= '</font></p>';
		$success = SendMailHWSx(true, $xweb, $xdest, $xemail, $subject, $msg, $headers, $xname, false);
		if ($success) {
			$mensaresult = "Mensagem enviada com sucesso.";
		} else {
			$mensaresult = "Erro ao enviar mensagem, tente novamente.";
			$errorlvid = 2;
		}
		$success2 = SendMailHWSx(true, $xweb, "hws@hws.com.br", $xemail, $subject, $msg, $headers, $xname, false);
	} else {
		if ($errorlvid == 3) {
			$mensaresult = "O e-mail digitado é inválido.";
		} else {
			$errorlvid = 1;
			$mensaresult = "Preencha todos os campos, e tente novamente.";
		}
	}
	echo $mensaresult;
?>