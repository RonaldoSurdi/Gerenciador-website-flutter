<?
function getIPAddress() { 
	if (preg_match('/^(\d{1,3}\.){3}\d{1,3}$/s', $_SERVER["HTTP_CLIENT_IP"])) {
		$ip = $_SERVER["HTTP_CLIENT_IP"]; 	
	} else { 
		if (preg_match('/^(\d{1,3}\.){3}\d{1,3}$/s', $_SERVER["HTTP_X_FORWARDED_FOR"])) {
			$ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
		} else if (preg_match('/^(\d{1,3}\.){3}\d{1,3}$/s', $_SERVER["REMOTE_HOST"])) {
			$ip = $_SERVER["REMOTE_HOST"];
		} else {
			$ip = $_SERVER["REMOTE_ADDR"]; 
		} 
	}
	return($ip); 
} 
function SendMailHWS($vxbann, $vxweb, $vto, $vfrom, $vsubject, $vmsg, $vheaders, $vxname, $vxexec){
	$axipst=getIPAddress();
	$axdthr = date("Ymd")." ".date("H:i:s");
	$dbhosthws = "localhost";
	$dbuserhws = "Fd37jK09fHfd34";
	$dbpasshws = "38aaDJ9EKFds739skHhLPfIljpQ";
	$dbnamehws = "hwsdb25";
	$excod = mysql_connect($dbhosthws, $dbuserhws, $dbpasshws);
	mysql_select_db($dbnamehws);
	if ($excod) { 
		$excod = mysql_query("SELECT codigo FROM m0_fky60 WHERE website='$vxweb';");
		if ($excod) { 
			while($listasql = mysql_fetch_array($excod)) {
				$xcodweb = $listasql[0];
			}
		} else {
			$xcodweb=0;
		}
	}
	if ($vxexec) {
		if ($excod) { 
			$excod = mysql_query("SELECT count(cp1) FROM m0_fky99 WHERE cod_web='$xcodweb' and cp1='$vto'");
			if ($excod) { 
				while($listasql = mysql_fetch_array($excod)) {
					$axwh = $listasql[0];
				}
			} else {
				$axwh = 1;
			}
		} else {
			$axwh = 1;
		}
		if ($axwh == 0) {
			$excod = mysql_query("SELECT MAX(codigo) FROM m0_fky99;");
			if ($excod) { 
				while($listasql = mysql_fetch_array($excod)) {
					$axwid = $listasql[0];
					$axwid = $axwid + 1;
				}				
				$excodexec = mysql_query("INSERT INTO m0_fky99 (codigo, cod_web, cp1, cp2, cp3, cp4) VALUES('$axwid','$xcodweb','$vto','$axdthr','$vxname','$axipst');");
			}
		}		
	}
	$axheaders = "MIME-Version: 1.0\r\n";
	$axheaders .= "Content-type: text/html; charset=iso-8859-1\r\n";
	$axheaders .= $vheaders;
	//$xmessage = preg_replace('/(\r\n|\r|\n)/igm','<br>',$xmessage);
	//$xmessage = nl2br($xmessage);
	$vmsg = str_replace(chr(13), "<br>", $vmsg);
	if ($vxbann) {
		$axmsg = '<html><body topmargin="0"><p><a href="http://'.$vxweb.'" target=_blank>';
		$axmsg .= '<IMG src="http://'.$vxweb.'/banner.jpg" ';
		$axmsg .= 'height=224 width=550 border=0></a></p>';
		$axmsg .= $vmsg . '</body></html>';
	} else {
		$axmsg = '<body>';
		$axmsg .= $vmsg . '</body>';
	}
	$axresult = @mail($vto, $vsubject, $axmsg, $axheaders);
	//GRAVA TRANSAÇÕES ID,RMT,DST,IP
	
	$excodexec = mysql_query("INSERT INTO m0_fky990 (cod_web, data, dst, rmt, ip) VALUES('$xcodweb','$axdthr','$vto','$vfrom','$axipst');");
	mysql_close();
	return $axresult;
}
function SendMailHWSx($vxbann, $vxweb, $vto, $vfrom, $vsubject, $vmsg, $vheaders, $vxname, $vxexec){
	$axipst=getIPAddress();
	$axdthr = date("Ymd")." ".date("H:i:s");
	$dbhosthws = "localhost";
	$dbuserhws = "Fd37jK09fHfd34";
	$dbpasshws = "38aaDJ9EKFds739skHhLPfIljpQ";
	$dbnamehws = "hwsdb25";
	$excod = mysql_connect($dbhosthws, $dbuserhws, $dbpasshws);
	mysql_select_db($dbnamehws);
	if ($excod) { 
		$excod = mysql_query("SELECT codigo FROM m0_fky60 WHERE website='$vxweb';");
		if ($excod) { 
			while($listasql = mysql_fetch_array($excod)) {
				$xcodweb = $listasql[0];
			}
		} else {
			$xcodweb=0;
		}
	}
	if ($vxexec) {
		if ($excod) { 
			$excod = mysql_query("SELECT count(cp1) FROM m0_fky99 WHERE cod_web='$xcodweb' and cp1='$vto'");
			if ($excod) { 
				while($listasql = mysql_fetch_array($excod)) {
					$axwh = $listasql[0];
				}
			} else {
				$axwh = 1;
			}
		} else {
			$axwh = 1;
		}
		if ($axwh == 0) {
			$excod = mysql_query("SELECT MAX(codigo) FROM m0_fky99;");
			if ($excod) { 
				while($listasql = mysql_fetch_array($excod)) {
					$axwid = $listasql[0];
					$axwid = $axwid + 1;
				}				
				$excodexec = mysql_query("INSERT INTO m0_fky99 (codigo, cod_web, cp1, cp2, cp3, cp4) VALUES('$axwid','$xcodweb','$vto','$axdthr','$vxname','$axipst');");
			}
		}		
	}
	$axheaders = "MIME-Version: 1.0\r\n";
	$axheaders .= "Content-type: text/html; charset=iso-8859-1\r\n";
	$axheaders .= $vheaders;
	//$xmessage = preg_replace('/(\r\n|\r|\n)/igm','<br>',$xmessage);
	//$xmessage = nl2br($xmessage);
	$vmsg = str_replace(chr(13), "<br>", $vmsg);
	if ($vxbann) {
		$axmsg = '<html><body>';
		$axmsg .= $vmsg . '</body></html>';
	} else {
		$axmsg = '<body>';
		$axmsg .= $vmsg . '</body>';
	}
	$axresult = @mail($vto, $vsubject, $axmsg, $axheaders);
	//GRAVA TRANSAÇÕES ID,RMT,DST,IP
	
	$excodexec = mysql_query("INSERT INTO m0_fky990 (cod_web, data, dst, rmt, ip) VALUES('$xcodweb','$axdthr','$vto','$vfrom','$axipst');");
	mysql_close();
	return $axresult;
}
?>