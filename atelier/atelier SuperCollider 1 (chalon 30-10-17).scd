// SUPER ATLIER DE SYNTHESE SONORE COLLECTIVE

// Démarrer le serveur :
s.boot;

// Ouvrir les petits outils graphiques : ServerMeter, Freqscope, Node Tree

// Se rendre la vie moins difficile :

// Menu > View > Show Autocomplete
// Menu > Edit > Preference > Editor > Behaviour > Auto insert matching parenthesis
// '' > Display > Highlight Bracket Content




/////////////////////////////////////////////////////////////////////////

// Hello world : écrire dans le post window
"Hello".postln;







// Hello sound : créer des Nodes
{ SinOsc.ar( 163, 0, 0.3) }.play





// Stop sounds : Cmd + .












/////////////////////////////////////////////////////////////////////////

// Un Node qu'on peut rapeller

x = {SinOsc.ar(300, 0, 0.2)}.play
y = {LFSaw.ar(1050, 0, 0.1)}.play

x.free
y.free









/////////////////////////////////////////////////////////////////////////

// Un node avec des arguments

x = { arg freq=440, amp=0.1; LFTri.ar(freq, 0, amp)!2}.play
x.set("freq", 90)

y = {arg freq=1200, amp=0.1; Pulse.ar(freq, 0.5, amp)!2}.play
y.set(\freq, 68)
y.set(\amp, 0.0)
y.free
x.free



{LFPulse.ar(130, 0, 0.5, 0.1)!2}.play





















/////////////////////////////////////////////////////////////////////////

// Faire un peu n'importe quoi

{ SinOsc.ar(340) * SinOsc.ar(211) * 0.1}.play

{SinOsc.ar(241)}.plot

{ SinOsc.ar(340) * SinOsc.ar(241) * LFSaw.ar(90) * LFPulse.ar(190) * 0.1}.plot

// D'autres formes d'ondes utiles : faire Ctrl + D pour aller voir dans la doc comment ils s'utilisent

LFTri.ar
LFSaw.ar
LFPulse.ar


{LFPulse.ar()}.plot

// Pink Noise pour faire du bruit rose
{PinkNoise.ar(0.1) * LFSaw.ar(3, 0, 0.5,0.5)}.play


{LFSaw.ar(3, 0, 0.5,0.5)}.plot


















/////////////////////////////////////////////////////////////////////////

// Modulation de fréquence FM

{SinOsc.ar(440, 0, 400, 500)}.plot

{SinOsc.ar( SinOsc.ar(10) * 400 + 500, 0, 0.1)}.play

{SinOsc.ar( SinOsc.ar(10).range(198, 919), 0, 0.1)}.play

{SinOsc.ar(1987, 0, 400, 500)}.plot

{SinOsc.ar( LFSaw.ar(4, 0, 400, 800), 0, 0.1)}.play

{SinOsc.ar( SinOsc.ar( LFSaw.ar(10, 0, 40, 20.5), 0, 400, 300), 0, 0.1)}.plot





























/////////////////////////////////////////////////////////////////////////

// Des sons plus complexes : Créer un synthétiseur avec SynthDef
(
SynthDef("kill", {
	arg freq = 1300, amp = 0.1, modFreq = 1;
	var sig, fm;

	fm = LFNoise1.ar(modFreq, freq, freq); // Une fonction qui modulera la fréquence de l'onde porteuse


	sig = Mix.fill(8, { // duplique 8 fois la fonction ci-dessous et mixe les sons ensemble
		SinOsc.ar(
			fm + 900.rand.postln, // on ajoute un chiffre aléatoire entre 0 et 900 pour que chaque fonction ai une hauteur différente
			0,
			1/8 // on multiplie par 1/8 car la fonction sera dupliquée 8 fois.

		)
	});

	sig = sig * amp;

	Out.ar(0, sig); // Out indique qu'il faut jouer le son dans le canal 0 (par défaut c'est le canal gauche de votre carte son par défaut)

}).add // add pour ajouter la définition du synthé à la session
)

x = Synth("kill"); // x utilise le synthé kill pour émettre un son
x.set(\freq, 2600) // on peut varier les valeurs pendant que x joue
x.set(\modFreq, 10)
x.free





















/////////////////////////////////////////////////////////////////////////

// Un début et une fin : l'enveloppe

Env([0,1,0.5,0], [0.01,0.1,0.5], [6, 0, -6]).plot



(
SynthDef("blip", {
	arg amp=0.1, freq=400, rel=0.3;
	var sig, env;

	env = Env([0,1,0.2,0], [0.01,0.01,rel]).kr(2); // formule simple et pratique pour utiliser les enveloppe, le 2 à la fin indique qu'il faut eteindre le processus à la fin de l'enveloppe (sinon il pourrait continuer de tourner en silence)

	sig = SinOsc.ar( freq);

	sig = Pan2.ar(sig, LFNoise1.kr(8));

	Out.ar(0, sig * env * amp); // Penser à utiliser l'enveloppe en multipliant le sigal par celle-ci

}).add
)


x = Synth("blip")
z = Synth("blip", [\amp, 0.3.rand, \rel, 0.10])




/////////////////////////////////////////////////////////////////////////

// Motifs et repetition avec Pbindef
// a utiliser avec des synthés qui s'éteignent tout seul (le 2 à la fin de l'enveloppe au-dessus)


( Pbindef(
	\truc, // choisissez un nom pour pattern
	\instrument, \blip, // choisissez un instrument (un synthé ajouté à la session avec SynthDef)
	\dur, 2, // dur, argument par défaut des Pbindef : la durée entre deux sons
	\amp, 0.1, // ici on utilise les arguments défini par le SynthDef
	\freq, 1200
).play)

Pbindef(\truc, \dur, 1)

// Puis on peut faire varier les valeurs de tous les arguments sous forme de boucles, de motifs
Pbindef(\truc, \freq, Pseq( [Pwhite(2100,1000,1), 900, 500], inf) )

Pbindef(\truc, \dur, Pseq( [0.25, 0.25, 0.125], inf) )

Pbindef(\truc, \amp, Prand( [0.1,0.2, 0.05],inf ) )

Pbindef(\truc).resume


/// Utilisez la doc pour voir toutes les possibilités des pseq et prand et tous les autres, c'est très puissant



















/////////////////////////////////////////////////////////////////////////

// Sweeps
// utilisation d'une enveloppe pour gérer la hauteur d'une sinusoidale, et faire par exemple un kick techno

(
SynthDef("wow", {
	arg amp=0.1, freqA=2090, freqB=90, freqC=40, pan=0, att=0.01, rel=0.3;
	var sig, env, sweep;

	env = Env([0,1,0], [att,rel], [3, -3]).kr(2);

	sweep = Env([freqA, freqB, freqC], [att, rel], [-6, -6]).kr(2);

	sig = LFPar.ar(sweep);

	sig = Pan2.ar(sig, pan, env * amp);

	Out.ar(0, sig);
}).add
)



Pbindef(\machin, \instrument, \wow, \dur, 0.5).play

Pbindef(\machin,\freqA, 40000, \freqB, 60, \freqC, 1290).stop

Pbindef(\machin, \freqB, Pseries(90, 5,inf).trace, \pan, Pwhite(-1, 1.0))

Pbindef(\machin, \pan, 0)

Pbindef(\machin, \rel, Pwhite(0.1,1) )