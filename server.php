<?php 
echo 'server.php';
    //conect to database
    $username = "";
    $email = "";
    $errors = array();

    // Connecto to the database
    $db = mysqli_connect('localhost:3306', 'root', 'ChronosVS1','detlos');

    //Event listener
    if(isset($_POST['register'])){
        $username = mysql_real_escape_string ($_POST['username']);
        $email = mysql_real_escape_string ($_POST['email']);
        $password_1 = mysql_real_escape_string ($_POST['password_1']);
        $password_2 = mysql_real_escape_string ($_POST['password_2']);

        //ensure that form fields are filled properly
        if (empty($username)) {
            array_push($errors, "Ingrese un nombre de usuario");
        }

        if (empty($email)) {
            array_push($errors, "Ingrese un correo electronico");
        }
        
        if (empty($password_1)) {
            array_push($errors, "Ingrese una contrasena");
        }
        
        if (empty($password_1 != $password_2)) {
            array_push($errors, "Las contrasenas no coinciden");
        }

        //If there are no errors, sabe the user to database
        if (count($errors) == 0){
            $password = md5($password_1); //Encrypt password
            $sql = "call insert_usuario('$password',`$username')"; //NEED TO ADD EMAIL
            // puede que sean las comillas
            mysqli_query($db, $sql);
        }
        
    }
    
    
?>