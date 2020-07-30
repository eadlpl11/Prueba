const express = require('express');
const mysql = require('mysql');

const bodyParser  = require('body-parser');

const PORT = process.env.PORT || 3050;

const app = express();

app.use(bodyParser.json());

//MySql 
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'ChronosVS1',
    database: 'detlos',
});



//Inicial Hi!

app.get('/',(req,res) => {
    res.send('Welcome to my API!');
});

//--------------------------------------------------------------------------------
//                                  USER

//All users
app.get('/users',(req, res) =>{
    const sql = 'SELECT * FROM usuario ';
    connection.query(sql, (error, results)=>{
        if (error) throw error;
        if (results.length > 0){
            res.json(results);
        }else {
            res.send('No result');
        }
    })
});

//Search user by ID
app.get('/users/:id',(req, res) =>{
    const {id} = req.params;

    const sql = `SELECT * FROM usuario where id_usuario = ${id}`;

    connection.query(sql, (error, results) => {
        if (error) throw error;
        if (results.length > 0){
        res.json(results);
        }else{
            res.send('No result');
        }
    });
});

//Add user
app.post('/add', (req, res) =>{  
    var userObj = {
        pass: req.body.pass,
        nickname: req.body.nickname
    }; 

    const sql = `call insert_usuario ("${userObj.pass}","${userObj.nickname}")`;

    connection.query(sql, userObj, error => { 
        if (error) throw error;
        res.send('User created!');
    });
});

app.put('/update_user/:id', (req, res)=>{
    const { id } = req.params;
    const { pass,nickname } = req.body;
    const sql = `call upd_usuario(${id},"${pass}","${nickname}")`;

    connection.query(sql, error => {
        if (error) throw error;
        res.send('User updated');
    });
});


app.delete('/delete_user/:id', (req, res)=>{
    const { id } = req.params;
    const sql = `call del_usuario(${id})`;

    connection.query(sql, error => { 
        if (error) throw error;
        res.send('User deleted');
    });
})

//--------------------------------------------------------------------------------
//                                 TEACHERS

//All teachers
app.get('/teacher_all',(req, res) =>{
    const sql = 'SELECT * FROM maestro';
    connection.query(sql, (error, results)=>{
        if (error) throw error;
        if (results.length > 0){
            res.json(results);
        }else {
            res.send('No result');
        }
    })
});

//Search teacher by ID
app.get('/teacher/:id',(req, res) =>{
    const {id} = req.params;
    const sql = `SELECT * FROM maestro where id_maestro = ${id}`;

    connection.query(sql, (error, results) => {
        if (error) throw error;
        if (results.length > 0){
            res.json(results);
        }else{
            res.send('No result');
        }
    });
});

//Search tacher by skill and category (especialidad)
app.get('/teacher',(req, res) =>{
    const {skill, category} = req.body;

    const sql = `select concat(M.nombre_1," ",M.apellido_1) AS Nombre,M.especialidad,H.nivel, H.habilidad
    from maestro as M, habilidades as H
    WHERE (H.habilidad = "${skill}"  and  H.id_maestro = M.id_maestro) or (M.especialidad = "${category}"  and  H.id_maestro = M.id_maestro);`;

    connection.query(sql, (error, results) => {
        if (error) throw error;
        if (results.length > 0){
            res.json(results);
        }else{
            res.send('No result');
        }
    });
});


//Add teacher
app.post('/add_teacher', (req, res) =>{  
    var teacherObj = {
        nombre_1: req.body.nombre_1,
        nombre_2: req.body.nombre_2,
        apellido_1: req.body.apellido_1,
        apellido_2: req.body.apellido_2,
        especialidad: req.body.especialidad,
        valoracion: req.body.valoracion
    };

    const sql = `call insert_maestro ("${teacherObj.nombre_1}","${teacherObj.nombre_2}","${teacherObj.apellido_1}","${teacherObj.apellido_2}","${teacherObj.especialidad}","${teacherObj.valoracion}")`;

    connection.query(sql, teacherObj, error => {
        if (error) throw error;
        res.send('Teacher created!');
    });
});

//Falta hacer
app.put('/update_teacher/:id', (req, res)=>{
    const { id } = req.params;
    const { pass,nickname } = req.body;
    const sql = `call upd_usuario(${id},"${pass}","${nickname}")`;

    connection.query(sql, error => {
        if (error) throw error;
        res.send('Teacher updated');
    });
});

//Falta hacer
app.delete('/delete/:id', (req, res)=>{
    const { id } = req.params;
    const sql = `call del_usuario(${id})`;

    connection.query(sql, error => { 
        if (error) throw error;
        res.send('User deleted');
    });
})

//Este no es de la tabla maestro pero es un multivalorado so simion
//Insert habilidades
app.post('/add_teacher_skill/:id', (req, res) =>{  
    const { id } = req.params;
    var teacherObj = {
        habilidad: req.body.habilidad,
        nivel: req.body.nivel
    };
    
    const sql = `call insert_habilidades ("${teacherObj.habilidad}",${id},"${teacherObj.nivel}")`;

    connection.query(sql, error => {
        if (error) throw error;
        res.send('Teacher updated!');
    });
});


//--------------------------------------------------------------------------------
//                                 SESION

//All sesions
app.get('/sesion',(req, res) =>{
    const sql = 'SELECT * FROM sesion';
    connection.query(sql, (error, results)=>{
        if (error) throw error;
        if (results.length > 0){
            res.json(results);
        }else {
            res.send('No result');
        }
    })
});

//Search sesion by teacher
//Es useless que sea por id, mejor que sea por alumno en caso de maestro y visceversa
app.get('/sesion/:id',(req, res) =>{
    const {id} = req.params;
    const sql = `SELECT * FROM maestro where id_maestro = ${id}`;

    connection.query(sql, (error, results) => {
        if (error) throw error;
        if (results.length > 0){
        res.json(results);
        }else{
            res.send('No result');
        }
    });
});

//Add sesion
//Is an Teacher ID
app.post('/add_sesion/:id', (req, res) =>{  
    const { id } = req.params;
    const sesionObj = {
        id_alumno: req.body.usuario,
        fecha: req.body.fecha,
        puntuacion: req.body.puntuacion
    };
    console.log(id)
    const sql = `call insert_sesion('${sesionObj.id_alumno}','${id}','${sesionObj.puntuacion}','${sesionObj.fecha}')`;

    connection.query(sql, sesionObj, error => {
        if (error) throw error;
        res.send('Sesion created!');
    });
});

//Update sesion
//Needs to add date in fields but thats because SQL
app.put('/update_sesion', (req, res)=>{
    const { id, usuario, maestro, puntuacion } = req.body;
    const sql = `call upd_sesion(${id},${usuario},${maestro},${puntuacion})`;

    connection.query(sql, error => {
        if (error) throw error;
        res.send('Sesion updated');
    });
});

//Delete sesion
app.delete('/delete_sesion', (req, res)=>{
    const { id } = req.body;
    const sql = `call del_sesion(${id})`;

    connection.query(sql, error => { 
        if (error) throw error;
        res.send('Sesion deleted');
    });
})


















//Check connect
connection.connect(error =>{
    if(error) throw error;
    console.log('Databases server running');
    app.listen(PORT, () => console.log(`Server runnning on port ${PORT}`));
});