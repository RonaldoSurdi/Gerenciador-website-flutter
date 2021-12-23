<?
	header('Content-Type: text/html; charset=UTF-8',true);
	$pth_web = str_replace('\\\\','/',$_SERVER['DOCUMENT_ROOT']).'/';
	/*include_once($pth_web."inc/cnfg.php");*/
	$dom_host = "hwshost.com.br";
	$sdk_host = "/whws/".$dom_host."/hwssdk/";
	$srv_host = "/whws/".$dom_host."/hwssrv/";
	$web_cod = "96";
	$web_lng = "1";
	$xcodtpSet = '1';
	include_once($sdk_host."smtpHWS.php");
	include_once($srv_host."HWScntcnfg.php");
	include_once($sdk_host."func.php");
	//include_once($sdk_host."getIPaddR.php");

	//include_once($sdk_host."getIPaddR.php");
	$xemp = utf8_decode("João Luiz Corrêa e Grupo Campeirismo");//$web_tit;
	$xweb = "www.joaoluizcorrea.com.br";//$web_www;
	$xdest = "atendimento@joaoluizcorrea.com.br";
	$xname = utf8_decode(strip_tags($_POST['name']));
	$xemail = trim(@utf8_decode(strip_tags($_POST['email'])));
	$xciduf = utf8_decode(strip_tags($_POST['ciduf']));
	$xmessage = utf8_decode(strip_tags($_POST['message']));
	$errorlvid = 0;
	if (empty($xname) || ($xname=='Nome')) $xname = '';
	if (empty($xemail) || ($xemail=='E-mail')) $xemail = '';
	if (empty($xmessage) || ($xmessage=='Mensagem')) $xmessage = '';
	if (empty($xciduf) || ($xciduf=='Cidade/UF')) $xciduf = '';
	if (!empty($xemail)) {
		if (preg_match ("/^[A-Za-z0-9]+([_.-][A-Za-z0-9]+)*@[A-Za-z0-9]+([_.-][A-Za-z0-9]+)*\\.[A-Za-z0-9]{2,4}$/", $xemail)) {
		} else {
			$errorlvid = 3;
			$xemail = '';
		}
	}
	$successres = "0";
	$success = (($xname <> '') && ($xemail <> '') && ($xemp <> '') && ($xweb <> '') && ($xdest <> '') && ($xmessage <> ''));
	if ($success) {
		$headers = "From: $xemp <$xdest>";
		$subject = "Mural de Recado $xweb";
		$msg = '<p><font size="2">'.$xname.',<br><br>';
		$msg .= 'Obrigado por enviar deixar seu recado em nosso mural.<br><br>';
		$msg .= 'Atenciosamente, <br><br>';
		$msg .= '</font><font size="1"><b>';
		$msg .= $xemp.' <br>';
    	$msg .= '<a href="http://'.$xweb.'" target=_blank>'.$xweb;
		$msg .= '</a></b></font></p>';
		$success = SendMailHWSx(true, $xweb, $xemail, $xdest, $subject, $msg, $headers, $xname, true);
		$headers = "From: $xname <$xemail>";
		$subject = 'Mural de Recado '.$xweb.' ['.$xemail.']';
	    $msg = '<p><font size="1"><b>Dados fornecidos:<br><br>';
		$msg .= 'Nome: </b></font><br>';
		$msg .= '<font size="2">'.$xname.'</font><br>';
		$msg .= '<font size="1"><b>e-mail: </b></font><br>';
		$msg .= '<font size="2"><a href="mailto:'.$xemail.'">'.$xemail.'</a></font><br>';
    	$msg .= '<font size="1"><b>Recado: </b></font><br>';
		$msg .= '<font size="2">'. $xmessage;
		$msg .= '</font></p>';
		/*$success = SendMailHWSx(true, $xweb, $xdest, $xemail, $subject, $msg, $headers, $xname, false);
		if (!$success) {
			$errorlvid = 2;
		}*/
		$success2 = SendMailHWSx(true, $xweb, "hws@hws.com.br", $xemail, $subject, $msg, $headers, $xname, false);
		//add base		
		$excod = mysql_connect(dbhosthws, dbuserhws, dbpasshws);
		mysql_select_db(dbnamehws);
		$axwh = 1;
		$excod = mysql_query("SELECT MAX(codigo) FROM m0_fky95");
		  if ($excod) { 
			while($listasql = mysql_fetch_array($excod)) {
				$axwh = $listasql[0];
				$axwh = $axwh + 1;
			}
		  } else {
			$axwh = 1;
		  }
		$vx_cp1 = $xname;
		$vx_cp2 = $xemail;
		$vx_cp3 = $xmessage;
		$vx_cp4 = '-1';
		$axdthr = date("Ymd")." ".date("H:i:s");
		$vx_cp6 = '1';
		$vx_cp7 = getIPAddress();
		$v1_1 = '0';
		$v1_2 = $xciduf; //$xme_city;
		$v1_3 = '';
		/*if ($xme_city) {
			$array_city=explode("/",$v1_2);
			if ($array_city[0] <> '') {
				$v1_2 = $array_city[0];
			}
			if ($array_city[1] <> '') {
				$v1_3 = $array_city[1];
			}
		}*/
		$lb_cp4 = $xcodtpSet; //mobile
		$excod = mysql_query("INSERT INTO m0_fky95 (codigo, cod_web, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cod_cid, cid, uf, xtp) VALUES('".$axwh."','".$web_cod."','".$vx_cp1."','".$vx_cp2."','".$vx_cp3."','".$vx_cp4."','".$axdthr."','".$vx_cp6."','".$vx_cp7."','".$v1_1."','".$v1_2."','".$v1_3."','".$lb_cp4."');");
		if ($excod) $successres = "1";
	}
	echo $successres;
?>