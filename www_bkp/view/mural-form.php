				<h4>Deixe seu Recado</h4>
				<form action="#" method="post" name="sentRecado" id="centralForm" novalidate>
					<div class="control-group form-group">
                        <div class="controls">
                            <label class="central-p1">Nome:</label>
                            <input type="text" class="form-control" name="name" id="name" required data-validation-required-message="Digite seu nome.">
                            <p class="help-block"></p>
                        </div>
                    </div>	
                    <div class="control-group form-group">
                        <div class="controls">
                            <label class="central-p1">Email:</label>
                            <input type="email" class="form-control" name="email" id="email" required data-validation-required-message="Digite seu e-mail.">
							<p class="help-block"></p>
						</div>
                    </div>	
                    <div class="control-group form-group">
                        <div class="controls">
                            <label class="central-p1">Cidade/UF:</label>
                            <input type="text" class="form-control" name="cityuf" id="cityuf" required data-validation-required-message="Digite sua Cidade/UF.">
							<p class="help-block"></p>
						</div>
                    </div>
                    <div class="control-group form-group">
                        <div class="controls">
                            <label class="central-p1">Mensagem:</label>
                            <textarea type="textarea" class="form-control" name="messagem" id="messagem" required data-validation-required-message="Digite seu recado."></textarea>
							<p class="help-block"></p>
						</div>
                    </div>
                    <div id="success-m"></div>
                    <!-- For success/fail messages -->
                    <button type="submit" class="btn btn-primary">Enviar Recado</button>	
				</form>                