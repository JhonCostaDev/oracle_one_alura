
// alert('Jogo da adivinhação');
// const numeroSecreto = Math.ceil(Math.random() * 10 + 1);
// let numTentativas = 0;
// while(numTentativas <= 3) {
//     let chute = prompt("Digite um número de 0 à 10");
//     numTentativas ++;
//     let tentativa = (numTentativas == 1) ? 'tentativa' : 'tentativas';
//     if (numeroSecreto == chute) {
//     alert(`Parabéns, você acertou em ${numTentativas} ${tentativa}`);
//         break;
//     } else {
//         if (numeroSecreto < chute) {
//             alert(`O número secreto é menor que ${chute}!`);
                
//         } else {
//             alert(`O número secreto é maior que ${chute}!`);
             
//         }
    
//     }   
// }
// alert("Fim de Jogo");
//console.log(parseInt(Math.random()*4))
function exibirTexto(tag, texto){
    paragrafo = document.querySelector(tag);
    paragrafo.innerHTML = texto
}


function verificaChute() {
    let chute = document.getElementById("number").value;
    
    exibirTexto('p', 'vc errou');
}
