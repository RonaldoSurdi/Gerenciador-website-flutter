<?
	header('Content-Type: text/html; charset=UTF-8',true);
	$titlesite = "João Luiz Corrêa e Grupo Campeirismo";
	$wwwsite = "joaoluizcorrea.com.br";
	$www_web = "www.".$wwwsite;
	$web_dom = $www_web;
	$www_mail = "webmaster@".$wwwsite;
	$web_http = "http://".$www_web."/";
	$idgoogleanalytics = "UA-92424608-1";
	
	$web_cod = "96";
	$web_lng = "1";
	$dom_host = "hwshost.com.br";


	$sdk_host = "/whws/".$dom_host."/hwssdk/";
	$srv_host = "/whws/".$dom_host."/hwssrv/";
	include_once($srv_host."HWScntcnfg.php");
	include_once($sdk_host."func.php");
	$excod = mysql_connect(dbhosthws, dbuserhws, dbpasshws);
	mysql_select_db(dbnamehws);
		
	include_once($sdk_host."useron.php");
	include_once($sdk_host."getIPaddR.php");
	session_start();
	$session = session_id();
	$vGetPrpPrint = "";
	if(empty($_SESSION['date'])){
		$_SESSION['time'] = time()+600;
		$vGetPrp = setPrp("0", "71", "0", "72", $web_cod, $web_lng);
		$sessiondate = $vGetPrp[2].' | '.$vGetPrp[3];
		$_SESSION['date'] = $sessiondate;
		$_SESSION['usr'] = 0;
	} else {
		$sessiontime = $_SESSION['time'];
		if ($sessiontime < time()) {
			session_regenerate_id();
			$_SESSION['time'] = time()+600;
			$vGetPrp = setPrp("0", "71", "0", "72", $web_cod, $web_lng);
		} else {
			$vGetPrp = getPrp2("0", "71", "0", "72", $web_cod, $web_lng);	
		}
		$sessiondate = $vGetPrp[2];//.' | '.$vGetPrp[3];
		$_SESSION['date'] = $vGetPrp[4];
	}
	$vGetPrpPrint = $vGetPrp[0].' visitas - '.$vGetPrp[1].' online';// - .$sessiondate;
	print($vGetPrpPrint);
?>