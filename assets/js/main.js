/*var maVariable=10;
var typeDeVariable = typeof maVariable;
alert(typeDeVariable);*/
/*var prenom = prompt('Quels est ton nom?');
var humeur = prompt('comment tu va ?')
var phrase = ' Ton prénom est ' + prenom + ' et tu va ' + humeur ;
alert(phrase);*/
/*
alert('Bienvenue sur mon programme d\'addition, en string puis en nombre');
number1 = prompt('Mettez votre premier nombre')
number2 = prompt('Mettez votre deuxième nombre')
console.log(number1 + number2);
console.log(Number(number1) + Number(number2));*/
// evenement confirm, alert, prompt, onclick (attribut)
// var inputUser = prompt('Quels a été ta dernière note?');

// if (inputUser < 10) {
//     alert('you have to work..');
// } else if(inputUser == 10) {
//     alert('Mouais tu reste sur tes aquis ..');
// } else if ( inputUser > 12 && inputUser < 16 ){
//     alert('Keep working bro!');
// } else if (inputUser >16) {
//     alert('C\'est ça gamin !!!');
// } else {
//     alert('Ta une note de marsien frerot..');
// }
// var message;
// var languagePref = prompt('Quel est ton language pref?');
// switch(languagePref) {
//     case "PHP" :
//         message = ('Yes l\'un des meilleur');
//     break;
//     case "Python" :
//         message =('Yes l\'un des premiers que j\'ai appris');
//     break;
//     case "Ruby" :
//         message = ('connais pas..');
//     break;
//     default :
//     message = ('T\'a suremen mis un language que je ne connais pas :p!');
// }
//factoriasation code
// console.log(message);
//ternaire
// alert((languagePref == 'PHP') ? 'COOL :D' : 'DOMMAGE :p');
// * Boucle
// var number = 1;
// while(number < 50){
//     console.log(number++);
// }
/*do {
    nbr1 = prompt('Veuillez entrer votre nombre svp');
} while(isNaN(nbr1))
*/

//for (var nombre = 1 ; nombre < 50 ; nombre++){
    // console.log(nombre);
// }

var fixed = document.getElementById('Fixed');


// alert(fixed.innerHTML);


//document.getElementById('navz').classList.remove('navbar fixed-top navbar-expand-lg navbar-light alpha');


if(fixed.innerHTML) {
    document.getElementById("navz").className = "navbar navbar-expand-lg navbar-light alpha";
} else {
    document.getElementById("navz").className = "navbar fixed-top navbar-expand-lg navbar-light alpha";
}

// const imagesContext = require.context('../img', true, /\.(png|jpg|jpeg|gif|ico|svg|webp)$/);
// imagesContext.keys().forEach(imagesContext);