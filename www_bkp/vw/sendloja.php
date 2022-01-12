<?
header('Content-Type: text/html; charset=UTF-8',true);
//ini_set('display_errors',1);
//ini_set('display_startup_erros',1);
//error_reporting(E_ALL);

$to = $_POST['to'];
$from = $_POST['from'];
$fromName = utf8_decode($_POST['fromname']);
$subject = utf8_decode($_POST['subject']);
$message = utf8_decode($_POST['message']);

require_once('class.phpmailer.php');

// Instância a classe PHPMailer
$mail = new PHPMailer();
$mail->IsSMTP();
//$mail->SMTPDebug = 1;
$mail->Host = "mail.grupomidiaa.com.br"; // Endereço do servidor SMTP
$mail->Username = 'smtp@grupomidiaa.com.br'; // Usuário do servidor SMTP
$mail->Password = 'rt3456vyUT56ar5TxR'; // A Senha do email indicado acima
$mail->SMTPAuth = true;
//$mail->SMTPSecure = "ssl";
$mail->Port = "587";
$mail->From = "smtp@grupomidiaa.com.br";//$from;//
$mail->FromName = utf8_decode("João Luiz Corrêa e Grupo Campeirismo");//$fromName;

// Destinatário
$mail->AddAddress($to, $to);

// Opcional (Se quiser enviar cópia do email)
$mail->AddCC('smtp@grupomidiaa.com.br', 'smtp@grupomidiaa.com.br');
// $mail->AddBCC('CopiaOculta@dominio.com.br', 'Copia Oculta');

// Define tipo de Mensagem que vai ser enviado
$mail->IsHTML(true); // Define que o e-mail será enviado como HTML

// Assunto e Mensagem do email
$mail->Subject = $subject; // Assunto da mensagem
$mail->Body = $message;

// Envia a Mensagem
$enviado = $mail->Send();



?>