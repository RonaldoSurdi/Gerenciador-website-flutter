<?
	header('Content-Type: text/html; charset=UTF-8',true);
	$pth_web = str_replace('\\\\','/',$_SERVER['DOCUMENT_ROOT']).'/';
	/*session_start();
	if((empty($_SESSION['senha'])) || (!$_SESSION['senha'])) {
		include_once($pth_web.'view/imp-form.php');
		exit;
	} else {
	  if ($_SESSION['senha'] != md5("jlc2017")) {
		include_once($pth_web.'view/imp-form.php');
		exit;
	  }
	}*/	
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
	$xcodtpSet = '';
	$excod = mysql_query("SELECT codigo,cp1,cp3,cp5 FROM m0_fky95 WHERE cod_web='".$web_cod."' AND cp6=0 ORDER BY codigo desc limit 30");//AND cp6=0 AND xtp='".$xcodtpSet."' 
	$xtag = '';
	if ($excod) { 
		while($listasql = mysql_fetch_array($excod)) {
			$axcp18 = $listasql[3];
			$xaxdt = substr($axcp18,8,2).'/'.substr($axcp18,5,2).'/'.substr($axcp18,2,2).utf8_decode(' às ').substr($axcp18,11,2).'hs';
			/*$xcp18t = substr($axcp18,11,5);
			if ($xcp18t <> '00:00') {
				$xaxdt = $xaxdt.' '.$xcp18t;
			}*/
			$msgtxt = $listasql[2];
			$msgtxt = rtrim($msgtxt);
			$msgtxt = addslashes($msgtxt);
			$xtag .= '<p><span class="recnm">'.$listasql[1].'</span> <span class="recdt">('.$xaxdt.')</span><br>'.$msgtxt.'</p>';
		}
	}
	if (empty($xtag)) { 
		$xtag = "<p>Nenhum Recado cadastrado em nosso Mural...</p>";
	}
	$xtag = utf8_encode($xtag);
?>
                <h4>Mural de Recados</h4>
				<div class="central_wrapper">
                    <div class="central_text">
                        <div class="text_holder">
                        <? print($xtag); ?>
                        </div>
                    </div>
                    <span class="controllers2 controller2_down"></span>
                    <span class="controllers2 controller2_up"></span>                    
                </div>