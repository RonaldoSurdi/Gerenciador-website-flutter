$(document).ready(function () {

	$('.navbar-collapse a').on('click', function(){
		if ( $( '.navbar-collapse' ).hasClass('in') ) {
			$('.navbar-toggle').click();
		}
	});

	var scheduleData,
		settingsData,
		discsData,
		soundsData;

    var firebaseConfig = {
        apiKey: "AIzaSyB3RoRyyHmYtqp2CqhohJN9zIWkhYPJaMM",
        authDomain: "joao-luiz-correa.firebaseapp.com",
        databaseURL: "https://joao-luiz-correa-default-rtdb.firebaseio.com",
        projectId: "joao-luiz-correa",
        storageBucket: "joao-luiz-correa.appspot.com",
        messagingSenderId: "980869849229",
        appId: "1:980869849229:web:59d8c8be93bb344d50c2c4",
        // measurementId: "G-1WWQMVMKC1",
    };
    firebase.initializeApp(firebaseConfig);
    firebase.analytics();

	var db = firebase.firestore();
	var storage = firebase.storage();
			
    function openpage(xurl,xdiv){
		//console.log(xurl);
		var xmlRequest = GetXMLHttp();
		$xdivget = $("#"+xdiv);
		function GetXMLHttp() {
			var xmlHttp;
			try { xmlHttp = new XMLHttpRequest(); }
			catch(er1) {
				try { xmlHttp = new ActiveXObject("Msxml2.XMLHTTP"); }
				catch(er2) {
					try { xmlHttp = new ActiveXObject("Microsoft.XMLHTTP"); }
					catch(er3) { xmlHttp = false; }
				}
			}
			return xmlHttp;
		}
		var mdeResult = function(){
			if (xmlRequest.readyState == 1) {
				//window.document.getElementById(xdiv).innerHTML = "<img src='images/web/loader.gif'>";
				$xdivget.html("<img src='images/loader.gif'>");
				//$xdivget.innerHTML = "<img src='images/web/loader.gif'>";
				
			} else if (xmlRequest.readyState == 4){
			   //window.document.getElementById(xdiv).innerHTML = xmlRequest.responseText;
			   $xdivget.html(xmlRequest.responseText);
			   //$xdivget.innerHTML = xmlRequest.responseText;
			}
		}
		xmlRequest.onreadystatechange = mdeResult;
		xmlRequest.open("GET",xurl,true);	
		xmlRequest.send(null);
		//return true;
	}
	
	//bts
	function updDsc() {
		$(".dsc").delegate("a", "click", async function(e) {
			console.log(e);
			e.preventDefault();
			href = $( this ).attr('href');
			hid = $( this ).attr('id');
			htitle = $( this ).attr('title');
			hrel = $( this ).attr('rel');

			var relParse = hrel.split("-");
			var ixAlb = relParse[0];
			var idAlb = relParse[1];
			var imageAlb = `https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/discs%2F${idAlb}%2F${discsData[ixAlb].image}?alt=media`;
			var yearAlb = discsData[ixAlb].year;
			var altAlb = discsData[ixAlb].title;
			var titleAlb = altAlb.replace(`${yearAlb}. `,'');
			var infoAlb = discsData[ixAlb].info;
			infoAlb = infoAlb.replaceAll('\n','<br>');
			
			var parseHtmlPop = `<div class="row">`;
			parseHtmlPop += `<div class="col-md-6"><div class="cap"><img src="${imageAlb}" alt="${altAlb}"></div></div>`;
			parseHtmlPop += `<div class="col-md-6"><div id="jp_container"><h2>${yearAlb}</h2><h3>${infoAlb}</h3>`;
			parseHtmlPop += `<p>`;

			var parseHtmlSound = '';

			data = await db.collection("discs").doc(idAlb).collection("sounds").orderBy("track").get();
			soundsData = [];
			if (data.size > 0) {
				response = data.docs;
				var idSnd, titleSnd, audioSnd, lyricSnd, cipherSnd;
				var tagSnd = 'track track-default';
				parseHtmlPop += `Músicas:<br>`;
				for (var z = 0; z < data.size; z++) {
					res = response[z].data();
					soundsData.push(res);
					idSnd = ("00" + res.track).slice(-2);
					titleSnd = res.title;
					audioSnd = res.audio;
					lyricSnd = res.lyric.replaceAll('\n', '<br>');
					cipherSnd = res.cipher;
					if (audioSnd != '') {
						if (!audioSnd.includes('https://') && !audioSnd.includes('https://')) {
							audioSnd = `https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/discs%2F${audioSnd}%2F$uri?alt=media`;
						}
						parseHtmlPop += `<a href="${audioSnd}" title="Reproduzir" class="${tagSnd}"><img src="images/player/play.png" alt="Reproduzir"></a>`;
						tagSnd = 'track';
					} else {
						parseHtmlPop += `<img src="images/player/play-off.png" alt="Audio indisponível">`;
					}
					if (lyricSnd != '' && lyricSnd != 'Letra não disponível' && lyricSnd != 'Letra não disponível<br>') {
						parseHtmlPop += `<a href="#msc${idSnd}" title="Letra"><img src="images/player/letra.png" alt="Letra"></a>`;
						parseHtmlSound += `<div id="msc${idSnd}" class="modalDialog2"><div><a class="close" title="Fechar" href="#close">X</a><div class="divtxt"><h4>${altAlb}</h4><p>${lyricSnd}</p></div></div></div>`;
					} else {
						parseHtmlPop += `<img src="images/player/letra-off.png" alt="Letra indisponível"></img>`;
					}
					if (cipherSnd != '') {
						parseHtmlPop += `<a href="${cipherSnd}" title="Cifra" target="_blank"><img src="images/player/cifra.png" alt="Cifra"></a>`;
					} else {
						parseHtmlPop += `<img src="images/player/cifra-off.png" alt="Cifra indisponível">`;
					}
					parseHtmlPop += `${idSnd}. ${titleSnd}<br>`;
					if ((z+1) >= data.size) {
						parseHtmlPop += `</p></div>`;
						$("#discoinfo").html(parseHtmlPop);
						$("#soundinfo").html(parseHtmlSound);
						updSnd();
						var x = $("#discoinfo").position().top-100;
						$('body,html').animate({
							scrollTop: x ,
							}, 700
						);
						/*window.scrollTo(0, (x.top-100));*/
					}
				};
			} else {
				parseHtmlPop += `Nenhuma música cadastrada.`;
				parseHtmlPop += `</p></div></div></div>`;
				$("#discoinfo").html(parseHtmlPop);
				$("#soundinfo").html(parseHtmlSound);
				var x = $("#discoinfo").position().top-100;
				$('body,html').animate({
					scrollTop: x ,
					}, 700
				);
				/*window.scrollTo(0, (x.top-100));*/
			}
		});
	}

	function updSnd() {
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
					tracknamelast.html('<img src="images/player/play.png">');
				}
				if (trackname != $(this).attr("href")) {
					my_jPlayer.jPlayer("play");
					$(this).html('<img src="images/player/pause.png">');
					trackname = $(this).attr("href");
					tracknamelast = $(this);
					//if(rd_jPlayer.jPlayer("getData","diag.isPlaying") == true){
						rd_jPlayer.jPlayer("pause");
					//}
				} else {
					my_jPlayer.jPlayer("stop");
					$(this).html('<img src="images/player/play.png">');
					trackname = '';
					tracknamelast = '';
					rd_jPlayer.jPlayer("play");
				}			
			}
			first_track = false;
			$(this).blur();
			return false;
		});
	}

	function updAgl() {
		$(".agl").delegate("a", "click", function(e) {
			e.preventDefault();
			var hrel = $( this ).attr('rel');
			var res = scheduleData[hrel];
			var scheduleTitle = res.title;
			var scheduleDescription = res.description;
			var schedulePlace = res.place;
			var scheduleDateIni = new Date(res.dateini.toDate());
			var scheduleDateEnd = new Date(res.dateend.toDate());
			var dateParse = ("00" + scheduleDateIni.getDate()).slice(-2);
			var monthParse = ("00" + (scheduleDateIni.getMonth() + 1)).slice(-2);
			var yearParse = scheduleDateIni.getFullYear();
			var hoursParse = ("00" + scheduleDateIni.getHours()).slice(-2);
			var minutesParse = ("00" + scheduleDateIni.getMinutes()).slice(-2);
			var hoursParse2 = ("00" + scheduleDateEnd.getHours()).slice(-2);
			var minutesParse2 = ("00" + scheduleDateEnd.getMinutes()).slice(-2);
			var parseHtmlPop = `<div class="row">`;
			parseHtmlPop += `<div class="col-md-6"><div class="cap"><img src="images/agenda-info.png" alt="Agenda"></div></div>`;
			parseHtmlPop += `<div class="col-md-6"><div id="jp_container">`;
			parseHtmlPop += `<h2>${scheduleTitle}</h2>`;
			parseHtmlPop += `<p>${schedulePlace}<br>`;
			parseHtmlPop += `No dia ${dateParse}/${monthParse}/${yearParse}<br>`;
			parseHtmlPop += `das ${hoursParse}:${minutesParse}hs às ${hoursParse2}:${minutesParse2}hs</p>`;
			if (scheduleDescription != null) {
				parseHtmlPop += `<p>${scheduleDescription}</p>`;
			}
			parseHtmlPop += `</div></div>`;
			parseHtmlPop += `</div>`;

			$("#agendainfo").html(parseHtmlPop);
			var x = $("#agendainfo").position().top-100;
			$('body,html').animate({
				scrollTop: x ,
				}, 700
			);
		});
	}
	$(".bgf").delegate("a", "click", function(e) {
		e.preventDefault();
		href = $( this ).attr('href');
		hid = $( this ).attr('id');
		htitle = $( this ).attr('title');
		hrel = $( this ).attr('rel');
		openpage("/view/artista.php?id="+hrel,"biografiainfo");
		var x = $("#biografiainfo").position().top-100;
		$('body,html').animate({
			scrollTop: x ,
		 	}, 700
		);
		/*window.scrollTo(0, (x.top-100));*/
	});
	
	// Monitora o clique nas setas da biografia
	biografia_scroller = $(".biografia_text").mCustomScrollbar({
		axis: "y"
	});
	$('.controllers').click(function(event){
		if($(this).hasClass('controller_up')){
			biografia_scroller.mCustomScrollbar("scrollTo", "top");
		} else if($(this).hasClass('controller_down')){
			biografia_scroller.mCustomScrollbar("scrollTo", "bottom");
		}
	});
	central_scroller = $(".central_text").mCustomScrollbar({
		axis: "y"
	});
	$('.controllers2').click(function(event){
		if($(this).hasClass('controller2_up')){
			central_scroller.mCustomScrollbar("scrollTo", "top");
		} else if($(this).hasClass('controller2_down')){
			central_scroller.mCustomScrollbar("scrollTo", "bottom");
		}
	});

	// disco
	var owl2 = $("#owl-div2");
	$(".next").click(function(){
		owl2.trigger('owl2.next');
	});
	$(".prev").click(function(){
		owl2.trigger('owl2.prev');
	});
	$(".play").click(function(){
		owl2.trigger('owl2.play',1000);
	});
	$(".stop").click(function(){
		owl2.trigger('owl2.stop');
	});

	// agenda
	var owl = $("#owl-div");
	$(".next").click(function(){
		owl.trigger('owl.next');
	});
	$(".prev").click(function(){
		owl.trigger('owl.prev');
	});
	$(".play").click(function(){
		owl.trigger('owl.play',1000);
	});
	$(".stop").click(function(){
		owl.trigger('owl.stop');
	});
	
	//imprensa
	$('form[name="sendImp"]').find('input').not('[type=submit]').jqBootstrapValidation({
        preventSubmit: true,
        submitError: function($form, event, errors) {
            // something to have when submit produces an error ?
            // Not decided if I need it yet
        },
        submitSuccess: function(event) {
            event.preventDefault(); // prevent default submit behaviour
            // get values from FORM
            var senha = $("input#senha").val();
            $.ajax({
                url: "/view/imp-auth.php",
                type: "POST",
                data: {
                    senha: senha
                },
                cache: false,
                success: function (data, status){
                    // Success message
                    data = $.trim(data);
					if (data == '1') {
						$('#success-i').html("<div class='alert alert-success'>");
						$('#success-i > .alert-success').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
							.append("</button>");
						$('#success-i > .alert-success')
							.append("<strong>Acesso autorizado. </strong>");
						$('#success-i > .alert-success')
							.append('</div>');
						//clear all fields
						$('#imprensaForm').trigger("reset");
						openpage("/view/imp-data.php","imprensa-restrict");
					} else {
						// Fail message
						$('#success-i').html("<div class='alert alert-danger'>");
						$('#success-i > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
							.append("</button>");
						$('#success-i > .alert-danger').append("<strong>Acesso negado, dados inválidos...</strong>");
						$('#success-i > .alert-danger').append('</div>');	
					}
                },
                error: function() {
                    // Fail message
                    $('#success-i').html("<div class='alert alert-danger'>");
                    $('#success-i > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
                        .append("</button>");
                    $('#success-i > .alert-danger').append("<strong>Erro ao conectar, tente novamente...</strong>");
                    $('#success-i > .alert-danger').append('</div>');
                    //clear all fields
                    $('#imprensaForm').trigger("reset");
                },
            })
        },
        filter: function() {
            return $(this).is(":visible");
        },
    });
	
	$('#senha').focus(function() {
    	$('#success-i').html('');
	});
	
	//recado
	$("#fbrec").delegate("a", "click", function(e) {
		e.preventDefault();
		$("#fbrec").css("display", "none");
		$("#fbcls").css("display", "block");
		$("#mural-form").css("display", "block");
		$("#central-mural").css("display", "none");
	});
	
	$("#fbcls").delegate("a", "click", function(e) {
		e.preventDefault();
		$("#fbrec").css("display", "block");
		$("#fbcls").css("display", "none");
		$("#mural-form").css("display", "none");
		$("#central-mural").css("display", "block");
	});
	
	$('form[name="sentRecado"]').find('input,textarea').not('[type=submit]').jqBootstrapValidation({
        preventSubmit: true,
        submitError: function($form, event, errors) {
            // something to have when submit produces an error ?
            // Not decided if I need it yet
        },
        submitSuccess: function(event) {
            event.preventDefault();
            var name = $("input#name").val();
            var email = $("input#email").val();
			var phone = $("input#phone").val();
			var cityuf = $("input#cityuf").val();
            var message = $("textarea#messagem").val();
            $.ajax({
                url: "https://us-central1-joao-luiz-correa.cloudfunctions.net/sendMail",
                type: "POST",
				dataType: "json",
                data: {
                    to_name: name,
                    to_email: email,
					to_phone: phone,
					city_uf: cityuf,
                    content: message
                },
                cache: false,
                success: function (data, status){
                    // Success message
					data = $.trim(data);
					console.log(data);
					if (data) {
						$('#success-m').html("<div class='alert alert-success'>");
						$('#success-m > .alert-success').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
							.append("</button>");
						$('#success-m > .alert-success')
							.append("<strong>Acesso autorizado. </strong>");
						$('#success-m > .alert-success')
							.append('</div>');
						//clear all fields
						$('#centralForm').trigger("reset");
						$("#fbrec").css("display", "block");
						$("#fbcls").css("display", "none");
						$("#mural-form").css("display", "none");
						$("#central-mural").css("display", "block");
						openpage("/view/mural.php","central-mural");
					} else {
						// Fail message
						$('#success-m').html("<div class='alert alert-danger'>");
						$('#success-m > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
							.append("</button>");
						$('#success-m > .alert-danger').append("<strong>Erro ao enviar a recado, tente novamente...</strong>");
						$('#success-m > .alert-danger').append('</div>');	
					}
                },
                error: function() {
                    // Fail message
                    $('#success-m').html("<div class='alert alert-danger'>");
                    $('#success-m > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
                        .append("</button>");
                    $('#success-m > .alert-danger').append("<strong>Erro ao enviar a recado, tente novamente...</strong>");
                    $('#success-m > .alert-danger').append('</div>');
                    //clear all fields
                    $('#centralForm').trigger("reset");
                },
            })
        },
        filter: function() {
            return $(this).is(":visible");
        },
    });
	
	$('#messagem').focus(function() {
		$('#successm').html('');
	});
	
	//contato
	/*$("input,textarea").jqBootstrapValidation({*/
	$('form[name="sentMessage"]').find('input,textarea').not('[type=submit]').jqBootstrapValidation({
        preventSubmit: true,
        submitError: function($form, event, errors) {
            // something to have when submit produces an error ?
            // Not decided if I need it yet
        },
        submitSuccess: function($form, event) {
            event.preventDefault();
            var name = $("#name").val();
            var email = $("#email").val();
			var phone = $("#phone").val();
			var cityuf = $("#cityuf").val();
            var message = $("#message").val();
			$.ajax({
                url: "https://us-central1-joao-luiz-correa.cloudfunctions.net/sendMail",
                type: "POST",
                data: {
                    to_name: name,
                    to_email: email,
					to_phone: phone,
					city_uf: cityuf,
                    content: message
                },
                cache: false,
                success: function(data) {
					console.log(data);
                    // Success message
                    $('#success').html("<div class='alert alert-success'>");
                    $('#success > .alert-success').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
                        .append("</button>");
                    $('#success > .alert-success')
                        .append("<strong>Sua mensagem foi enviada. </strong>");
                    $('#success > .alert-success')
                        .append('</div>');

                    //clear all fields
                    $('#contatoForm').trigger("reset");
                },
                error: function(error) {
					console.log(error);
                    // Fail message
                    $('#success').html("<div class='alert alert-danger'>");
                    $('#success > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
                        .append("</button>");
                    $('#success > .alert-danger').append("<strong>Erro ao enviar a mensagem, tente novamente...</strong>");
                    $('#success > .alert-danger').append('</div>');
                    //clear all fields
                    $('#contatoForm').trigger("reset");
                },
            });
        },
        filter: function() {
            return $(this).is(":visible");
        },
    });

    $("a[data-toggle=\"tab\"]").click(function(e) {
        e.preventDefault();
        $(this).tab("show");
    });
	
	$('#name').focus(function() {
		$('#success').html('');
	});

	/*face*/
	function statusChangeCallback(response) {
		if (response.status === 'connected') {
		  conectFB();
		} else {
		  $("#fbsts").html('<h3>Faça seu Cadastro e tenha Acesso à Área Exclusiva para Fãs,<br>Participe de Promoções, Receba Novidades e muito mais.</h3>');
		  $("#fbdwn").html('<p>Acesse nossa Central para visualizar o conteúdo completo.<br><br>- Downloads<br>- Envio de Recados<br>- Novidades<br>- Promoções ...</p>');
		  $("#fbini").css("display", "block");
		  $("#fbrec").css("display", "block");
		  /*$("#fbrec").css("display", "none");*/
		  $("#fbcls").css("display", "block");
		  $("#mural-form").css("display", "none");
		  $("#central-mural").css("display", "block");
		}
	  }
	  window.checkLoginState = function() {
		FB.getLoginStatus(function(response) {
		  statusChangeCallback(response);
		});
	  }
	  window.fbAsyncInit = function() {
		  FB.init({
			appId      : '223287822148917',
			cookie     : true,
			xfbml      : true,
			version    : 'v2.8'
		  });
		  FB.getLoginStatus(function(response) {
			statusChangeCallback(response);
		  });
	  };
	  /*(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "https://connect.facebook.net/pt_BR/sdk.js";
		fjs.parentNode.insertBefore(js, fjs);
	  }(document, 'script', 'facebook-jssdk'));
	  function conectFB() {
		FB.api('/me', function(response) {
			$("#fbsts").html('<h3>Olá ' + response.name + ', seja bem vindo a nossa Central de Fãs.</h3>');
			$("#fbini").css("display", "none");
			$("#fbrec").css("display", "block");
			$("#fbcls").css("display", "none");
		  	$("#mural-form").css("display", "none");
		  	$("#central-mural").css("display", "block");
			$("#name").val(response.name);
			$("#email").val(response.email);
			openpage("/view/down.php","fbdwn");
		});
	  }*/

	  async function getdata(getIdx) {
		var titleSite = "João Luiz Corrêa e Grupo Campeirismo";
		var titleUri = encodeURI(titleSite);
		var titleUtf8 = encodeURIComponent(titleSite);
		var webHttp = "https://joaoluizcorrea.com.br/";
		var webUri = encodeURI(webHttp);
		var webUtf8 = encodeURIComponent(webHttp);
		var parseHtmlSlider = '';
		var data,
			response,
			res,
			uri,
			filename;

		if (getIdx == 0) {
			//COUNTER
			getdata(10);
			$.ajax({
                url: "https://us-central1-joao-luiz-correa.cloudfunctions.net/counterView",
                type: "GET",
                cache: false,
                success: function(res) {
                    $('#count-view').html(res.count.toLocaleString("de-DE", {minimumFractionDigits: 0}));
					$('#count-online').html(res.online);
                },
                error: function(error) {
                    console.log(error);
                },
            });
		} else if (getIdx == 10) {
			data = await db.collection("settings").doc('data').get();
			settingsData = data.data();
			getdata(1);
		} else if (getIdx == 1) {
			//BANNERS
			data = await db.collection("banners").orderBy("date", "desc").get();
			if (data.size > 0) {
				response = data.docs;
				for (var z = 0; z < data.size; z++) {
					res = response[z].data();
					uri = `https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/banners%2F${res.filename}?alt=media`;
					parseHtmlSlider += `<div class="pogoSlider-slide" data-transition="fade" data-duration="6000" style="background-image:url(${uri});"></div>`;
					if ((z+1) >= data.size) {
						$('#js-main-slider').html(parseHtmlSlider);
						sliderInit();
						getdata(2);
					}
				};
			} else {
				getdata(2);
			}
		} else if (getIdx == 2) {
			//BIOGRAFIA
			data = await db.collection("biography").get();
			if (data.size > 0) {
				response = data.docs;
				res = response[0].data();
				parseHtmlSlider = res.description;
				parseHtmlSlider = parseHtmlSlider.replace("\r", "").replace("\n", "<br><br>");
				$('#biography').html(parseHtmlSlider);
				getdata(3);
			} else {
				getdata(3);
			}
		} else if (getIdx == 3) {
			//ARTISTAS
			var storageRef = await storage.ref("artists");
			await storageRef.listAll().then(function(result) {
				if (result.items.length > 0) {
					for (var z = 0; z < result.items.length; z++) {
						filename = result.items[z].fullPath
						filename = filename.replace("/", "%2F");
						uri = `https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/${filename}?alt=media`;
						parseHtmlSlider += `<div class="col-lg-2 col-md-2 col-sm-4 wthree2" data-aos="zoom-in"><div class="w3-agileits">`;
						parseHtmlSlider += `<div class="bgf">`;
						//parseHtmlSlider += `<a title="mais" rel="artist${filename}">`;
						parseHtmlSlider += `<img src="${uri}" alt="${filename}">`;//<br/>${filename}
						//parseHtmlSlider += `</a>`;
						parseHtmlSlider += `</div></div></div>`;
						if ((z+1) >= result.items.length) {
							$('#artists').html(parseHtmlSlider);
							getdata(4);
						}
					};
				} else {
					getdata(4);
				}
			}).catch(function(error) {
				console.log(error);
				getdata(4);
			});
		} else if (getIdx == 4) {
			//DISCOGRAFIA
			data = await db.collection("discs").orderBy("id").get();
			discsData = [];
			if (data.size > 0) {
				response = data.docs;
				var idAlb, titleAlb, imageAlb;
				var pathImage = 'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/';
				for (var z = 0; z < data.size; z++) {
					res = response[z].data();
					discsData.push(res);
					idAlb = ("000000" + res.id).slice(-5);
					titleAlb = res.title.replace(`${res.year}. `,'');
					imageAlb = `${pathImage}discs%2F${idAlb}%2F${res.image}?alt=media`;
					parseHtmlSlider += `<div class="item wthree1" data-aos="zoom-in"><div class="w3-agileits">`;
					parseHtmlSlider += `<div class="dsc"><a title="MAIS" rel="${z}-${idAlb}">`;
					parseHtmlSlider += `<img class="img-responsive" src="${imageAlb}" alt="${res.title}"></a>`;
					parseHtmlSlider += `<h2>${res.year}</h2>`;
					parseHtmlSlider += `<h3>${titleAlb}</h3>`;
					parseHtmlSlider += `</div></div></div>`;
					if ((z+1) >= data.size) {
						owl2.html(parseHtmlSlider);
						owl2.owlCarousel();
						updDsc();
						getdata(5);
					}
				};
			} else {
				getdata(5);
			}
		} else if (getIdx == 5) {
			//AGENDA
			data = await db.collection("schedule").orderBy("id", "desc").get();//.where("view", "=", "1")
			scheduleData = [];
			if (data.size > 0) {
				response = data.docs;
				for (var z = 0; z < data.size; z++) {
					res = response[z].data();
					scheduleData.push(res);
					// var scheduleId = res.id;
					var scheduleTitle = res.title;
					// var scheduleDescription = res.description;
					var schedulePlace = res.place;
					var scheduleDateIni = new Date(res.dateini.toDate());
					var scheduleDateEnd = new Date(res.dateend.toDate());
					var dateParse = ("00" + scheduleDateIni.getDate()).slice(-2);
					var monthParse = ("00" + (scheduleDateIni.getMonth() + 1)).slice(-2);
					var hoursParse = ("00" + scheduleDateIni.getHours()).slice(-2);
					var minutesParse = ("00" + scheduleDateIni.getMinutes()).slice(-2);
					var hoursParse2 = ("00" + scheduleDateEnd.getHours()).slice(-2);
					var minutesParse2 = ("00" + scheduleDateEnd.getMinutes()).slice(-2);
					parseHtmlSlider += `<div class="item wthree1" data-aos="zoom-in"><div class="w3-agileits">`;
					parseHtmlSlider += `<div class="agdt"><span class="dia">${dateParse}</span><span class="mes">/${monthParse}</span></div>`;
					parseHtmlSlider += `<div class="agtm"><span class="hora">${hoursParse}:${minutesParse}hs - ${hoursParse2}:${minutesParse2}hs</span></div>`;
					parseHtmlSlider += `<div class="aglc"><h3>${schedulePlace}</h3><h2>${scheduleTitle}</h2></div>`;
					parseHtmlSlider += `<div class="rodape">`;
					parseHtmlSlider += `<div class="infosh"><div class="agl"><a title="Informações sobre o Evento" rel="${z}"><img src="images/social/maisinfo.png"></a></div></div>`;
					parseHtmlSlider += `<div class="socialsh">Compartilhar:<br/><a href="http://www.facebook.com/sharer.php?u=${webUri}&t=${titleUri}" title="Compartilhar no Facebook" target="_new"><img src="images/social/fb-ico.png"></a>`;
					parseHtmlSlider += `<a href="http://twitter.com/share?text=${titleUtf8}&url=${webUtf8}" title="Compartilhar no Twitter" target="_new"><img src="images/social/tw-ico.png"></a>`;
					parseHtmlSlider += `<a href="https://plus.google.com/share?url=${webUtf8}" title="Compartilhar no Google" target="_new"><img src="images/social/gg-ico.png"></a></div>`;
					parseHtmlSlider += `</div></div></div>`;
					if ((z+1) >= data.size) {
						owl.html(parseHtmlSlider);
						owl.owlCarousel();
						updAgl();
						getdata(6);
					}
				};
			} else {
				getdata(6);
			}
		} else if (getIdx == 6) {
			//FOTOS
			data = await db.collection("photos").orderBy("date", "desc").get();
			if (data.size > 0) {
				response = data.docs;
				var titleAlbum, descAlbum, photosp, listRef, resStorage, fileName;
				var filePath = 'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/';
				for (var z = 0; z < data.size; z++) {
					res = response[z].data();
					titleAlbum = res.description;
					descAlbum = `${titleAlbum}<br>${res.place}<br>${res.date}`;
					parseHtmlSlider += `<div class="galeria col-xs-6 col-sm-4 col-md-3">`;
					parseHtmlSlider += `<ul id="galview${(z + 1)}" class="list-unstyled row">`;
					photosp = '';
					
					listRef = storage.ref().child(`photos/${res.id}`);
					resStorage = await listRef.listAll();
					await resStorage.items.forEach((itemRef) => {
						fileName = itemRef.fullPath;
						fileName = filePath + fileName.replaceAll("/", "%2F") + '?alt=media';
						parseHtmlSlider += `<li class="${photosp}" data-responsive="${fileName} 375, ${fileName} 480, ${fileName} 800" data-src="${fileName}" data-sub-html="${titleAlbum}"><a href="">`;
						parseHtmlSlider += `<img class="img-responsive" src="${fileName}">`;
						parseHtmlSlider += `<div class="gallery-poster"><img src="images/zoom.png"></div>`;
						parseHtmlSlider += `<div class="gallery-label">${descAlbum}</div></a></li>`;
						photosp = 'hide';
					});

					parseHtmlSlider += `</ul></div>`;
					if ((z+1) >= data.size) {
						$('#photo_view').html(parseHtmlSlider);
						setTimeout(function() { 
							for (var y = 0; y < data.size; y++) {
								$(`#galview${(y + 1)}`).lightGallery({thumbnail:true,hash:false});
							}
						}, 2000);
						getdata(7);
					}
				};
			} else {
				getdata(7);
			}
		} else if (getIdx == 7) {
			//VIDEOS
			if (settingsData.videostype == 0) {
				data = await db.collection("videos").orderBy("date", "desc").get();
				if (data.size > 0) {
					response = data.docs;
					parseHtmlSlider += `<ul id="vidview" class="list-unstyled row">`;
					for (var z = 0; z < data.size; z++) {
						res = response[z].data();				
						parseHtmlSlider += `<li class="col-xs-6 col-sm-4 col-md-3" data-src="https://www.youtube.com/watch?v=${res.watch}&autoplay=true" data-sub-html="${res.title}"><a href="">`;
						parseHtmlSlider += `<img class="img-responsive" src="${res.image}">`;
						parseHtmlSlider += `<div class="gallery-poster"><img src="images/play.png"></div>`;
						parseHtmlSlider += `<div class="gallery-label">${res.title}</div>`;
						parseHtmlSlider += `</a></li>`;
						if ((z+1) >= data.size) {
							parseHtmlSlider += `</ul>`;
							$('#vid_view').html(parseHtmlSlider);
							setTimeout(function() { 
								$('#vidview').lightGallery({download:true,zoom:false,autoplayControls:false,hash:false,youtubePlayerParams:{modestbranding:1,showinfo:0,rel:0,controls:0}});
							}, 2000);
						}
					};
				}
			} else {
				var Http = new XMLHttpRequest();			
				var url = 'https://www.googleapis.com/youtube/v3/search?key=AIzaSyB3RoRyyHmYtqp2CqhohJN9zIWkhYPJaMM';
				url += '&channelId=UCbDaA750q0NCXdaQlptSa9A';
				url += '&part=snippet,id';
				url += '&type=video';
				url += '&videoSyndicated=true';
				url += '&order=date';
				url += '&maxResults=16';
				Http.open("GET", url);
				Http.send();
				Http.onloadend = (e) => {
					var res = Http.responseText;
					var data = JSON.parse(res);
					if (data.items) {
						parseHtmlSlider += `<ul id="vidview" class="list-unstyled row">`;
						for (var z = 0; z < data.items.length; z++) {
							parseHtmlSlider += `<li class="col-xs-6 col-sm-4 col-md-3" data-src="https://www.youtube.com/watch?v=${data.items[z].id.videoId}&autoplay=true" data-sub-html="${data.items[z].snippet.title}"><a href="">`;
							parseHtmlSlider += `<img class="img-responsive" src="${data.items[z].snippet.thumbnails.high.url}">`;
							parseHtmlSlider += `<div class="gallery-poster"><img src="images/play.png"></div>`;
							parseHtmlSlider += `<div class="gallery-label">${data.items[z].snippet.title}<br>${data.items[z].snippet.description}</div>`;
							parseHtmlSlider += `</a></li>`;
							if ((z+1) >= data.items.length) {
								parseHtmlSlider += `</ul>`;
								$('#vid_view').html(parseHtmlSlider);
								setTimeout(function() { 
									$('#vidview').lightGallery({
										download:false,
										zoom:false,
										autoplayControls:false,
										hash:false,
										youtubePlayerParams:{
											modestbranding:1,
											showinfo:0,
											rel:0,
											controls:1
										}
									});
								}, 2000);
							}
						};
					}
				}
			}
		}
		return;
    }

    function sliderInit() {
        $('#js-main-slider').pogoSlider({
            autoplay: true,
            autoplayTimeout: 4000,
            displayProgess: true,
            preserveTargetSize: true,
            targetWidth: 1600,
            targetHeight: 900,
            responsive: true
        }).data('plugin_pogoSlider');
    }

	getdata(0);
});