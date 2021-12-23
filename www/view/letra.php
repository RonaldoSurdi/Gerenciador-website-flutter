<?
	header('Content-Type: text/html; charset=UTF-8',true);
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
	$pth_web = str_replace('\\\\','/',$_SERVER['DOCUMENT_ROOT']).'/';
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
	$web_feed_tags = "<br><p><a><b><u><i><img><table><td><tr><TBODY><div><iframe><h1><h2><h3><h4><h5><h6><ul><li><strong><P><STRONG>";//<font>
	$web_feed_tags2 = "<br>";//<font>
	$web_replace_find = array($www_host_Img,' align=center',' align=justify',' align=left',' align=right');
	$web_replace_repl = array($www_web_Img,'','','','');

	$sdk_host = "/whws/".$dom_host."/hwssdk/";
	$srv_host = "/whws/".$dom_host."/hwssrv/";
	include_once($srv_host."HWScntcnfg.php");
	include_once($sdk_host."func.php");
	$excod = mysql_connect(dbhosthws, dbuserhws, dbpasshws);
	mysql_select_db(dbnamehws);
	/***CNFG FOTOS****/
	$pth_tmp = "E:/tmp/img/";
	$pth_ImgHost = "E:/whws/".$dom_host."/mns94SeIo/".$web_cod."/";
	$galcnfg = array(15);
	$galcnfg['id'] = array("01","02","03");
	$galcnfg['pathWW'] = array("","-tablet","-smart");
	$galcnfg['icoWid'] = array("100","100","100");
	$galcnfg['icoHei'] = array("100","100","100");
	$galcnfg['flyWid'] = array("400","400","300");
	$galcnfg['flyHei'] = array("400","400","300");
	$galcnfg['minWid'] = array("300","200","100");
	$galcnfg['minHei'] = array("225","150","75");
	$galcnfg['ampWid'] = array("1600","800","600");
	$galcnfg['ampHei'] = array("1200","600","480");
	$galcnfg['icohom'] = array("200","100","50");
	$galcnfg['banWid'] = array("1600","800","500");
	$galcnfg['banHei'] = array("900","450","281");
	$galcnfg['banMin'] = array("600","300","150");
	$galcnfg['qulity'] = array(90,70,70);
	$galcnfgCount = count($galcnfg['id']);
	$galcnfgID = 0;
	if ($web_ismob) $galcnfgID = 2;
	//Imagens WWW
	$www_host_Img = "http://www.".$dom_host."/HWSimgs/".$web_cod."/";
	$www_web_Img = $web_http."images/foto".$galcnfg['pathWW'][$galcnfgID]."/";
	$www_web_ImgAmpli = $www_web_Img."amplia/";
	$www_web_ImgThumb = $www_web_Img."thumb/";
	$www_web_ImgIcons = $www_web_Img."icons/";
	$www_web_ImgFlyer = $www_web_Img."flyer/";
	$www_web_ImgHompg = $www_web_Img."ico/";
	$www_web_ImgBanns = $www_web_Img."banners/";
	//Path Web
	$pth_ImgWeb = "E:/www/mobile/".$wwwsite."/".$galcnfg['id'][$galcnfgID]."/";
	$pth_ImgWeb_Ampli = $pth_ImgWeb."amplia/";
	$pth_ImgWeb_Thumb = $pth_ImgWeb."thumb/";
	$pth_ImgWeb_Icons = $pth_ImgWeb."icons/";
	$pth_ImgWeb_Flyer = $pth_ImgWeb."flyer/";
	$pth_ImgWeb_Hompg = $pth_ImgWeb."ico/";
	$pth_ImgWeb_Banns = $pth_ImgWeb."banners/";
	//Imagens Size Web
	$web_icoWid = $galcnfg['icoWid'][$galcnfgID];
	$web_icoHei = $galcnfg['icoHei'][$galcnfgID];
	$web_flyWid = $galcnfg['flyWid'][$galcnfgID];
	$web_flyHei = $galcnfg['flyHe'][$galcnfgID];
	$web_minWid = $galcnfg['minWid'][$galcnfgID];
	$web_minHei = $galcnfg['minHei'][$galcnfgID];
	$web_ampWid = $galcnfg['ampWid'][$galcnfgID];
	$web_ampHei = $galcnfg['ampHei'][$galcnfgID];
	$web_icoHom = $galcnfg['icohom'][$galcnfgID];
	$web_banWid = $galcnfg['banWid'][$galcnfgID];
	$web_banHei = $galcnfg['banHei'][$galcnfgID];
	$web_banMin = $galcnfg['banMin'][$galcnfgID];
	$web_qulity = $galcnfg['qulity'][$galcnfgID];
	/***CNFG FOTOS****/	

	$xidmdl50 = "830";
	$xidmdl51 = "831";
	$xidmdl52 = "832";
	$xidmdl53 = "833";
	$xcodtpSet = "207";
	$xreg_txt = ",textft";
	$xstatx = '';//' AND xstat=1';
	$desc_imgs = '';
			
	$excod2 = mysql_query("SELECT cod_img,descricao,textft FROM m0_fky".$xidmdl52." WHERE cod_img='".$xid."' AND cod_lng='".$web_lng."'");
	$axpmusics = '';
	$axtagmucs = '';
	if ($excod2) { 
		while($listasql2 = mysql_fetch_array($excod2)) {
			//$axwh = $listasql[1];
			$axpmuscid = $listasql2[0];
			$axpmtitle = $listasql2[1];
			$axpmuslet = $listasql2[2];
			$axpmuslet = str_replace("\\r\\n", "<br>", $axpmuslet);
			$axpmuslet = str_replace("\r\n", "<br>", $axpmuslet);
			$axpmuslet = str_replace("\\n", "<br>", $axpmuslet);
			$axpmuslet = str_replace("\n", "<br>", $axpmuslet);
			$axpmuslet = trim($axpmuslet);
			$desc_imgs.= '<p>'.$axpmuslet.'</p>';

		}
	}

	$desc_imgs = utf8_encode($desc_imgs);
	print($desc_imgs);
?>