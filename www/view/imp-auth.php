<?
	header('Content-Type: text/html; charset=UTF-8',true);
	$xsenha = utf8_decode(strip_tags($_POST['senha']));
	if (empty($xsenha) || ($xsenha=='Senha')) $xsenha = '';
	$success = ($xsenha <> '');
	$mensaresult = "0";
	if ($success) {
		if ($xsenha == 'jlc2017') {
			$mensaresult = "1";
			session_start();
			$session = session_id();	
			$_SESSION['senha']=md5("jlc2017");
		}
	}
	echo $mensaresult;
?>