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
	
	$xidmdl50 = "840";
	$xidmdl51 = "841";
	$xidmdl52 = "842";
	$xidmdl53 = "843";
	$xcodtpSet = "146";
	$xidmdDescSQL = "";//" desc"
	$xcodset = "biografia";
	$GrpF_Vsb = false;
	$banTop = false;
	$xreg_txt = ",textft";
	//ini
	$xtagTitle = '';
	$tagContent = '';
	$tagContent_Imgs = '';
	$tagContent_Desc = '';
	$xstatx = '';//' AND xstat=1';
	$xdtx = 'cod_gal';
	$xcod_galDt = '';
	$GrpF_SEObarD = '<a href="/'.$setpHT;
	$axptButtonPrint = '';
	$xcod_gal = 0;
	$xgalidSet = -1;
	$xgaldados = array(3);
	$xgaldados['id'] = array();
	$xgaldados['cod'] = array();
	$xgaldados['title'] = array();
	$xgaldados['url'] = array();
	$xgaldadoscount = 0;
	/*$excod = mysql_query("SELECT cod_gal,descricao FROM m0_fky".$xidmdl50." WHERE cod_gal='".$xid."' AND cod_web='".$web_cod."' AND cod_ls=-1 AND xtp='".$xcodtpSet."' ORDER BY ".$xdtx.$xidmdDescSQL.";");
	$xcod_gal = $xid;
	if ($excod) {
		while($listasql = mysql_fetch_array($excod)) {
			$axptcod = $listasql[0];
			$axpttag = $listasql[1];
			$axpttag = str_replace("\\r\\n", "", $axpttag);
			$axptLink = urlSEO($axpttag);
			$axptButton = $GrpF_SEObarD."/".$axptLink.'" alt="'.$titlesb." ".$axpttag.'">'.$axpttag.'</a>';
			//*******************
			$xgaldados['id'][$xgaldadoscount] = $xgaldadoscount+1;
			$xgaldados['cod'][$xgaldadoscount] = $axptcod;
			$xgaldados['title'][$xgaldadoscount] = $axpttag;
			$xgaldados['url'][$xgaldadoscount] = $axptButton;
			//if (($xcodset == $axptLink)) {
				//$xcod_gal = $listasql[0];
				//$axptButtonPrint.= '<li>'.$axpttag.'</li>';
				//$xgalidSet = $xgaldadoscount;
			//} else {
				//$axptButtonPrint.= '<li>'.$axptButton.'</li>';
			//}
			//$xgaldadoscount++;
		}
		//$axptButtonPrint = '<div id="navtitle"><ul>'.$axptButtonAll.$axptButtonPrint.'</ul></div><div class="clear"></div>';
		$viewalb = true;
	} else {
		$viewalb = false;	
	}*/
	/*if (!$viewalb) {
		$tagContent.= '<p><strong>Erro 404:</strong> A URL não foi localizada...<br><br><br></p>';
		$tagContent.= '<p><a href="/">Voltar</a></p>';
	} else {*/
	$xcod_gal = $xid;
		$printfancyboxEft = true;
		$axtagart = '';
		/*if ($xgalidSet <> -1) {
			$xgaldadoscount = 1;
			$printfancyboxEft = false;
		}*/
		$galID = 0;
		//for ($xgalid = 0; $xgalid < $xgaldadoscount; $xgalid++) {
			if ($printfancyboxEft) $galID = $xgalid;
			else $galID = $xgalidSet;
			$prtID = $galID+1;
			//$xcod_gal = $xgaldados['cod'][$galID];
			//$xtitle_gal = $xgaldados['title'][$galID];
			$xtag_imgs = '';
			$desc_imgs = '';
			$xtag_imgs.= '<div class="team-bottom" style="visibility: visible; animation-delay: 0.3s; animation-name: fadeInRight;">';
			$excod = mysql_query("SELECT cod_gal,cod_img,descricao,textft FROM m0_fky".$xidmdl52." WHERE cod_img='".$xcod_gal."' AND cod_lng='".$web_lng."'");
			$_File_Web = "";
			$_File_WebThumb = "";
			if ($excod) { 
				while($listasql = mysql_fetch_array($excod)) {
					$axwh = $listasql[1];
					$axpttag = $listasql[2];
					$axpttxt = $listasql[3];
					$axpttxt = nl2br(strip_tags($axpttxt));
					$axpttag = str_replace("\\r\\n", "", $axpttag);
					$axptimN = strtoupper(md5("m0_fky".$xidmdl53."_img_larg_cod_img_".$axwh));
					$axptimT = $axptimN.".hws";
					$axptimJ = $axptimN.".jpg";
					$imgcopy = false;
					if (file_exists($pth_ImgHost.$axptimT)) {
						if (exif_imagetype($pth_ImgHost.$axptimT) === IMAGETYPE_PNG) {					
							$axptimJ = $axptimN.".png";
							$imgcopy = true;
						} else if (exif_imagetype($pth_ImgHost.$axptimT) === IMAGETYPE_SWF) {					
							$axptimJ = $axptimN.".swf";
							$imgcopy = true;
						} else if (exif_imagetype($pth_ImgHost.$axptimT) === IMAGETYPE_GIF) {					
							$axptimJ = $axptimN.".gif";
							$imgcopy = true;
						}
					}
					$_File_Web = $www_web_ImgAmpli.$axptimJ;
					$_File_WebThumb = $www_web_ImgThumb.$axptimJ;
					$geralink = ((!file_exists($pth_ImgWeb_Ampli.$axptimJ)) || (!file_exists($pth_ImgWeb_Thumb.$axptimJ)) || (!file_exists($pth_ImgWeb_Hompg.$axptimJ)));
					if ($imgcopy && $geralink) {
						$axptimNico = strtoupper(md5("m0_fky".$xidmdl53."_img_ico_cod_img_".$axwh));
						$axptimTico = $axptimNico.".hws";
						copy($pth_ImgHost.$axptimTico,($pth_ImgWeb_Thumb.$axptimJ));
						copy($pth_ImgHost.$axptimTico,($pth_ImgWeb_Hompg.$axptimJ));
						copy($pth_ImgHost.$axptimT,($pth_ImgWeb_Ampli.$axptimJ));
					} else if ((file_exists($pth_ImgHost.$axptimT)) && ($geralink)) {
						$xfname_tmp = $pth_ImgHost.$axptimT;
						//copy($pth_ImgHost.$axptimT,$xfname_tmp);									
						$imTest = @imagecreatefromjpeg($xfname_tmp);
						$xfname_min = $pth_ImgWeb_Thumb.$axptimJ;
						$xfname_hom = $pth_ImgWeb_Hompg.$axptimJ;
						$xfname_apl = $pth_ImgWeb_Ampli.$axptimJ;			
						if($imTest) {
							$xfname_tmp_orig = imagecreatefromjpeg($xfname_tmp);
							$pontoX = imagesx($xfname_tmp_orig);
							$pontoY = imagesy($xfname_tmp_orig);
							//*****************************
							$web_minWid = 220;
							$web_minHei = 220;
							$escala  = max($web_minWid/$pontoX, $web_minHei/$pontoY); 
							$Calc_minWid = floor($escala*$pontoX);
							$Calc_minHei = floor($escala*$pontoY);
							$xfname_tmp_fin = imagecreatetruecolor($web_minWid, $web_minHei);//$Calc_minWid, $Calc_minHei
							imagecopyresampled($xfname_tmp_fin, $xfname_tmp_orig, 0, 0, 0, 0, $web_minWid+1, $web_minHei+1, $pontoX, $pontoY);
							imagejpeg($xfname_tmp_fin, $xfname_min);
							imagedestroy($xfname_tmp_fin); 
							//*****************************
							$web_icoHom = 220;
							$web_icoHom = 220;
							$escala  = max($web_icoHom/$pontoX, $web_icoHom/$pontoY); 
							$Calc_homWid = floor($escala*$pontoX);
							$Calc_homHei = floor($escala*$pontoY);
							$xfname_tmp_fin = imagecreatetruecolor($web_icoHom, $web_icoHom);//$Calc_minWid, $Calc_minHei
							imagecopyresampled($xfname_tmp_fin, $xfname_tmp_orig, 0, 0, 0, 0, $web_icoHom+1, $web_icoHom+1, $pontoX, $pontoY);
							imagejpeg($xfname_tmp_fin, $xfname_hom);
							imagedestroy($xfname_tmp_fin);								
							//*****************************
							$escala  = min($web_ampWid/$pontoX, $web_ampHei/$pontoY); 
							$Calc_ampWid = floor($escala*$pontoX);
							$Calc_ampHei = floor($escala*$pontoY);
							$xfname_tmp_fin = imagecreatetruecolor($Calc_ampWid, $Calc_ampHei);
							imagecopyresampled($xfname_tmp_fin, $xfname_tmp_orig, 0, 0, 0, 0, $Calc_ampWid+1, $Calc_ampHei+1, $pontoX, $pontoY);
							imagejpeg($xfname_tmp_fin, $xfname_apl);
							imagedestroy($xfname_tmp_fin); 
							//****************************
							imagedestroy($xfname_tmp_orig);
							$geralink = true;
						}
					}
					$geralink = (file_exists($pth_ImgWeb_Thumb.$axptimJ));
					if ($geralink) {
						//$xtag_imgs.= '<li><a rel="fancybox-gal'.$prtID.'" href="'.$_File_Web.'" title="'.$axpttag.'"><img src="'.$_File_WebThumb.'" alt="'.$axpttag.'"></a></li>';
						$axpttag2 = str_replace(" - ", "<br>", $axpttag);
						/*$xtag_imgs.= '<div class="col-lg-2 col-md-2 col-sm-4 wthree2" data-aos="zoom-in"><div class="w3-agileits"><a href="#art'.$axwh.'" title="mais"><img src="'.$_File_WebThumb.'" alt="'.$axpttag.'"><br/>'.$axpttag.'</a></div></div>';
						$desc_imgs.= '<div id="art'.$axwh.'" class="modalDialog"><div><a class="close" title="Fechar" href="#close">X</a><div class="divcap"><img src="'.$_File_Web.'" alt="'.$axpttag.'"></div><div class="divtxt"><h2>'.$axpttag.'</h2><p>'.$axpttxt.'</p></div></div></div>';*/
						
						/*$axtagart = '<div class="row">';
						$axtagart.= '<div class="col-md-6"><div class="cap"><img src="'.$_File_Web.'" alt="'.$axpttag.'"></div></div>';
						$axtagart.= '<div class="col-md-6"><div id="jp_container"><h2>'.$axpttag.'</h2><p>'.$axpttxt.'</p></div></div>';
						$axtagart.= '</div>';*/
						
						$axtagart = '<div class="cap"><img src="'.$_File_Web.'" alt="'.$axpttag.'"></div>';
						$axtagart.= '<div id="jp_container"><h2>'.$axpttag.'</h2><p>'.$axpttxt.'</p></div>';
					}
				}
			}
			$xtag_imgs.= '</div>';
			//$tagContent.= $xtag_imgs;
			$tagContent_Imgs.= $xtag_imgs;
			$tagContent_Desc.= $desc_imgs;
		//}
	//}
	//$xtagTitle = utf8_encode($xtagTitle);
	//$axptButtonPrint =  utf8_encode($axptButtonPrint);
	/*$tagContent = utf8_encode($tagContent);
	$tagContent_Imgs = utf8_encode($tagContent_Imgs);
	$tagContent_Desc = '';*/
	//$tagContent_Desc = utf8_encode($tagContent_Desc);

	$axtagart = utf8_encode($axtagart);
	//$desc_imgs = utf8_encode($desc_imgs);
	print($axtagart);//

?>