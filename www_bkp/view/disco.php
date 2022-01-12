<div id="jquery_jplayer"></div>
<div id="iframe-dialogBox"></div>
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
	$setpgParse = explode('-', $xid);
	$setpgAlb = $setpgParse[0];
	$setpgCod = $setpgParse[1];
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
	$excod = mysql_query("SELECT cod_gal,descricao,loc".$xreg_txt." FROM m0_fky".$xidmdl50." WHERE cod_gal='".$setpgCod."' AND cod_web='".$web_cod."' AND cod_lng='".$web_lng."' AND cod_ls=-1".$xstatx." AND xtp='".$xcodtpSet."'");// desc
	$xtag = '';
	$desc_imgs = '';
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
			$axwh = $listasql[0];					
			$axtypeab = $listasql[2];
			$axpttxt = $listasql[3];
			$axpttxt = strip_tags($axpttxt, $web_feed_tags2);
			$axtext = '';
			$axtitle = $listasql[1];
			$axtitlelabel = "<h2>".str_replace(". ", "</h2><h3>", $axtitle)."</h3>";
			
			$excod2 = mysql_query("SELECT cod_img,descricao,ms_loc2,ms_loc3,textft FROM m0_fky".$xidmdl52." WHERE cod_gal='".$xcod_gal."' AND cod_lng='".$web_lng."' ORDER BY cod_img");
			$axpmusics = '';
			$axtagmucs = '';
			$axtagtrack = 'track track-default';
			$idmusic = 1;
			if ($excod2) { 
				while($listasql2 = mysql_fetch_array($excod2)) {
					//$axwh = $listasql[1];
					$axpmuscid = $listasql2[0];
					$axpmtitle = $listasql2[1];
					$axpmusmp3 = $listasql2[2];
					$axpmuscif = $listasql2[3];
					$axpmuslet = $listasql2[4];
					$axpmuslet = str_replace("\\r\\n", "<br>", $axpmuslet);
					$axpmuslet = str_replace("\r\n", "<br>", $axpmuslet);
					$axpmuslet = str_replace("\\n", "<br>", $axpmuslet);
					$axpmuslet = str_replace("\n", "<br>", $axpmuslet);
					$axpmuslet = trim($axpmuslet);
					$axndisp = utf8_decode('indisponível');
					if ($axtypeab == "cd") {
						if (empty($axpmusmp3)) $axpmusics.= '<img src="/images/player/play-off.png" alt="Audio '.$axndisp.'">';
						else {
							$axpmusics.= '<a href="/snd/mp3/'.$setpgAlb.'/'.$axpmusmp3.'.mp3" title="Reproduzir" class="'.$axtagtrack.'"><img src="/images/player/play.png" alt="Reproduzir"></a>';
							$axtagtrack = 'track';
						}
						if (empty($axpmuslet) || ($axpmuslet == utf8_decode('Letra não disponível<br>')) || ($axpmuslet == utf8_decode('Letra não disponível'))) $axpmusics.= '<img src="/images/player/letra-off.png" alt="Letra '.$axndisp.'">';
						else {
							$axpmusics.= '<a href="#msc'.$axpmuscid.'" title="Letra"><img src="/images/player/letra.png" alt="Letra"></a>';
							$desc_imgs.= '<div id="msc'.$axpmuscid.'" class="modalDialog2"><div><a class="close" title="Fechar" href="#close">X</a><div class="divtxt">'.$axtitlelabel.'<p>'.$axpmuslet.'</p></div></div></div>';
							//$axpmusics.= '<span class="ltr"><a rel="'.$axpmuscid.'" title="Letra" tit="'.$axpmtitle.'"><img src="/images/player/letra.png" alt="Letra"></a></span>';
						}
						if (empty($axpmuscif)) $axpmusics.= '<img src="/images/player/cifra-off.png" alt="Cifra '.$axndisp.'">';
						else $axpmusics.= '<a href="'.$axpmuscif.'" title="Cifra" target="_blank"><img src="/images/player/cifra.png" alt="Cifra"></a>';
						$axpmusics.= ' ';
						
					}
					$idmusictx = $idmusic;
					if ($idmusic<10) $idmusictx = '0'.$idmusictx;
					$axpmusics.= $idmusictx.'  . '.$axpmtitle.'<br>';		
					$idmusic++;			
				}
			}
			if (!empty($axpmusics)) $axpmusics = '<p>'.utf8_decode('Músicas').':<br>'.$axpmusics.'</p>';
			//$axtagmucs = '<div class="divcap"><img src="'.$_File_WebFlyer.'" alt="'.$axtitle.'"></div><div class="divtxt">'.$axtitlelabel.$axpmusics.'</div>';
			$axtagmucs = '<div class="row">';
			$axtagmucs.= '<div class="col-md-6"><div class="cap"><img src="'.$_File_WebFlyer.'" alt="'.$axtitle.'"></div></div>';
			$axtagmucs.= '<div class="col-md-6"><div id="jp_container">'.$axtitlelabel.$axpttxt.$axpmusics.'</div></div>';
			$axtagmucs.= '</div>';
		}
	}
	$axtagmucs = utf8_encode($axtagmucs);
	$desc_imgs = utf8_encode($desc_imgs);
	print($axtagmucs);
	print($desc_imgs);
?>
<script type="text/javascript">
//<![CDATA[

$(document).ready(function(){
	var	my_jPlayer = $("#jquery_jplayer"),
		rd_jPlayer = $("#jquery_jplayer_1"),
		my_trackName = $("#jp_container .track-name"),
		my_playState = $("#jp_container .play-state"),
		my_extraPlayInfo = $("#jp_container .extra-play-info");
	var	opt_play_first = false,
		opt_auto_play = true,
		opt_text_playing = "",
		opt_text_selected = "";
	var first_track = true;
	$.jPlayer.timeFormat.padMin = false;
	$.jPlayer.timeFormat.padSec = false;
	$.jPlayer.timeFormat.sepMin = "";
	$.jPlayer.timeFormat.sepSec = "";
	my_playState.text(opt_text_selected);
	var trackname = '';
	var tracknamelast = '';
	my_jPlayer.jPlayer({
		ready: function () {
			$("#jp_container .track-default").click();
		},
		ended: function() {
    		rd_jPlayer.jPlayer("play");
		},
		swfPath: "/js",
		cssSelectorAncestor: "#jp_container",
		supplied: "mp3",
		wmode: "window"
	});
	$("#jp_container .track").click(function(e) {
		my_jPlayer.jPlayer("setMedia", {
			mp3: $(this).attr("href")
		});
		if((opt_play_first && first_track) || (opt_auto_play && !first_track)) {
			if (tracknamelast != '') {
				tracknamelast.html('<img src="/images/player/play.png">');
			}
			if (trackname != $(this).attr("href")) {
				my_jPlayer.jPlayer("play");
				$(this).html('<img src="/images/player/pause.png">');
				trackname = $(this).attr("href");
				tracknamelast = $(this);
				//if(rd_jPlayer.jPlayer("getData","diag.isPlaying") == true){
					rd_jPlayer.jPlayer("pause");
				//}
			} else {
				my_jPlayer.jPlayer("stop");
				$(this).html('<img src="/images/player/play.png">');
				trackname = '';
				tracknamelast = '';
				rd_jPlayer.jPlayer("play");
			}			
		}
		first_track = false;
		$(this).blur();
		return false;
	});
	/*$(".ltr").delegate("a", "click", function(e) {
		e.preventDefault();
		hrel = $( this ).attr('rel');
		htitle = $( this ).attr('tit');
		$('#iframe-dialogBox').dialogBox({
			hasMask: true,
			hasClose: true,
			effect: 'flip-vertical',
			title: htitle,
			content: '/view/letra.php?id='+hrel
		});
	});*/	
});
//]]>
</script>