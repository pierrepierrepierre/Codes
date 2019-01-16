s.boot // Boot the server, if you need to
s.reboot
s.quit

(
l= [
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Hunger games.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Captain America The First Avenge.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Immortel (ad vitam).wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Jumper.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Le jour ou la terre s'arreta.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Les Chroniques de Spiderwick.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Predators.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Resident Evil Extinction (Ba 2).wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Secret Defense.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/The Descent.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/127 heures.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Les herbes folles.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Loup.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/The Lady.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Un Balcon sur la mer.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/w Les Herbes Folles (boxe).wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/w Les Herbes Folles (technicien).wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/w THE TOURIST.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/w TWO LOVERS.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/w Vous allez rencontrer un bel et sombre inconnu.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Rush Hour 3.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Madagascar 2.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/Madagascar 3.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/x Depression et des potes.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/x Hors de prix.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/x La chance de ma vie.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/x Monsieur Papa.wav",
	"D:/Musique/Musique maison/Bandes Annonces/Liste Antoine/x Potiche.wav",
	/*"D:/Musique/Musique maison/WAV2/Liste Antoine/z Faut que ca danse.wav",
	"D:/Musique/Musique maison/WAV2/Liste Antoine/z Un heureux evenement.wav"*/
];
)
l.postln

(
~a = [
	~b1 = Buffer.read(s,l[0]),
	~b2 = Buffer.read(s,l[1]),
	~b3 = Buffer.read(s,l[2]),
	~b4 = Buffer.read(s,l[3]),
	~b5 = Buffer.read(s,l[4]),
	~b6 = Buffer.read(s,l[5]),
	~b7 = Buffer.read(s,l[6]),
	~b8 = Buffer.read(s,l[7]),
	~b9 = Buffer.read(s,l[8]),
	~b10 = Buffer.read(s,l[9]),
	~b11 = Buffer.read(s,l[10]),
	~b12 = Buffer.read(s,l[11]),
	~b13 = Buffer.read(s,l[12]),
	~b14 = Buffer.read(s,l[13]),
	~b15 = Buffer.read(s,l[14]) ];

~b = [
	~b16 = Buffer.read(s,l[15]),
	~b17 = Buffer.read(s,l[16]),
	~b18 = Buffer.read(s,l[17]),
	~b19 = Buffer.read(s,l[18]),
	~b20 = Buffer.read(s,l[19]) ];

~c = [
	~b21 = Buffer.read(s,l[20]),
	~b22 = Buffer.read(s,l[21]),
	~b23 = Buffer.read(s,l[22]),
	~b24 = Buffer.read(s,l[23]),
	~b25 = Buffer.read(s,l[24]),
	~b26 = Buffer.read(s,l[25]),
	~b27 = Buffer.read(s,l[26]),
	~b28 = Buffer.read(s,l[27])];

/*~d = [
	~b31 = Buffer.read(s,l[30]),
	~b32 = Buffer.read(s,l[31])];*/

~all = [~a ++ ~b ++ ~c];
~brand = ~all.choose;

a = ~a;
)

a.free;b.free;c.free;d.free;e.free;f.free;g.free;h.free;i.free;j.free;k.free;l.free;m.free;n.free;o.free;p.free;
a.get;b.get;c.get;d.get;e.get;f.get;g.get;h.get;i.get;j.get;k.get;l.get;m.get;n.get;o.get;p.get;

Synth("destroy", [\vol, 0.5, \dur, 100, \del, 0.05])

(
SynthDef("destroy",{
	arg buffer=a.bufnum,buffoffset=1,att=0,out=0,pan=0,rate=1,dur=1,gap=0,startPos=0,vol=0,del=0;
	var len = dur - gap - (att * 2);
	var env = Env([0,1,1,0],[att,len,att]);

	var play = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer)*rate,1,(BufFrames.ir(buffer)*(startPos)));

	Out.ar(out,	Mix.new([ Pan2.ar( TDelay.ar(play * EnvGen.ar(env,doneAction:0),del),pan,vol)]));
}).add;

SynthDef("play",{
	arg buffer=a.bufnum,buffoffset=1,att=0,out=0,pan=0,rate=1,dur=1,gap=0,startPos=0,vol=0,del=0;
	var len = dur - gap - (att * 2);
	var env = Env([0,1,1,0],[att,len,att]);

	var play = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer)*rate,1,(BufFrames.ir(buffer)*(startPos)));
	Out.ar(out,	Balance2.ar(play[0],play[1] ,pan,vol * EnvGen.ar(env,doneAction:2)));
}).add;

SynthDef("full",{
	arg buff=a.bufnum, buffoffset=1,att=0,out=0,rate=1,startPos=0,del=0,loop=1,volLag=0,panLag=0,panfreq=2,panfmul=0,volfreq=2,volfmul=0;
	var vol = NamedControl.kr(\vol,0,volLag);
	var pan = NamedControl.kr(\pan,0,panLag);
	var play = PlayBuf.ar(2,buff, BufRateScale.kr(buff)*rate,1,(BufFrames.ir(buff)*(startPos)),loop);
	pan = pan + FSinOsc.kr(panfreq,0,panfmul);
	vol = vol - ( vol * LFPulse.kr(volfreq,0,0.5,volfmul));
	Out.ar(out, Balance2.ar(play[0],play[1],pan,vol));
}).add;
)

// Buffers à charger pour synth FULL : ~a ~b ~c ~all
a.free; a = ~a;
a.free; a = ~b;
g.free; g = Array.series(a.size,0,1/a.size);

~all[0].choose.bufnum

// PARTY COLLAGE
z.free; z = Synth(\full,[\startPos,1.0.rand,\vol,1, \buffer, ~all[0].choose.bufnum]);
z.set(\vol,1, \selLag,0.3,\select,rrand(0.0,1.0).postln); // POSITION AU HASARD

z.set(\vol,0.2,\volLag,0);
z.set(\vol,0,\volLag,0);
z.set(\vol,0.2,\volLag,0,\selLag,0.2,\select,(g.choose).postln); // POSITION SUR 1 BA

z.set(\rate,0.3);
z.set(\rate,1);

Pbindef(\playme,\instrument,\play,\buffer,Pxrand(~a,inf),\vol,0.3,\startPos,Pseq([Pseries(0,0.02,50)],inf),\dur,Pseq([Pseries(2,-0.01,199),0.01],1),\att,0,\gap,0).play;

Pdef.removeAll

// PARTY CUT //

// DEFINIR 1 fichier pour le buffer
~one = Buffer.read(s,"D:/Musique/Musique maison/Bandes Annonces/BA 35mm (mars17 - LS100733 ).wav");
a.free; a = [~one];

/* Quelqu'un va apparaître */ ~startpos = 0.8813;
/* C'est stable ? */ ~startpos = 0.89515;
/* Qui est cette femme */ ~startpos = 0.0621;
/* Ligne de Mire */ ~startpos = 0.09212
/* Aller aux toilettes */ ~startpos = 0.144803;

( "LANCER".postln;
Pbindef(\playme,\instrument,\play,\vol,0.5,\buffer,a,\startPos,~startpos,\dur,0.005,\att,0,\gap,0).play;
Pbindef(\playyou,\instrument,\play,\vol,Pseq([0,0.1],inf),\pan,Prand([-1,-0.5,0.5,1],inf),\buffer,a,\startPos, Pwalk( Array.series(7000,0.0,1/7000), Pxrand((-2..2),inf), 1, 7000 * ~startpos),\dur,0.05,\att,0,\gap,0).play;
Pbindef(\playthem,\instrument,\play,\vol,Pseq([0,0.1],inf),\pan,Prand([-1,-0.5,0.5,1],inf),\buffer,a,\startPos, Pwalk( Array.series(7000,0.0,1/7000), Pxrand((-2..2),inf), 1, 7000 * ~startpos),\dur,0.065,\att,0,\gap,0).play;
)

"Ralentir #1".postln; Pbindef(\playme,\dur,Pseq([ Pseries(0.005,0.0000001,inf)],inf));
"Ralentir #2".postln; Pbindef(\playme,\dur,Pseq([ Pseries(0.0025,0.00001,inf)],inf));
"Ralentir #3".postln; Pbindef(\playme,\dur,Pseq([ Pseries(0.00012,0.00005,inf)], inf));
"Ralentir #4".postln; Pbindef(\playme,\dur,Pseries(0.05,0.001,inf),\att,0.0001);
"Ralentir #5".postln; Pbindef(\playme,\dur,Pseries(0.2,0.025,inf));
"FIXER".postln; Pbindef(\playme,\dur,1);

// NOUVEAU AJOUTER
/*y = Synth(\full,[\startPos,0.999.rand,\volfreq,rrand(0.7,2),\volLag,rrand(80,200),\panfreq,rrand(2,4),\panfmul,1,\volfmul,0.7]);
y.set(\vol,0.25)
y.set(\volfreq,rrand(3,6))
y.free*/
// FIN NOUVEAU AJOUTER

/* Bouger + et Accélerer */ Pbindef(\playme,\dur, Pseq([ Pseries(1.5,-0.1,10), Pseries(0.5,-0.005,99), Pseries(0.1,-0.0001,900), Pseries(0.01,-0.000001,1000), Pseries(0.005,-0.0000001,45000)],1),\startPos, Pwalk(Array.series(10000,0.0,1/10000), Pxrand([-2,1,3,4],inf),1,10000 * ~startpos));

/* Speeder : l'un après l'autre, diminuer le pas du pstutter 300 => 150 */
Pbindef(\playyou, \vol,Pseq([0,0.2],inf),\startPos, Pstutter(Pwhite(0,400).trace,Pwhite(0,0.99))); // <-- diminuer pas du  stutter
Pbindef(\playthem, \vol,Pseq([0,0.2],inf), \startPos, Pstutter(Pwhite(0,60).trace,Pwhite(0,0.99)));

Pbindef(\playyou, \startPos, Pwhite(0,0.999));
Pbindef(\playthem, \startPos, Pwhite(0,0.999));

/* (Bouger++) */ Pbindef(\playme,\att,0,\startPos,Pwalk(Array.series(5000,0.0,1/5000),Pwhite(-20,15,inf),Pseq([1, -1], inf),5000 * ~startpos).trace);

/* Random Pos */ Pbindef(\playme,\att,0.0000001,\startPos,Pwhite(0.0,1,inf).trace);

/* Bouger moins */ Pbindef(\playme,\att,0,\startPos,Pxrand([0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand,0.9.rand],inf).trace);

/* Kill */ Pbindef(\playme,\dur,Pseries(0.001,-0.00000005,inf));
/* Kill */ Pbindef(\playyou,\dur,Pseries(0.001,-0.0000005,inf));
/* Kill */ Pbindef(\playthem,\dur,Pseries(0.001,-0.00000005,inf));

////////////////////////////////////////////////////////////////////////
/* Attaque */ Pbindef(\playme,\att,Pseq([Pseries(0,0.00001,2000)],inf));
/* 2nd Bascule */ Pbindef(\playme,\buffer,Pseq(~a[0..2],inf));
/* No Attaque */ Pbindef(\playme,\att,0);
/* 2nd Bascule */ Pbindef(\playme,\buffer,Pseq(~a[0..5],inf));
/* 2nd Bascule */ Pbindef(\playme,\buffer,Pseq(~a,inf));

Pbindef(\playme).clear;



// THE DESCENT //
Pbindef(\playyou,\instrument,\full,\buffer,~b11,\vol,0.2,\dur,10).play;
Pbindef(\playyou,\dur,Pseq([0.5,Pwhite(5.0,10.0,1)],inf),\vol,Pseq([0,0.2],inf));


Pbindef(\playyou,\instrument,\play,\buffer,~b11,\vol,0.2,\dur,1).play;
Pbindef(\playyou,\startPos,rrand(0.00,0.9));
Pbindef(\playyou,\dur,Pseq([0.5,Pwhite(6.0,12.0,1)],inf),\vol,Pseq([0.2,\rest],inf),\att,0);
Pbindef(\playyou).clear;

Pbindef(\playme2,\instrument,\play,\buffer,~brand,\vol,0.2,\startPos,0,\dur,10,\att,0,\gap,0).play;

Pbindef(\playme3,\instrument,\play,\buffer,Pxrand(~all,inf),\vol,0.2,\startPos,Pseq([Pseries(0,0.02,50)],inf),\dur,30,\att,5,\gap,-10).play;

Pbindef(\playme2,\startPos,Pwhite(0.0,1.00,inf),\dur,0.3,\gap,0.1,\att,0.01);
Pbindef(\playme).clear;


// Controler manuellement le startpos
Pbindef(\playpos2,\instrument,\play,\buffer,c,\vol,0.1,\dur,1,\att,0.001,\gap,0).play;
Pbindef(\playpos3,\startPos,Pwhite(0.503,0.5035,inf),\dur,0.05);
Pbindef(\playpos2,\startPos,Pwhite(0.005,0.006,inf),\dur,0.2).play;
Pbindef(\playpos,\startPos,Pwhite(0.199,0.2,inf),\vol,0.18,\dur,Pwhite(0.1,0.2,inf),\att,0.01,\gap,0.02).clear;
Pbindef(\playpos2).clear;


Pbindef(\playme3,\instrument,\play,\buffer,~all.choose,\vol,0.2,\dur,160,\startPos,0,\att,Pwhite(0.0,20.0,inf)).play;

Pbindef(\playme4,\instrument,\play,\buffer,b.bufnum,\vol,0.2,\dur,4,\gap,0.1,\startPos,Pwalk(Array.series(100, 0, 0.03),1,1)).play;

Pbindef(\playme5,\instrument,\play,\buffer,Pseq([r],inf),\vol,0.2,\startPos,Pwalk(Array.series(100, 0, 0.03),1,1),\dur,5,\gap,0,\att,2).play;
Pbindef(\playme6,\instrument,\play,\buffer,a.bufnum,\vol,0.2,\startPos,0,\dur,120,\gap,0,\att,0).play;
Pbindef(\playme7,\instrument,\play,\buffer,c.bufnum,\vol,0.2,\startPos,0,\dur,120,\gap,0,\att,0).play;
Pbindef(\playme8,\instrument,\play,\buffer,d.bufnum,\vol,0.2,\startPos,0,\dur,120,\gap,0,\att,0).play;


Pbindef(\playme,\startPos,Pseries(0.0000,0.01,99));


Pbindef(\playme).clear;
Pbindef(\playme2).clear;
Pbindef(\playme3).clear;
Pbindef(\playme4).clear;
Pbindef(\playme5).clear;
Pbindef(\playme6).clear;
Pbindef(\playme8).clear;
