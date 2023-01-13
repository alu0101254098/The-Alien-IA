/* THE ALIEN
Juego simple desarrollado en Prolog
Jonathan Martínez Pérez alu0101254098 */

:- dynamic estado_linterna/1, descripcion/1, en/2, estoy/1, vivo/1, observar_objeto/1.
:- retractall(en(_, _)), retractall(estoy(_)), retractall(vivo(_)), retractall(estado_linterna(_)).

%Definimos el punto de inicio
estoy(campo).
estado_linterna(rota).


%Caminos interconectados
camino(alien, f, nave_espacial).

camino(nave_espacial, d, alien).
camino(nave_espacial, o, entrada_nave).

camino(entrada_nave, e, nave_espacial).
camino(entrada_nave, s, campo).

camino(campo, n, entrada_nave) :- estado_linterna(repuesto).
camino(campo, s, casa_abandonada).
camino(campo, n, entrada_nave) :-
write('Esta muy oscuro ahí dentro... Debería buscar algo...'), nl,
!, fail.

camino(casa_abandonada, n, campo).
camino(casa_abandonada, o, cuarto).
camino(casa_abandonada, e, caja_fuerte) :- en(llave, llevar_en_mano).
camino(casa_abandonada, s, sala_hombre).
camino(casa_abandonada, e, caja_fuerte) :-
write('La caja fuerte parece estar cerrada con un candado...'), nl,
fail.

camino(sala_hombre, n, casa_abandonada).

camino(cuarto, e, casa_abandonada).

camino(caja_fuerte, o, casa_abandonada).

% Objetos
en(huevo_alien, alien).
en(llave, entrada_nave).
en(linterna, casa_abandonada).
en(pistola_rayos, caja_fuerte).
en(libro, sala_hombre).


% Estado de los personajes
vivo(alien).
vivo(monstruo).

% Coger objeto
coger(X) :-
en(X, llevar_en_mano),
write('Lo tengo ya en la mano! Parece que estoy algo despistado.'),
nl, !.

coger(X) :-
estoy(Ubicacion),
en(X, Ubicacion),
retract(en(X, Ubicacion)),
assert(en(X, llevar_en_mano)),
write('Lo tengo!'),
nl, !.

coger(_) :-
write('No parece que haya nada interesante por Aqui...'),
nl.

% Tirar objeto.
tirar_suelo(X) :-
en(X, llevar_en_mano),
estoy(Ubicacion),
retract(en(X, llevar_en_mano)),
assert(en(X, Ubicacion)),
write('No necesitaré esto.'),
nl, !.

tirar_suelo(_) :-
write('No tengo nada en la mano...'),
nl.

% ver inventario.
ver_inventario :-
findall(X, en(X, llevar_en_mano), Inventario),
(Inventario == [] ->
write('No tienes ningun objeto en tu inventario'), nl;
write('Tu inventario es: '), nl,
write(Inventario), nl
).

% Direcciones hacia las que puedes ir. Norte Sur Este Oeste Dentro y Fuera
n :- ir(n).
s :- ir(s).
e :- ir(e).
o :- ir(o).
d :- ir(d).
f :- ir(f).

% Inspeccionar objetos
observar_objeto(X) :-
en(X, llevar_en_mano),
descripcion(X),!.

observar_objeto(X) :-
estoy(Ubicacion),
en(X, Ubicacion),
descripcion(X),!.
    
observar_objeto(_) :-
write('No parece que haya ningún objeto interesante por aqui...'),nl.

observar_objeto(linterna) :-
en(linterna, llevar_en_mano),
write('Es una linterna antigua, pero parece que no funciona.'),
nl,
estado_linterna(rota),
write('La linterna esta rota. deberías buscar una manera de repararla'), nl.
    
observar_objeto(linterna) :-
en(linterna, llevar_en_mano),
write('Es una linterna antigua, pero parece que esta reparada.'),
nl,
estado_linterna(repuesto).
    
observar_objeto(linterna) :-
write('No tienes la linterna contigo'), nl.

% Como moverte
ir(Direccion) :-
estoy(Aqui),
camino(Aqui, Direccion, Alli),
retract(estoy(Aqui)),
assert(estoy(Alli)),
observar, !.

ir(_) :-
write('No existe un camino por Aqui...').


% Como observar tu actual Ubicacion.
observar :-
estoy(Ubicacion),
dialogo(Ubicacion),
nl,
buscar_objetos(Ubicacion),
nl.


% Como buscar objetos.
buscar_objetos(Ubicacion) :-
en(X, Ubicacion),
write('Vaya he encontrado '), write(X), write(' en el suelo.'), nl,
fail.

buscar_objetos(_).


% Matar al monstruo o al alien.
atacar :-
estoy(cuarto),
write('El monstruo está viniendo hacia mi...'), nl,
write('Has muerto.'), nl,
!, muerto.

atacar :-
estoy(cuarto),
en(pistola_rayos, llevar_en_mano),
retract(vivo(monstruo)),
write('Usaré la pistola para matarlo!'), nl,
write('Disparas la pistola contra el mostruo, lo desintegras facilito.'), nl,
write('Has matado al monstruo, pero no es tu objetivo principal'),
nl, !.

atacar :-
estoy(nave_espacial),
write('Atacaré la nave con mis propias manos!'), nl,
write('Obviamente no surge efecto TONTO, está hecha de acero.'), nl, !.

atacar :-
estoy(alien),
en(pistola_rayos, llevar_en_mano),
retract(vivo(alien)),
write('Usaré la pistola para matarlo!'), nl,
write('Disparas la pistola contra el alien, parece que lo has matado'), nl,
write('Has salvado al pueblo del invasor extraterrestre.'),
nl, !.

atacar :-
estoy(alien),
write('Le pegaré una paliza!'), nl,
write('Le pegas con tus manos pero no surge efecto, parece que esta dormido...'), nl.

atacar :-
write('No hay ninguna amenaza por Aqui...'), nl.


% Morir. */
muerto :-
!, final.

final :-
nl,
write('Se acabó el juego! Escriba ctrl+D.'),
nl, !.


% Instrucciones.
instrucciones :-
nl,
write('The Alien: Prolog'), nl,
write('Use los siguientes comandos para jugar!'), nl,
write('empezar. -- empezar a jugar.'), nl,
write('n. s. e. o. d. f. -- moverte por el mapa.'), nl,
write('coger(objeto). -- coger un objeto del suelo.'), nl,
write('tirar_suelo(objeto). -- tirar un objeto.'), nl,
write('atacar. -- atacar.'), nl,
write('observar. -- mirar alrededor.'), nl,
write('instrucciones. -- mostrar intrucciones.'), nl,
write('ver_inventario. -- mostrar inventario.'), nl,
write('repare(objeto). -- intentar reparar.'), nl,
write('Ctrl+D. -- salir del juego.'), nl,
nl.


% Inicio
empezar :-
instrucciones,
observar.

% Reparar linterna
repare(linterna):-
estado_linterna(rota),
acertijo(linterna).
repare(linterna):-
estado_linterna(repuesto),
write('La linterna no esta rota'),nl.


acertijo(linterna) :-
write('La linterna está rota que debería hacer?'), nl,
write('a Tirarla contra el suelo!'), nl,
write('b Sacar las pilas soplarle y volver a meterlas.'), nl,
write('c Intentar repararla desmontándola'), nl,
read(Respuesta),
(Respuesta == b ->
write('Correcto! La linterna se ha reparado'), nl,
retract(estado_linterna(rota)),
assert(estado_linterna(repuesto));
write('Incorrecto, sigue intentando'), nl,
acertijo(linterna)
).

% Dialogos e interacciones

dialogo(campo) :-
en(huevo_alien, llevar_en_mano),
write('Has robado el huevo y evitaste que se reprodujera'), nl,
write('HAS GANADO!'), nl, final.

dialogo(campo) :-
write('Estas en una gran explanada'), nl,
write('Al norte hay una oscura entrada hacia una nave enorme.'), nl,
write('Al sur hay una casa abandonada muy tétrica.'), nl,
write('Que miedo da este sitio, tengo frío...'), nl.

dialogo(casa_abandonada) :-
write('Estas en una casa abandonada y media derruída.'), nl,
write('Al este hay un cuarto del que brota un ruido extraño.'), nl,
write('Al oeste hay una caja fuerte, tal vez haya algo dentro!.'), nl,
write('Al norte vuelves al campo.'), nl,
write('¿Que debería hacer?'), nl.

dialogo(cuarto) :-
vivo(monstruo),
write('Hay un monstruo muy asqueroso dentro.'), nl,
write('Está encadenado pero te observa con ganas de comerte.'), nl,
write('Debo irme de aquí VOLANDO.'), nl,
write('Al este sales del cuarto a la entrada de la casa'), nl.

dialogo(cuarto) :-
write('El cadáver del monstruo yace en el suelo'), nl,
write('Es una amenaza menos pero no era tu objetivo principal'), nl.

dialogo(caja_fuerte) :-
write('Hay una simple caja fuerte Aqui, parece dificil de abrir...'), nl,
write('Al oeste vuelves a la entrada de la casa'), nl.

dialogo(sala_hombre) :-
write('Hombre: Hola joven, he oído hablar de una pistola de rayos'), nl,
write('muy poderosa que se encuentra en una caja fuerte en esta casa'), nl,
write('abandonada. Sin embargo, se dice que solo se puede abrir con una llave especial'), nl.

dialogo(entrada_nave) :-
write('Estas en la entrada de la nave espacial.'), nl,
write('Esta muy oscuro, que mal rollo...'), nl,
write('Al este entras a la nave.'), nl,
write('Al sur esta el campo.'), nl.

dialogo(nave_espacial) :-
vivo(alien),
en(huevo_alien, llevar_en_mano),
write('El alien esta viendo como intento quitarle el huevo... Oh dios'), nl,
write('.....Mueres en un instante.'), nl,
muerto.

dialogo(nave_espacial) :-
vivo(alien),
write('Dios mío, es el alien'), nl,
write('Debo estar en silencio para no despertarlo...'), nl, !.
dialogo(nave_espacial) :-
write('Me están dando escalofríos...'), nl,
write('Al oeste sales a la entrada de la nave'), nl,
write('Vayamonos de aquí cuanto antes.'), nl.

dialogo(alien) :-
vivo(alien),
write('Estas delante del Alien, parece dormido...'), nl.

dialogo(alien) :-
write('El cadáver del alien empezará a descomponerse pronto, volvamos a casa...'), nl, final,
!.

descripcion(linterna):-
estado_linterna(rota), nl,
write('La linterna no funciona!, debo repararla!'),nl.

descripcion(linterna):-
estado_linterna(repuesto), nl,
write('Es una linterna antigua, con un diseño peculiar, pero sigue funcionando'),nl.
    
descripcion(pistola_rayos):-
write('Es una pistola de rayos de ultima generación, tiene un gran poder destructivo'),nl.
    
descripcion(llave):-
write('Es una llave antigua, con un diseño peculiar, no estoy seguro de para que sirve'),nl.

descripcion(libro):-
write('Es un libro antiguo... Veamos que pone!'), nl,
write('Cuenta la leyenda que una llave de hierro te dará lo que necesitas para hacer frente al monstruo...'), nl.
