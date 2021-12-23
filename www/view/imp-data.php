<?
	header('Content-Type: text/html; charset=UTF-8',true);
	$pth_web = str_replace('\\\\','/',$_SERVER['DOCUMENT_ROOT']).'/';
	session_start();
	if((empty($_SESSION['senha'])) || (!$_SESSION['senha'])) {
		include_once($pth_web.'view/imp-form.php');
		exit;
	} else {
	  if ($_SESSION['senha'] != md5("jlc2017")) {
		include_once($pth_web.'view/imp-form.php');
		exit;
	  }
	}	
	$titlesite = "João Luiz Corrêa e Grupo Campeirismo";
	$wwwsite = "joaoluizcorrea.com.br";
	$www_web = "www.".$wwwsite;
	$web_dom = $www_web;
	$www_mail = "webmasater@".$wwwsite;
	$web_http = "http://".$www_web."/";
	$idgoogleanalytics = "UA-92424608-1";
	$xid = '';
	if (isset($_GET['id'])) {
		$xid = $_GET['id'];
	}	
	$setpgParse = explode('-', $xid);
	$setpgAlb = $setpgParse[0];
	$setpgCod = $setpgParse[1];
	$web_ismob = false;
	/*if ($_SERVER["HTTP_HOST"] <> $web_www) {
		header("Location: ".$web_http.$xid);
	} else {
		include_once($pth_web."inc/mobile_detect.php");
		if (isMobile()) {
			$web_ismob = true;
			//header("Location: ".$www_mob.$xid);
		}
	}*/
	
	//****
	$cntlogo = "logo.png";
	$mapview = false;
	$grpview = true;

	$web_cod = "96";
	$web_lng = "1";
	$dom_host = "hwshost.com.br";
	
	$www_host = "www.".$dom_host."/";
	$www_host_Img = $www_host."hwsimgs/".$web_cod."/";
	$www_web_Img = $www_web."images/fotos/";
	$web_feed_tags = "<br><p><a><b><u><i><img><table><td><tr><TBODY><div><iframe><h1><h2><h3><h4><h5><h6><ul><li><strong><P><STRONG><font>";//
	$web_feed_tags2 = "<br>";//<font>
	$web_replace_find = array($www_host_Img,' align=center',' align=justify',' align=left',' align=right');
	$web_replace_repl = array($www_web_Img,'','','','');

	$sdk_host = "/whws/".$dom_host."/hwssdk/";
	$srv_host = "/whws/".$dom_host."/hwssrv/";
	include_once($srv_host."HWScntcnfg.php");
	include_once($sdk_host."func.php");
	$excod = mysql_connect(dbhosthws, dbuserhws, dbpasshws);
	mysql_select_db(dbnamehws);
	
	//download	
	$excod = mysql_query("SELECT codigo,txt from m0_fky200 WHERE cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND xtp='155'");
	$xtag = '';
	if ($excod) { 
		while($listasql = mysql_fetch_array($excod)) {
			$axptTXT = $listasql[1];
			$xtag .= $axptTXT;
		}
	}
	if (empty($xtag)) { 
		$xtag = "<p>EM BREVE.</p>";
	}
	//$xtag = str_replace($web_replace_find,$web_replace_repl,$xtag);
	$xtag = strip_tags($xtag, $web_feed_tags);
	$xtag = utf8_encode($xtag);
	//sql end
?>
			<div class="imprensa-agileits">
                <h4>Área do Contratante</h4>
				<? print($xtag); ?>
			</div>