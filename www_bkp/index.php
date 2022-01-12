<?
	header('Content-Type: text/html; charset=UTF-8',true);

    if (! isset($_SERVER['HTTPS']) or $_SERVER['HTTPS'] == 'off' ) {
        $redirect_url = "https://" . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
        header("Location: $redirect_url");
        exit();
    }
	
	$titlesite = "João Luiz Corrêa e Grupo Campeirismo";
	$wwwsite = "joaoluizcorrea.com.br";
	$www_web = "www.".$wwwsite;
	$web_dom = $www_web;
	$www_mail = "webmaster@".$wwwsite;
	$web_http = "https://".$www_web."/";
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
	//****	
	$web_menu = array(8);
	$web_menu['cod'] = array(1,2,3,4,5,6,7,8,9,10,11,12);
	$web_menu['tit'] = array('Home','Biografia','Artistas','Disco','Agenda','Fotos','Vídeos','Imprensa','Notícias','Fãs','Loja','Contato');
	$web_menu['url'] = array('','biografia','artistas','disco','agenda','fotos','videos','imprensa','noticias','fas','loja','contato');
	$web_menu['alt'] = array('','biografia','artistas','disco','agenda','fotos','videos','imprensa','noticias','fas','loja','contato');
	$web_menu['txt'] = array('','biografia','artistas','disco','agenda','fotos','videos','imprensa','noticias','fas','loja','contato');
	$web_menu['tab'] = array('','200','84','83','50','50','200','200','87','','','');
	$web_menu['tip'] = array('','147','201','207','33','147','1060','155','8','','','');
	$web_menu['img'] = array(false,false,false,false,false,false,false,false,false,false,false,false);
	
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
	$galcnfg['qulity'] = array(70,70,60);
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
	
	session_start();
	$session = session_id();
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<title>João Luiz Corrêa e Grupo Campeirismo</title>
<link rel="icon" type="image/x-icon" href="favicon.ico" />
<link rel="icon" type="image/png" href="favicon.png" />
<link rel="icon" type="image/gif" href="favicon.gif" />
<!--mobile apps-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="description" content="João Luiz Corrêa é um músico e compositor gaúcho que junto com o Grupo Campeirismo leva a todo o Brasil as tradições e a música fandanga do Rio Grande do Sul">
<meta name="keywords" content="João Luiz Corrêa, Grupo Campeirismo, música, shows, bailes, fandango, tradicionalismo, tradições, Rio Grande do Sul" />
<meta property="og:locale" content="pt_BR">
<meta property="og:type" content="website">
<meta property="og:url" content="http://www.joaoluizcorrea.com.br">
<meta property="og:title" content="João Luiz Corrêa e Grupo Campeirismo">
<meta property="og:site_name" content="João Luiz Corrêa e Grupo Campeirismo">
<meta property="og:description" content="João Luiz Corrêa é um músico e compositor gaúcho que junto com o Grupo Campeirismo leva a todo o Brasil as tradições e a música fandanga do Rio Grande do Sul">
<meta property="og:image" content="http://www.joaoluizcorrea.com.br/jlc.png" />
<meta property="og:image:type" content="image/png">
<meta property="og:image:width" content="476">
<meta property="og:image:height" content="249">
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>
<!-- fonts -->
<link href="https://fonts.googleapis.com/css?family=Abel" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,700" rel="stylesheet">
<!-- /fonts -->
<!-- css -->
<link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/font-awesome.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/lightgallery.css" rel="stylesheet">
<link href="css/jquery.dop.ThumbnailScroller.css" rel="stylesheet" type="text/css" media="all" />
<link href='css/aos.css' rel='stylesheet prefetch' type="text/css" media="all" />
<link href="css/pogo-slider.css?v4" rel="stylesheet" type="text/css" media="all" />
<link href="css/style.css?v7" rel="stylesheet" type="text/css" media="all" />
<link rel="stylesheet" href="css/jquery.mCustomScrollbar.css">
<link href="css/owl.carousel.css" rel="stylesheet">
<link href="css/owl.theme.css" rel="stylesheet">
<link href="css/jquery.dialogbox.css" rel="stylesheet">
<link href="css/jplayer.css?v5" rel="stylesheet">

<!-- /css -->
</head>
<body>
<!-- navigation -->
<div id="jquery_jplayer_1" class="jp-jplayer"></div>
<div class="navbar-wrapper" id="home">
	<nav class="navbar navbar-inverse navbar-fixed-top">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
                <span class="logov"><img src="images/jlc-logo-mob.png" alt="João Luiz Corrêa"></span>
			</div>
			<div id="navbar" class="navbar-collapse collapse">
				<ul class="nav navbar-nav cl-effect-10">
					<li class="active"><a href="#home" class="page-scroll" data-hover="Home"><span><img src="images/jlc-ico.png"><br>Home</span></a></li>
					<li><a href="#biografia" class="page-scroll" data-hover="Biografia"><span><img src="images/jlc-ico.png"><br>Biografia</span></a></li>
                    <li><a href="#disco" class="page-scroll" data-hover="Disco"><span><img src="images/jlc-ico.png"><br>Disco</span></a></li>
					<li><a href="#agenda" class="page-scroll" data-hover="Agenda"><span><img src="images/jlc-ico.png"><br>Agenda</span></a></li>
                    <li><a href="#fotos" class="page-scroll" data-hover="Fotos"><span><img src="images/jlc-ico.png"><br>Fotos</span></a></li>
                    <li class="logoy"><img src="images/jlc-logo-web.png" alt="João Luiz Corrêa"></li>
					<li><a href="#videos" class="page-scroll" data-hover="Vídeos"><span><img src="images/jlc-ico.png"><br>Vídeos</span></a></li>
                    <li><a href="#imprensa" class="page-scroll" data-hover="Imprensa"><span><img src="images/jlc-ico.png"><br>Imprensa</span></a></li>
                    <li><a href="#central" class="page-scroll" data-hover="Fãs"><span><img src="images/jlc-ico.png"><br>Fãs</span></a></li>
                    <li><a href="http://loja.joaoluizcorrea.com.br" data-hover="Loja" target="_blank"><span><img src="images/jlc-ico.png"><br>Loja</span></a></li>
	 				<li><a href="#contato" class="page-scroll" data-hover="Contato"><span><img src="images/jlc-ico.png"><br>Contato</span></a></li>
				</ul>
                <div id="jp_container_1" class="jp-audio" role="application" aria-label="media player">
                    <div class="jp-type-single">
                        <div class="jp-gui jp-interface">
                            <div class="jp-controls">
                                <button class="jp-play" role="button" tabindex="0">play</button>
                            </div>
                        </div>
                    </div>
                </div>
			</div>
		</div>
    </nav>
</div>
<!-- /navigation -->
<!-- banner -->
<div class="pogoSlider" id="js-main-slider">
	<?
	$xtag = '';
	$pthban = '/images/banners/';
	if ($galcnfgID>0) $pthban.='smart/';
	for ($i = 1; $i <= 6; $i++) {
		$itx = '';
		//if ($i < 10) $itx = '0';
		$itx.= $i;
		$xtag.= '<div class="pogoSlider-slide" data-transition="fade" data-duration="6000" style="background-image:url('.$pthban.$itx.'.jpg?v10);"></div>';
	}
	print($xtag);
	?>
</div><!-- .pogoSlider -->	
<!-- /banner -->
<!-- biografia -->
<? 
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
	$excod = mysql_query("SELECT cod_gal,descricao FROM m0_fky".$xidmdl50." WHERE cod_web='".$web_cod."' AND cod_ls=-1 AND xtp='".$xcodtpSet."' ORDER BY ".$xdtx.$xidmdDescSQL.";");
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
			if (($xcodset == $axptLink)) {
				$xcod_gal = $listasql[0];
				//$axptButtonPrint.= '<li>'.$axpttag.'</li>';
				$xgalidSet = $xgaldadoscount;
			} else {
				//$axptButtonPrint.= '<li>'.$axptButton.'</li>';
			}
			$xgaldadoscount++;
		}
		/*$axptButtonAll = "";
		if ($xcod_gal > 0) {
			$axptButtonAll = $GrpF_SEObarD.'" alt="'.$titlesb.'">Todos</a>';
		} else {
			$axptButtonAll = 'Todos';
		}
		$axptButtonAll = '<li>'.$axptButtonAll.'</li>';*/
		//$axptButtonPrint = '<div id="navtitle"><ul>'.$axptButtonAll.$axptButtonPrint.'</ul></div><div class="clear"></div>';
		$viewalb = true;
	} else {
		$viewalb = false;	
	}
	if (!$viewalb) {
		$tagContent.= '<p><strong>Erro 404:</strong> A URL não foi localizada...<br><br><br></p>';
		$tagContent.= '<p><a href="/">Voltar</a></p>';
	} else {
		if ($xcod_gal <> 0) {
			$axptimN = strtoupper(md5("m0_fky".$xidmdl51."_icon_cod_gal_".$xcod_gal));
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
			$_File_WebIcons = $www_web_ImgIcons.$axptimJ;
			$_File_WebFlyer = $www_web_ImgFlyer.$axptimJ;
			$geralink = ((!file_exists($pth_ImgWeb_Icons.$axptimJ)) || (!file_exists($pth_ImgWeb_Flyer.$axptimJ)));
			if ($imgcopy && $geralink) {
				copy($pth_ImgHost.$axptimT,($pth_ImgWeb_Icons.$axptimJ));
				copy($pth_ImgHost.$axptimT,($pth_ImgWeb_Flyer.$axptimJ));
			} else if ((file_exists($pth_ImgHost.$axptimT)) && ($geralink)) {
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
			$geralink = (file_exists($pth_ImgWeb_Icons.$axptimJ));
			//******************************
			$xreg = '';
			$xreg_more = '';
			$xreg_sql = "' AND cod_gal='".$xcod_gal."'";
			$excod = mysql_query("SELECT cod_gal,descricao".$xreg_txt." FROM m0_fky".$xidmdl50." WHERE cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1".$xstatx." AND xtp='".$xcodtpSet.$xreg_sql);
			if ($excod) { 
				while($listasql = mysql_fetch_array($excod)) {
					$axwh = $listasql[0];
					$axpttag = $listasql[1];
					$axpttag = str_replace("\\r\\n", "", $axpttag);
					$axptLink = urlSEO($axpttag);
					$_File_WebFlyer = '';
					if ($banTop) {
						$axptimN = strtoupper(md5("m0_fky".$xidmdl51."_icon_cod_gal_".$axwh));
						$axptimJ = $axptimN.".jpg";
						$_File_WebFlyer = $www_web_ImgFlyer.$axptimJ;
						if (file_exists($pth_ImgWeb_Flyer.$axptimJ))
							$_File_WebFlyer = '<img src="'.$_File_WebFlyer.'" alt="'.utf8_encode($axpttag).'">';
						else $_File_WebFlyer='';
					}
					$axptTXT = $listasql[2];
					$axptTXT = str_replace("\\r\\n", "", $axptTXT);
					$axptTXT = str_replace($www_host_Img,$www_web_Img,$axptTXT);
					//$axptTXT = strip_tags($axptTXT, $web_feed_tags);
					$xtagTitle = $axpttag;
					$tagContent .= $axptTXT;
				}
			}
		}
		$printfancyboxEft = true;
		if ($xgalidSet <> -1) {
			$xgaldadoscount = 1;
			$printfancyboxEft = false;
		}
		for ($xgalid = 0; $xgalid < $xgaldadoscount; $xgalid++) {
			if ($printfancyboxEft) $galID = $xgalid;
			else $galID = $xgalidSet;
			$prtID = $galID+1;
			$xcod_gal = $xgaldados['cod'][$galID];
			$xtitle_gal = $xgaldados['title'][$galID];
			$xtag_imgs = '';
			$desc_imgs = '';
			$xtag_imgs.= '<div class="team-bottom" style="visibility: visible; animation-delay: 0.3s; animation-name: fadeInRight;">';
			$excod = mysql_query("SELECT cod_gal,cod_img,descricao,textft FROM m0_fky".$xidmdl52." WHERE cod_gal='".$xcod_gal."' AND cod_lng='".$web_lng."' ORDER BY cod_img".$xidmdDescSQL);
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
						//$xtag_imgs.= '<div class="col-lg-2 col-md-2 col-sm-4 wthree2" data-aos="zoom-in"><div class="w3-agileits"><a href="#art'.$axwh.'" title="mais"><img src="'.$_File_WebThumb.'" alt="'.$axpttag.'"><br/>'.$axpttag.'</a></div></div>';
						$xtag_imgs.= '<div class="col-lg-2 col-md-2 col-sm-4 wthree2" data-aos="zoom-in"><div class="w3-agileits"><div class="bgf"><a title="mais" rel="'.$axwh.'"><img src="'.$_File_WebThumb.'" alt="'.$axpttag.'"><br/>'.$axpttag.'</a></div></div></div>';
						$desc_imgs.= '<div id="art'.$axwh.'" class="modalDialog"><a class="close" title="Fechar" href="#close"><div id="modalOpen"><div class="divcap"><img src="'.$_File_Web.'" alt="'.$axpttag.'"></div><div class="divtxt"><h2>'.$axpttag.'</h2><p>'.$axpttxt.'</p></div></a></div></div>';
					}
				}
			}
			$xtag_imgs.= '</div>';
			//$tagContent.= $xtag_imgs;
			$tagContent_Imgs.= $xtag_imgs;
			$tagContent_Desc.= $desc_imgs;
		}
	}
	//$xtagTitle = utf8_encode($xtagTitle);
	//$axptButtonPrint =  utf8_encode($axptButtonPrint);
	$tagContent = utf8_encode($tagContent);
	$tagContent_Imgs = utf8_encode($tagContent_Imgs);
	$tagContent_Desc = '';
	//$tagContent_Desc = utf8_encode($tagContent_Desc);0
?>
<section class="biografia-w3ls" id="biografia">
	<div class="container-fluid">
		<h2>Biografia</h2>
        <div class="biografia_wrapper">
            <span class="controllers controller_up"></span>
            <div class="biografia_text">
                <div class="text_holder">
                <? print($tagContent); ?>
                </div>
            </div>
            <span class="controllers controller_down"></span>
        </div>
		<!-- artistas -->
        <? print($tagContent_Imgs); ?>
        <div class="clearfix"></div>
	</div>
    <div id="biografiainfo"></div>
</section>
<? //print($tagContent_Desc); ?>
<!-- /biografia -->
<!-- disco -->
<section class="disco-agileinfo" id="disco">
	<div class="container">
		<h3 class="text-center">Discografia</h3>
		<div id="owl-div2" class="owl-carousel">
        <?
	$xidmdl50 = "830";
	$xidmdl51 = "831";
	$xidmdl52 = "832";
	$xidmdl53 = "833";
	$xcodtpSet = "207";
	$xreg_txt = "";//",textft";
	$xstatx = '';//' AND xstat=1';
	$excod = mysql_query("SELECT cod_gal,descricao".$xreg_txt." FROM m0_fky".$xidmdl50." WHERE cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1".$xstatx." AND xtp='".$xcodtpSet."' ORDER BY cod_gal");// desc
	$xtag = '';
	$desc_imgs = '';
	$albid = 1;
	if ($excod) { 
		while($listasql = mysql_fetch_array($excod)) {
			/* aqui */
			$xcod_gal = $listasql[0];
			$axptimN = strtoupper(md5("m0_fky".$xidmdl51."_icon_cod_gal_".$xcod_gal));
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
			$_File_WebIcons = $www_web_ImgIcons.$axptimJ;
			$_File_WebFlyer = $www_web_ImgFlyer.$axptimJ;
			$geralink = ((!file_exists($pth_ImgWeb_Icons.$axptimJ)) || (!file_exists($pth_ImgWeb_Flyer.$axptimJ)));
			if ($imgcopy && $geralink) {
				copy($pth_ImgHost.$axptimT,($pth_ImgWeb_Icons.$axptimJ));
				copy($pth_ImgHost.$axptimT,($pth_ImgWeb_Flyer.$axptimJ));
			} else if ((file_exists($pth_ImgHost.$axptimT)) && ($geralink)) {
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
			$geralink = (file_exists($pth_ImgWeb_Icons.$axptimJ));			
			/* aqui */			
			$xtag .= '<div class="item wthree1" data-aos="zoom-in"><div class="w3-agileits">';
			$axwh = $listasql[0];					
			/*$axpttxt = $listasql[2];
			$axpttxt = strip_tags($axpttxt, $web_feed_tags2);*/
			$axtext = '';
			$axtitle = $listasql[1];
			$axtitlelabel = "<h2>".str_replace(". ", "</h2><h3>", $axtitle)."</h3>";
			$axtext.= '<div class="dsc"><a title="'.utf8_decode('MAIS').'" rel="'.$albid.'-'.$axwh.'"><img class="img-responsive" src="'.$_File_WebIcons.'" alt="'.$axtitle.'"></a>'.$axtitlelabel.'</div>';
			$xtag .= $axtext.'</div></div>';
			$albid++;
		}
	}
	$xtag = utf8_encode($xtag);
	print($xtag);
?> 
        </div>
		<div class="clearfix"></div>
	</div>
    <div id="discoinfo"></div>
</section>
<!-- /disco -->
<!-- agenda -->
<section class="agenda-agileinfo" id="agenda">
	<div class="container">
		<h3 class="text-center">Agenda</h3>
		<div id="owl-div" class="owl-carousel">
        <?
	$xdtang = date("Ymd")." ".date("00:00:00");//,textft
	$excod = mysql_query("SELECT codigo,xdt,loc,cid,uf,descricao FROM m0_fky750 WHERE cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1 AND xtp='33' AND xstat=1 AND xdt>='".$xdtang."' ORDER BY xdt,codigo");
	$xtag = '';
	$desc_imgs = '';
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
			/*$axpttxt = $listasql[6];//agenda
			$axpttxt = strip_tags($axpttxt, $web_feed_tags2);
			$axpttxt = str_replace("\\r\\n", "<br>", $axpttxt);
			$axpttxt = str_replace("\r\n", "<br>", $axpttxt);
			$axpttxt = str_replace("\\n", "<br>", $axpttxt);
			$axpttxt = str_replace("\n", "<br>", $axpttxt);*/
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
			//$desc_imgs.= '<div id="info'.$axwh.'" class="modalDialog"><div><a class="close" title="Fechar" href="#close">X</a><div class="divcap"><img src="images/agenda-info.png" alt="Agenda"></div><div class="divtxt"><h2>'.$axtitle.'</h2><p>'.$axpttxt.'</p></div></div></div>';
			//$axtext .= $xcptxt;// <h3>'.$xcpcid.'</h3>
			//$sURL = urlencode('http' . ($_SERVER['SERVER_PORT'] == 443 ? 's' : '') . '://' . $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF']);			
			$axtext .= '<div class="rodape">';
			$axtext.= '<div class="infosh"><div class="agl"><a title="'.utf8_decode('Informações').' sobre o Evento" rel="'.$axwh.'"><img src="/images/social/maisinfo.png"></a></div>';
			//$axtext .= '<div class="infosh"><a href="#info'.$axwh.'" title="'.utf8_decode('Informações').' sobre o Evento"><img src="/images/social/maisinfo.png"></a>';
			if ($axingr != '') $axtext .= '<a href="'.$axingr.'" title="Comprar Ingresso" target="_blank"><img src="/images/social/compreingresso.png"></a>';
			$axtext .= '</div>';
			$axtext .= '<div class="socialsh">Compartilhar:<br/><a href="http://www.facebook.com/sharer.php?u='.urlencode($web_http).'&t='.utf8_encode($titlesite).'" title="Compartilhar no Facebook" target="_new"><img src="/images/social/fb-ico.png"></a>';
			$axtext .= '<a href="http://twitter.com/share?text='.utf8_encode($web_tit).'&url='.utf8_encode($web_http).'" title="Compartilhar no Twitter" target="_new"><img src="/images/social/tw-ico.png"></a>';
			$axtext .= '<a href="https://plus.google.com/share?url='.utf8_encode($web_http).'" title="Compartilhar no Google" target="_new"><img src="/images/social/gg-ico.png"></a></div>';
			$axtext .= '</div>';
			$xtag .= $axtext.'</div></div>';
		}
	}
	/*if ($xtag == '') { 
		$xtag = "<li>Nenhuma data cadastrada...</li>";
	}
	$xtag .= '</ul>';*/
	$xtag = utf8_encode($xtag);
	//$desc_imgs = utf8_encode($desc_imgs);
	print($xtag);
?> 
        </div>
		<div class="clearfix"></div>
	</div>
    <div id="agendainfo"></div>
</section>
<? //print($desc_imgs); ?>
<!-- /agenda -->
<!-- fotos -->
<section class="fotos-w3ls" id="fotos">
	<div class="container">
		<h3 class="text-center">Fotos</h3>
		<div class="content">
			<?
	$xidmdl50 = "50";
	$xidmdl51 = "51";
	$xidmdl52 = "52";
	$xidmdl53 = "53";
	$xcodtpSet = "147";
	$xidmdDescSQL = "";//" desc"
	$GrpF_Vsb = true;
	$banTop = false;
	$xreg_txt = ",textft";
	//ini
	$xtagTitle = '';
	$tagContent = '';
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
	$excod = mysql_query("SELECT cod_gal,descricao FROM m0_fky".$xidmdl50." WHERE cod_web='".$web_cod."' AND cod_ls=-1 AND xtp='".$xcodtpSet."' ORDER BY cod_gal desc LIMIT 16;");//".$xdtx.$xidmdDescSQL."." order by "
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
			if (($xcodset1 == $axptLink)) {
				$xcod_gal = $listasql[0];
				$axptButtonPrint.= '<li>'.$axpttag.'</li>';
				$xgalidSet = $xgaldadoscount;
			} else {
				$axptButtonPrint.= '<li>'.$axptButton.'</li>';
			}
			$xgaldadoscount++;
		}
		$viewalb = true;
	} else {
		$viewalb = false;	
	}
	if (!$viewalb) {
		$tagContent.= '<p><strong>Erro 404:</strong> A URL não foi localizada...<br><br><br></p>';
		$tagContent.= '<p><a class="btvoltar" href="/">Voltar</a></p>';
	} else {
		if ($xcod_gal <> 0) {
			$axptimN = strtoupper(md5("m0_fky".$xidmdl51."_icon_cod_gal_".$xcod_gal));
			$axptimT = $axptimN.".hws";
			$axptimJ = $axptimN.".jpg";
			$_File_WebIcons = $www_web_ImgIcons.$axptimJ;
			$_File_WebFlyer = $www_web_ImgFlyer.$axptimJ;
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
			$geralink = (file_exists($pth_ImgWeb_Icons.$axptimJ));
			//******************************
			$xreg = '';
			$xreg_more = '';
			$xreg_sql = "' AND cod_gal='".$xcod_gal."'";
			$excod = mysql_query("SELECT cod_gal,descricao".$xreg_txt." FROM m0_fky".$xidmdl50." WHERE cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1".$xstatx." AND xtp='".$xcodtpSet.$xreg_sql);
			if ($excod) { 
				while($listasql = mysql_fetch_array($excod)) {
					$axwh = $listasql[0];
					$axpttag = $listasql[1];
					$axpttag = str_replace("\\r\\n", "", $axpttag);
					$axptLink = urlSEO($axpttag);
					$_File_WebFlyer = '';
					if ($banTop) {
						$axptimN = strtoupper(md5("m0_fky".$xidmdl51."_icon_cod_gal_".$axwh));
						$axptimJ = $axptimN.".jpg";
						$_File_WebFlyer = $www_web_ImgFlyer.$axptimJ;
						if (file_exists($pth_ImgWeb_Flyer.$axptimJ))
							$_File_WebFlyer = '<img src="'.$_File_WebFlyer.'" alt="'.utf8_encode($axpttag).'">';
						else $_File_WebFlyer='';
					}
					$axptTXT = $listasql[2];
					$axptTXT = str_replace("\\r\\n", "", $axptTXT);
					$axptTXT = str_replace($www_host_Img,$www_web_Img,$axptTXT);
					$axptTXT = strip_tags($axptTXT, $web_feed_tags);
					$xtagTitle = $axpttag;
					$tagContent .= $axptTXT;
				}
			}
		}
		$printfancybox = '';
		$printfancyboxEft = true;
		if ($xgalidSet <> -1) {
			$xgaldadoscount = 1;
			$printfancyboxEft = false;
		}
		$photosp = true;
		$xtag_caross = true;
		$conteudo = "";
		$idxDir = 1;
		for ($xgalid = 0; $xgalid < $xgaldadoscount; $xgalid++) {
			$photosp = true;
			if ($printfancyboxEft) $galID = $xgalid;
			else $galID = $xgalidSet;
			$prtID = $galID+1;
			$xcod_gal = $xgaldados['cod'][$galID];
			$xtitle_gal = $xgaldados['title'][$galID];
			$xtitle_gal = addslashes($xtitle_gal);
			//$tagContent.= '<p>'.$xcod_gal.'</p>';
			$idxDirPath = "E:/www/joaoluizcorrea.com.br/files/".date("Ymd").str_pad($idxDir, 6, "0", STR_PAD_LEFT);
			$conteudo .= str_pad($idxDir, 6, "0", STR_PAD_LEFT).PHP_EOL;
			$conteudo .= $xtitle_gal.PHP_EOL;
			if (!is_dir($idxDirPath)) {
				mkdir($idxDirPath);
			}
			$idxDir++;
			$xtag_imgs = '';
			$rowcods = 0;
			$capaload = true;
			$excod = mysql_query("SELECT COUNT(*) FROM m0_fky".$xidmdl52." WHERE cod_gal='".$xcod_gal."' AND cod_lng='".$web_lng."' ORDER BY cod_img".$xidmdDescSQL);
			if ($excod) {
				while($listasql = mysql_fetch_array($excod)) {
					$rowcods=$listasql[0];
				}
			}
			if ($rowcods>0) {
			  $excod = mysql_query("SELECT cod_gal,cod_img,descricao FROM m0_fky".$xidmdl52." WHERE cod_gal='".$xcod_gal."' AND cod_lng='".$web_lng."' ORDER BY cod_img".$xidmdDescSQL);
			  if ($excod) { 
				$printfancybox.= "$('#galview".$prtID."').lightGallery({thumbnail:true,hash:false});";//{subHtmlSelectorRelative:true}
				
				$xtag_imgs.= '<div class="galeria col-xs-6 col-sm-4 col-md-3"><ul id="galview'.$prtID.'" class="list-unstyled row">';
				//**				
				$_File_Web = "";
				$_File_WebThumb = "";
				$imgID = 1;
				$idxImgDir = 1;
				while($listasql = mysql_fetch_array($excod)) {
					$axwh = $listasql[1];
					$axpttag = $listasql[2];
					$axpttag = str_replace("\\r\\n", "", $axpttag);
					$axptimN = strtoupper(md5("m0_fky".$xidmdl53."_img_larg_cod_img_".$axwh));
					$axptimT = $axptimN.".hws";
					$axptimJ = $axptimN.".jpg";
					$_File_Web = $www_web_ImgAmpli.$axptimJ;
					$_File_WebThumb = $www_web_ImgThumb.$axptimJ;
					$idxImgDirPath = $idxDirPath."/".str_pad($idxImgDir, 5, "0", STR_PAD_LEFT).".jpg";
					if (file_exists($pth_ImgHost.$axptimT)) {
						copy($pth_ImgHost.$axptimT,$idxImgDirPath);
					}
					$idxImgDir++;
					$geralink = ((!file_exists($pth_ImgWeb_Ampli.$axptimJ)) || (!file_exists($pth_ImgWeb_Thumb.$axptimJ)) || (!file_exists($pth_ImgWeb_Hompg.$axptimJ)));
					if ((file_exists($pth_ImgHost.$axptimT)) && ($geralink)) {
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
							$escala  = max($web_minWid/$pontoX, $web_minHei/$pontoY); 
							$Calc_minWid = floor($escala*$pontoX);
							$Calc_minHei = floor($escala*$pontoY);
							$xfname_tmp_fin = imagecreatetruecolor($web_minWid, $web_minHei);//$Calc_minWid, $Calc_minHei
							imagecopyresampled($xfname_tmp_fin, $xfname_tmp_orig, 0, 0, 0, 0, $Calc_minWid+1, $Calc_minHei+1, $pontoX, $pontoY);
							imagejpeg($xfname_tmp_fin, $xfname_min);
							imagedestroy($xfname_tmp_fin); 
							//*****************************
							$escala  = max($web_icoHom/$pontoX, $web_icoHom/$pontoY); 
							$Calc_homWid = floor($escala*$pontoX);
							$Calc_homHei = floor($escala*$pontoY);
							$xfname_tmp_fin = imagecreatetruecolor($web_icoHom, $web_icoHom);//$Calc_minWid, $Calc_minHei
							imagecopyresampled($xfname_tmp_fin, $xfname_tmp_orig, 0, 0, 0, 0, $Calc_homWid+1, $Calc_homHei+1, $pontoX, $pontoY);
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
						$xtag_imgs.= '<li class="';
						if ($photosp) {
							$photosp = false;
						} else {
							$xtag_imgs.= ' hide';
						}
						$xtag_imgs.= '" data-responsive="'.$_File_Web.' 375, '.$_File_Web.' 480, '.$_File_Web.' 800" data-src="'.$_File_Web.'" data-sub-html="'.$xtitle_gal.'"><a href=""><img class="img-responsive" src="'.$_File_WebThumb.'">';
						$xtag_imgs.= '<div class="gallery-poster"><img src="/images/zoom.png"></div>';
						$xtitlecap_gal = str_replace(" - ", "<br>", $xtitle_gal);
						$xtag_imgs.= '<div class="gallery-label">'.$xtitlecap_gal.'</div>';
						$xtag_imgs.= '</a></li>';
						/*if ($capaload) {
							$capaload = false;
							$xtag_imgs.= '<img src="'.$_File_WebThumb.'" alt="'.$axpttag.'">';
						}
						$xtag_imgs.= '</a></li>'; //$axpttag .PHP_EOL
						*/
						//<div class="caption">'.$xtitle_gal.'</div>
						//$xtag_imgs .= '<li><a href="'.$_File_Web.'" title="'.$axpttag.'" rel="external"><img src="'.$_File_WebThumb.'" alt="'.$axpttag.'"></a></li>';//data-ajax="false"
						$imgID++;
					}
				}
				$xtag_imgs.= '</ul></div>';
				$tagContent.= $xtag_imgs;
			  }
			}			
		}
		
		$fp = fopen("E:/www/joaoluizcorrea.com.br/files/albums.txt","wb");
		fwrite($fp,$conteudo);
		fclose($fp);
	}
	//$xtagTitle = utf8_encode($xtagTitle);
	$axptButtonPrint =  ''; //utf8_encode($axptButtonPrint);
	$tagContent = utf8_encode($tagContent);
	$printfancybox = utf8_encode($printfancybox);
?>
<? print($tagContent); ?>	
		</div>
	</div>
</section>
<!-- /fotos -->
<!-- videos -->
<section class="videos-w3ls" id="videos">
	<div class="container">
		<h3 class="text-center">Vídeos</h3>
		<div class="content galeria">
<?
	$xcodtpSet = "1060";
	$xidmdl50 = "1060";
	$xidmdl51 = "1061";
	$xidmdl52 = "1062";
	$xidmdl53 = "1063";
	$printfancybox2 = '';
	///$tagContent = '<div class="col-md-offset-1 col-md-10"><div class="row">';
	$tagContent= '<ul id="vidview" class="list-unstyled row">';//<div class="galeria">  class="galeria"
	$printfancybox2.= "$('#vidview').lightGallery({download:true,zoom:false,autoplayControls:false,hash:false,youtubePlayerParams:{modestbranding:1,showinfo:0,rel:0,controls:0}});";//{subHtmlSelectorRelative:true}
	$xtag_imgs = '';
	$excod = mysql_query("SELECT cod_gal FROM m0_fky".$xidmdl50." WHERE cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1".$xstatx." AND xtp='".$xcodtpSet."' ORDER BY cod_gal"); 
	//.$xreg_sql
	if ($excod) { 
		while($listasql = mysql_fetch_array($excod)) {
			if ($axfilterGalPub != '') $axfilterGalPub = $axfilterGalPub.' OR ';
			$axfilterGalPub.= 'cod_gal='.$listasql[0];
		}
	}
	$prtID = 1;
	if ($axfilterGalPub != '') {
		//$tagContent.= '<div class="col-md-offset-1 col-md-10"><div class="row">';
		$excod = mysql_query("SELECT cod_img,cod_gal,descricao,url,textft FROM m0_fky".$xidmdl52." WHERE ".$axfilterGalPub." AND cod_lng='".$web_lng."' ORDER BY cod_img desc LIMIT 8"); 
		//.$xreg_sql
		if ($excod) { 
			while($listasql = mysql_fetch_array($excod)) {
				$axpttag = $listasql[2];
				$axpttag = str_replace("\\r\\n", "", $axpttag);
				$axpturl = $listasql[3];
				
				$xtag_imgs.= '<li class="col-xs-6 col-sm-4 col-md-3" data-src="https://www.youtube.com/watch?v='.utf8_encode($axpturl).'" data-sub-html="'.$axpttag.'"><a href=""><img class="img-responsive" src="http://i2.ytimg.com/vi/'.utf8_encode($axpturl).'/mqdefault.jpg">';
				$xtag_imgs.= '<div class="gallery-poster"><img src="/images/play.png"></div>';
				$xtag_imgs.= '<div class="gallery-label">'.$axpttag.'</div>';
				$xtag_imgs.= '</a></li>';
				//$printfancybox2.= "$('#galview2".$prtID."').lightGallery({youtubePlayerParams:{modestbranding:1,showinfo:0,rel:0,controls:0}});";//{subHtmlSelectorRelative:true}
				//,vimeoPlayerParams:{byline:0,portrait:0,color:'A90707'}
				//$xtag_imgs= '<div class="galeria col-xs-6 col-sm-4 col-md-3" id="galview2'.$prtID.'">';
				//$xtag_imgs.= '<a href="https://www.youtube.com/watch?v='.utf8_encode($axpturl).'" data-poster="http://i2.ytimg.com/vi/'.utf8_encode($axpturl).'/mqdefault.jpg" ><img src="http://i2.ytimg.com/vi/'.utf8_encode($axpturl).'/mqdefault.jpg" /></a>';
				//$xtag_imgs.= '</div>';
				$prtID++;
			}
		}
	}
	$tagContent.= $xtag_imgs;
	$tagContent.= '</ul>';//
	//$tagContent.= '</div></div>';
	$tagContent = utf8_encode($tagContent);
	$printfancybox2 = utf8_encode($printfancybox2);
	//<div class="clearfix"></div>		
?>
<? print($tagContent); ?>
        </div>
	</div>
</section>
<!-- /videos -->
<!-- imprensa -->
<section class="imprensa-w3ls" id="imprensa">
	<div class="container">
		<h2>Imprensa</h2>
        <div class="col-lg-6 col-md-6 col-sm-6 imprensa-w3-agile1" data-aos="flip-right">
			<div class="imprensa-news">
                <h4>Novidades</h4>
			<?
	$xidmdl50 = "870";
	$xidmdl51 = "871";
	$xidmdl52 = "872";
	$xidmdl53 = "873";
	$xcodtpSet = "8";
	$xreg_txt = ",textft";
	$xstatx = '';//' AND xstat=1';
	$excod = mysql_query("SELECT cod_gal,descricao,xdt,loc".$xreg_txt." FROM m0_fky".$xidmdl50." WHERE cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1".$xstatx." AND xtp='".$xcodtpSet."' ORDER BY cod_gal desc LIMIT 3");// desc
	$xtag = '';
	$desc_imgs = '';
	$albid = 1;
	if ($excod) { 
		while($listasql = mysql_fetch_array($excod)) {
			/* aqui */
			$xcod_gal = $listasql[0];
			$axcp18 = $listasql[2];
			$xaxdt = substr($axcp18,8,2).'/'.substr($axcp18,5,2).'/'.substr($axcp18,0,4);/*.' '.substr($axcp18,11,2).':'.substr($axcp18,14,2)*/
			$axptimN = strtoupper(md5("m0_fky".$xidmdl51."_icon_cod_gal_".$xcod_gal));
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
			$_File_WebIcons = $www_web_ImgIcons.$axptimJ;
			$_File_WebFlyer = $www_web_ImgFlyer.$axptimJ;
			$geralink = ((!file_exists($pth_ImgWeb_Icons.$axptimJ)) || (!file_exists($pth_ImgWeb_Flyer.$axptimJ)));
			if ($imgcopy && $geralink) {
				copy($pth_ImgHost.$axptimT,($pth_ImgWeb_Icons.$axptimJ));
				copy($pth_ImgHost.$axptimT,($pth_ImgWeb_Flyer.$axptimJ));
			} else if ((file_exists($pth_ImgHost.$axptimT)) && ($geralink)) {
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
			$geralink = (file_exists($pth_ImgWeb_Icons.$axptimJ));			
			/* aqui */			
			$xtag .= '<div class="imprensa-item">';
			$axwh = $listasql[0];					
			$axpttxt = $listasql[4];
			$axpttxt = strip_tags($axpttxt, $web_feed_tags2);
			$axtext = '';
			$axtitle = $listasql[1];
			$axtitlelabel = "<h2>".$axtitle."</h2><h3>".$xaxdt."</h3>";
			//$axtext.= '<div class="divcap"><img class="img-responsive" src="'.$_File_WebIcons.'" alt="'.$axtitle.'"></div><div class="divtxt">'.$xaxdt.': '.$axtitle.'<br><a title="'.utf8_decode('Saiba mais...').'" rel="'.$albid.'-'.$axwh.'"><img src="/images/social/saiba-mais.png"></a></div>';
			$axtext.= '<div class="divcap"><img class="img-responsive" src="'.$_File_WebIcons.'" alt="'.$axtitle.'"></div><div class="divtxt">'.$xaxdt.': '.$axtitle.'<br><a href="#alb'.$axwh.'" title="'.utf8_decode('Saiba Mais...').'" rel="'.$albid.'-'.$axwh.'"><img src="/images/social/saiba-mais.png"></a></div>';
			$xtag .= $axtext.'</div>';
			$desc_imgs.= '<div id="alb'.$axwh.'" class="modalDialog2"><div><a class="close" title="Fechar" href="#close">X</a><div class="divcap"><img src="'.$_File_WebFlyer.'" alt="'.$axtitle.'"></div><div class="divtxt">'.$axtitlelabel.$axpttxt.'</div></div></div>';//$axpttxt
			$albid++;
		}
	}
	$xtag = utf8_encode($xtag);
	$desc_imgs = utf8_encode($desc_imgs);
	print($xtag);
?>
			</div>
		</div>
		<div class="col-lg-6 col-md-6 col-sm-6 imprensa-w3-agile2" data-aos="flip-left">
            <div id="imprensa-restrict">
   			<? 
			$acesso_imp = true;
			if((empty($_SESSION['senha'])) || (!$_SESSION['senha'])) {
				$acesso_imp = false;
			} else {
			  if ($_SESSION['senha'] != md5("jlc2017")) {
				$acesso_imp = false;
			  }
			}
			if ($acesso_imp) include_once($pth_web.'view/imp-data.php');
			else include_once($pth_web.'view/imp-form.php');
			?>
            </div>
        </div>
        <div class="clearfix"></div>
	</div>
</section>
<? print($desc_imgs); ?>
<!-- /imprensa -->
<!-- central -->
<section class="central-w3ls" id="central">
	<div class="container">
		<h2>Central de Fãs</h2>
        <div id="fbsts"></div>
		<div id="fbini"><fb:login-button size="xlarge" scope="public_profile,email" onlogin="checkLoginState();">Acessar com Facebook</fb:login-button></div>
        <? /*<div id="fbwrp"></div>*/ ?>
        <div class="col-lg-6 col-md-6 col-sm-6 central-w3-agile1" data-aos="flip-right">
			<div class="central-down">
               	<h4>Downloads</h4>
                <div id="fbdwn"></div>
            </div>
        </div>
		<div class="col-lg-6 col-md-6 col-sm-6 central-w3-agile2" data-aos="flip-left">
            <div class="central-agileits">
            	<div id="mural-form">
                	<? include_once($pth_web.'view/mural-form.php'); ?>
                </div>
                <div id="central-mural">
		   			<? include_once($pth_web.'view/mural.php'); ?>
        		</div>
                <div id="fbrec"><a title="Envie seu Recado"><img src="/images/social/envie-seu-recado.png" /></a></div>
                <div id="fbcls"><a title="Fechar"><img src="/images/social/close.png" /></a></div>
            </div>
        </div>        
        <div class="clearfix"></div>
	</div>
    <ul class="social-icons2">
        <li><a href="https://pt-br.facebook.com/joaoluizcorreaegrupocampeirismo" target="_blank"><i class="fa fa-facebook"></i></a></li>
        <? /*<li><a href="https://twitter.com/joaolcorrea" target="_blank"><i class="fa fa-twitter"></i></a></li>*/ ?>
        <li><a href="https://www.instagram.com/jlccorrea" target="_blank"><i class="fa fa-instagram"></i></a></li>
        <li><a href="https://www.youtube.com/channel/UCbDaA750q0NCXdaQlptSa9A" target="_blank"><i class="fa fa-youtube"></i></a></li>
        <li><a href="https://plus.google.com/105938558559659178162" target="_blank"><i class="fa fa-google-plus"></i></a></li>
    </ul>
</section>
<!-- /central -->
<!-- contato -->
<section class="contato-w3ls" id="contato">
	<div class="container">
		<div class="col-lg-6 col-md-6 col-sm-6 contato-w3-agile1" data-aos="flip-right">
			<h3>Atendimento</h3>
			<p class="contato-agile1">Contato geral:<br />(51) <strong>3109.7527</strong><br />(51) <strong>99993.9463</strong><br />(51) <strong>98325.0000</strong></p>
            <p class="contato-agile3">atendimento@joaoluizcorrea.com.br</p>
			<p class="contato-agile1">Contato comercial:<br />(47) <strong>99953-0846</strong><br />(54) <strong>99901-0081 </strong></p>
            <p class="contato-agile3">shows@joaoluizcorrea.com.br</p>
		</div>
		<div class="col-lg-6 col-md-6 col-sm-6 contato-w3-agile2" data-aos="flip-left">
			<div class="contato-agileits">
				<h4>Fale conosco</h4>
				<p class="contato-agile2">Preencha os dados</p>
				<form action="#" method="post" name="sentMessage" id="contatoForm" novalidate>
					<div class="control-group form-group">
                        <div class="controls">
                            <label class="contato-p1">Nome:</label>
                            <input type="text" class="form-control" name="name" id="name" required data-validation-required-message="Digite seu nome.">
                            <p class="help-block"></p>
                        </div>
                    </div>	
                    <div class="control-group form-group">
                        <div class="controls">
                            <label class="contato-p1">Fone:</label>
                            <input type="tel" class="form-control" name="phone" id="phone" required data-validation-required-message="Digite seu fone.">
							<p class="help-block"></p>
						</div>
                    </div>
                    <div class="control-group form-group">
                        <div class="controls">
                            <label class="contato-p1">Email:</label>
                            <input type="email" class="form-control" name="email" id="email" required data-validation-required-message="Digite seu e-mail.">
							<p class="help-block"></p>
						</div>
                    </div>
                    <div class="control-group form-group">
                        <div class="controls">
                            <label class="contato-p1">Mensagem:</label>
                            <textarea type="textarea" class="form-control" name="message" id="message" required data-validation-required-message="Digite sua mensagem."></textarea>
							<p class="help-block"></p>
						</div>
                    </div>
                    <div id="success"></div>
                    <!-- For success/fail messages -->
                    <button type="submit" class="btn btn-primary">Enviar</button>	
				</form>            
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</section>
<!-- /contato -->
<!-- footer -->
<div class="footer">
	<div class="container">
		<p class="text-center">©<? print(date("Y")); ?>. Todos os direitos reservados | By <a href="https://taxonvirtual.com.br/" target="_blank">Táxon Marketing e Tecnologia</a><br/><?
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
?></p>
	</div>
</div>
<!-- /footer -->
<!-- back to top -->
<a href="#0" class="cd-top">Top</a>
<!-- /back to top -->
<script src="js/jquery.min.js"></script>
<script src="js/owl.carousel.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/smoothscroll.js"></script>
<script src="js/jquery.easing.min.js"></script>
<script src="js/grayscale.js"></script>
<script src="js/jqBootstrapValidation.js"></script>
<script src="js/top.js"></script>
<script>$(document).ready(function(){<? print($printfancybox.$printfancybox2); ?>});</script>
<script src="js/picturefill.min.js"></script>
<script src="js/lightgallery.js"></script>
<script src="js/lg-fullscreen.js"></script>
<script src="js/lg-thumbnail.js"></script>
<script src="js/lg-video.js"></script>
<script src="js/lg-autoplay.js"></script>
<script src="js/lg-zoom.js"></script>
<script src="js/lg-hash.js"></script>
<script src="js/lg-pager.js"></script>
<script src="js/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="js/jquery.jplayer.js?v9"></script>
<script src="js/jquery.pogo-slider.min.js"></script>
<script src="js/jquery.dialogBox.js"></script>
<script src="js/main.js?v5"></script>
<script src="js/aos.js"></script>
<script src="js/index.js"></script>
<script src="js/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript">
//<![CDATA[
$(document).ready(function(){
	$("#jquery_jplayer_1").jPlayer({
		ready: function (event) {
			$(this).jPlayer("setMedia", {
				title: "João Luiz Corrêa",
				mp3: "http://centova2.ciclanohost.com.br:10005/stream",
				m4a: "http://centova2.ciclanohost.com.br:10005/stream",
				oga: "http://centova2.ciclanohost.com.br:10005/stream"
			}).jPlayer("play");
		},
		play: function() {
    		$(this).jPlayer("pauseOthers", 0);
  		},
		swfPath: "js",
		supplied: "mp3, m4a, oga",
		wmode: "window",
		useStateClassSkin: true,
		autoBlur: false,
		keyEnabled: false
	});
});
//]]>
</script>
<? /*<script src="js/application.js"></script> */ ?>
<? /*****************<script src="js/prettify.js"></script>*********/ ?>
</body>
</html>