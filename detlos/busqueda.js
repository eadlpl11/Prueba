/**
 * Script para el dropdown menu de la derecha barra desplegable
 */
var button_user = document.getElementById('open-user');
var close_user = document.getElementById('close-user');
var modal_user = document.getElementById('modal-user');


close_user.style.display = 'none';
modal_user.style.display = 'none';

button_user.addEventListener('click', function (event) {
event.preventDefault();
modal_user.style.display = 'block';
button_user.style.display = 'none';
close_user.style.display = 'block';
});

close_user.addEventListener('click', function (event) {
event.preventDefault();
modal_user.style.display = 'none';
close_user.style.display = 'none';
button_user.style.display = 'flex';


});
       

/**
 * Script para el dropdown menu de la izquierda barra desplegable
 */

var button = document.getElementById('menu_img_barra');
var close = document.getElementById('close');
var modal = document.getElementById('modal');

button.addEventListener('click', function (event) {
event.preventDefault();
modal.style.display = 'block';
});

close.addEventListener('click', function (event) {
event.preventDefault();
modal.style.display = 'none';
});

  

//Request API cards
const charactersList = document.getElementById('grid');
const searchBar = document.getElementById(`input`);
let hpCharacters = [];
/* console.log(searchBar.value);
 */

searchBar.addEventListener('keyup', (e) => {
    const searchString = e.target.value.toLowerCase();

    const filteredCharacters = hpCharacters.filter((character) => {
        return (
            character.nombre_1.toLowerCase().includes(searchString) ||
            character.especialidad.toLowerCase().includes(searchString)
        );
    });
    displayCharacters(filteredCharacters);
});


const loadCharacters = async () => {
    try {
        const res = await fetch('./teachers.json');    //This line is diferent to normal API
        hpCharacters = await res.json();
        displayCharacters(hpCharacters);
    } catch (err) {
        console.error(err);
    }
};

const displayCharacters = (characters) => {
    const htmlString = characters.map((character) => {
            return `
            <div id="tarjeta" class='contador' style="background-image: url(imagenes/maestros/profile2.png)"><div class="texto_tarjeta">
            <div><h5>${character.nombre_1} ${character.apellido_1}</h5><h5>${character.especialidad}</h5></div>
            <div class="abajo"><h5><img src="imagenes/estrellas/cinco_estrellas(1).png" alt=""></h5><h5>
            <img id="green_dot" src="imagenes/icons/greendot.png" alt="">123</h5></div>
            </div></div>
            `;
            
    })
    .join('');

    charactersList.innerHTML = htmlString;
    

    
    
};
loadCharacters();


//Pruebas
    /* var parent = document.getElementById("parentId");
    var nodesSameClass = parent.getElementsByClassName("test");
    console.log(nodesSameClass.length); */

