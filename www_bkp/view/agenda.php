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
	//$setpgParse = explode('-', $xid);
	//$setpgAlb = $setpgParse[0];
	//$setpgCod = $setpgParse[1];
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
	
	
	$xdtang = date("Ymd")." ".date("00:00:00");
	$excod = mysql_query("SELECT codigo,xdt,loc,cid,uf,descricao,textft FROM m0_fky750 WHERE codigo='".$xid."' AND cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1 AND xtp='33' AND xstat=1 AND xdt>='".$xdtang."' ORDER BY xdt,codigo");
	$xtag = '';
	$desc_imgs = '';
	$axtagagnd = '';	
	if ($excod) { 
		while($listasql = mysql_fetch_array($excod)) {
			/* aqui */
			$axptimN = strtoupper(md5("m0_fky751_icon_cod_gal_".$listasql[0]));
			$axptimT = $axptimN.".hws";
			$axptimJ = $axptimN.".jpg";
			$_File_WebIcons = $www_web_ImgIcons.$axptimJ;
			$_File_WebFlyer = $www_web_ImgFlyer.$axptimJ;
			// if (file_exists($pth_ImgWeb_Icons.$axptimJ)) unlink($pth_ImgWeb_Icons.$axptimJ);
			$geralink = ((!file_exists($pth_ImgWeb_Icons.$axptimJ)) || (!file_exists($pth_ImgWeb_Flyer.$axptimJ)));
			if ((file_exists($pth_ImgHost.$axptimT)) && ($geralink)) {
				$xfname_tmp = $pth_ImgHost.$axptimT;
				$imTest = @imagecreatefromjpeg($xfname_tmp);
				$xfname_ico = $pth_ImgWeb_Icons.$axptimJ;
				$xfname_fly = $pth_ImgWeb_Flyer.$axptimJ;
				if($imTest) {
					$xfname_tmp_orig = imagecreatefromjpeg($xfname_tmp);
					$pontoX = imagesx($xfname_tmp_orig);
					$pontoY = imagesy($xfname_tmp_orig);
					//*****************************
					$escalafly = max($web_flyWid/$pontoX,$web_flyHei/$pontoY); 
					$Calc_flyWid = floor($escalafly*$pontoX);
					$Calc_flyHei = floor($escalafly*$pontoY);
					$Calc_Xfly = 0;
					$Calc_Yfly = 0;
					$xfname_tmp_fin = imagecreatetruecolor($Calc_flyWid, $Calc_flyHei);
					imagecopyresampled($xfname_tmp_fin, $xfname_tmp_orig, 0, 0, 0, 0, $Calc_flyWid+1, $Calc_flyHei+1, $pontoX, $pontoY);
					imagejpeg($xfname_tmp_fin, $xfname_fly);
					imagedestroy($xfname_tmp_fin); 
					//*****************************
					$escalaico = max($web_icoWid/$pontoX,$web_icoHei/$pontoY); 
					$Calc_icoWid = round($escalaico*$pontoX);
					$Calc_icoHei = round($escalaico*$pontoY);
					$Calc_Xico = 0;
					$Calc_Yico = 0;
					if ($Calc_icoWid>$Calc_icoWid) $Calc_Xico = round(($Calc_icoWid-$Calc_icoWid)/2);
					else $Calc_Yico = round(($Calc_icoHei-$Calc_icoHei)/2);
					$xfname_tmp_fin = imagecreatetruecolor($web_icoWid, $web_icoHei);
					imagecopyresampled($xfname_tmp_fin, $xfname_tmp_orig, 0, 0, $Calc_Xico, $Calc_Yico, $Calc_icoWid+1, $Calc_icoHei+1, $pontoX, $pontoY);
					imagejpeg($xfname_tmp_fin, $xfname_ico);
					imagedestroy($xfname_tmp_fin); 
					//****************************
					imagedestroy($xfname_tmp_orig);
					$geralink = true;
				}
			}
			$meses = array (1 => "JAN", 2 => "FEV", 3 => "MAR", 4 => "ABR", 5 => "MAI", 6 => "JUN", 7 => "JUL", 8 => "AGO", 9 => "SET", 10 => "OUT", 11 => "NOV", 12 => "DEZ");
			$geralink = (file_exists($pth_ImgWeb_Icons.$axptimJ));			
			/* aqui */			
			$xtag .= '<div class="item wthree1" data-aos="zoom-in"><div class="w3-agileits">';
			$axwh = $listasql[0];					
			$axcp18 = $listasql[1];
			$axingr = $listasql[2];
			$messtr = $meses[(int) substr($axcp18,5,2)];
			if (empty($messtr)) $messtr=$meses[(int) date(n)];
			$xaxdt = '<div class="agdt"><span class="dia">'.substr($axcp18,8,2).'</span><span class="mes">'.$messtr.'</span></div>'; /*.'/'.substr($axcp18,0,4)*/
			$xcp18t = substr($axcp18,11,2).':'.substr($axcp18,14,2);
			$axpttxt = $listasql[6];//agenda
			$axpttxt = strip_tags($axpttxt, $web_feed_tags2);
			$axpttxt = str_replace("\\r\\n", "<br>", $axpttxt);
			$axpttxt = str_replace("\r\n", "<br>", $axpttxt);
			$axpttxt = str_replace("\\n", "<br>", $axpttxt);
			$axpttxt = str_replace("\n", "<br>", $axpttxt);
			/*$axpttxt = str_replace("<br><br>", "<br>", $axpttxt);*/
			if ($xcp18t <> '00') {
				$xaxdt = $xaxdt.'<div class="agtm"><span class="hora">'.utf8_decode('às').' '.$xcp18t.'hs</span></div>';
			}
			$xcpcid = $listasql[3];
			if ($listasql[4] <> "") {
				$xcpcid .= ' / '.$listasql[4];
				//$link_googlemaps = '<a href="http://maps.google.com.br/maps?f=q&source=s_q&hl=pt-PT&geocode=&q='.$listasql[3].','.$listasql[4].'" target="_blank">Abrir Localiza??o no Google Maps</a>';
			}
			$axtext = $xaxdt;
			$axtitle = $listasql[5];
			$axtext.= '<div class="aglc"><h3>'.$xcpcid.'</h3><h2>'.$axtitle.'</h2></div>';
			/*if ($geralink) {
				$axtext .= 	'<a id="imget" href="'.$_File_WebFlyer.'"><img src="'.$_File_WebFlyer.'" alt="'.$listasql[5].'"></a><br>';
			}*/
			$desc_imgs.= '<div class="divcap"><img src="images/agenda-info.png" alt="Agenda"></div><div class="divtxt"><h2>'.$axtitle.'</h2><p>'.$axpttxt.'</p></div>';
			//$axtext .= $xcptxt;// <h3>'.$xcpcid.'</h3>
			//$sURL = urlencode('http' . ($_SERVER['SERVER_PORT'] == 443 ? 's' : '') . '://' . $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF']);			
			$axtext .= '<div class="rodape">';
			$axtext.= '<div class="infosh"><div class="agl"><a title="'.utf8_decode('Informações').' sobre o Evento" rel="'.$axwh.'"><img class="img-responsive" src="'.$_File_WebIcons.'" alt="'.$axtitle.'"></a><img src="/images/social/maisinfo.png"></div>';
			//$axtext .= '<div class="infosh"><a href="#info'.$axwh.'" title="'.utf8_decode('Informações').' sobre o Evento"><img src="/images/social/maisinfo.png"></a>';
			if ($axingr != '') $axtext .= '<a href="'.$axingr.'" title="Comprar Ingresso" target="_blank"><img src="/images/social/compreingresso.png"></a>';
			$axtext .= '</div>';
			$axtext .= '<div class="socialsh">Compartilhar:<br/><a href="http://www.facebook.com/sharer.php?u='.urlencode($web_http).'&t='.utf8_encode($titlesite).'" title="Compartilhar no Facebook" target="_new"><img src="/images/social/fb-ico.png"></a>';
			$axtext .= '<a href="http://twitter.com/share?text='.utf8_encode($web_tit).'&url='.utf8_encode($web_http).'" title="Compartilhar no Twitter" target="_new"><img src="/images/social/tw-ico.png"></a>';
			$axtext .= '<a href="https://plus.google.com/share?url='.utf8_encode($web_http).'" title="Compartilhar no Google" target="_new"><img src="/images/social/gg-ico.png"></a></div>';
			$axtext .= '</div>';
			$xtag .= $axtext.'</div></div>';
			$axtagagnd = '<div class="row">';
			$axtagagnd.= '<div class="col-md-6"><div class="cap"><img src="images/agenda-info.png" alt="Agenda"></div></div>';
			$axtagagnd.= '<div class="col-md-6"><div id="jp_container"><h2>'.$axtitle.'</h2><p>'.$axpttxt.'</p></div></div>';
			$axtagagnd.= '</div>';
		}	
	}
	//$axtagagnd = $xid;
	/*if ($xtag == '') { 
		$xtag = "<li>Nenhuma data cadastrada...</li>";
	}
	$xtag .= '</ul>';*/
	$axtagagnd = utf8_encode($axtagagnd);
	//$desc_imgs = utf8_encode($desc_imgs);
	print($axtagagnd);

?>