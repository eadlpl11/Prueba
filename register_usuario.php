<?php include('server.php')?>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Login Form Design One | Fazt</title>
    <link rel="stylesheet" href="signup.css">
  </head>
  <body>

    <div class="background">
      <div class="blur"></div>
    </div>
    
   
    
    <div class="login-box">
      
      <a href="index.php"><img src="imagenes/logo.png" class="avatar" alt="" href ></a>
  
      <h1>Registrate</h1>


        <form method="post" action="register.php" id="form_register">

        <?php include('errors.php');?>
        <br>
        <label for="Nombre de usuario">Nombre de usuario</label>
        <input type="text" placeholder="Ingresa tu Nombre de usuario" name="username">
       
        <label for="Nombre de usuario">Correo electronico</label>
        <input type="text" placeholder="juanito123@gmail.com" name="email">

        <label for="contraseña">Contraseña</label>
        <input type="password" name="password_1" placeholder="Ingresa tu Contraseña" autocomplete="current-password" >

        <label for="contraseña"></label>
        <input type="password" name="password_2" placeholder="Vuelve a ingresar tu Contraseña" autocomplete="current-password">
        

        <div class="formularios" id="datos_personales">
          <p>Fecha de nacimiento</p>
        </div>
        <div class="formularios">
        
        <input type="date" id="fecha" value="Fecha">
      
        
        <select name="Genero" id="Genero" >
          <option value="" selected disabled hidden>Genero</option>
          <option value="1">Hombre</option>
          <option value="2">Mujer</option>
          <option value="3">Otro</option>
          <option value="4">Prefiero no decirlo</option>
        </select>
        </div>

        <button type="submit" value="register" name="register">Registar</button>
        <!-- <input > -->
              <div class="recordatorios">
              <a href="indexusuario.php">¿Ya tienes una cuenta?</a><br>
            </div>
        </form>
        
    </div>
  </body>
</html>

