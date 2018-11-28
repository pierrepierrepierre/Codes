(
SynthDef("formant", { arg out=0,freq=60,addFreq=700,amp=0.5,
	att=0.01,rel=0.1,sus=0,attC=0,relC=0,
	bwfreq=880,lenmul=2,pan=0,panrand=1;
	var len, env, sound, sfreq = freq, efreq = freq+(addFreq);
	len = (att+sus+rel)*lenmul;
	env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).kr(2);
	sfreq = XLine.kr(sfreq,efreq,len); /* XLine pour le formant */
	efreq = XLine.kr(efreq,sfreq,len); /* XLine pour le formant */
	sound = Formant.ar(sfreq,efreq,bwfreq);
	sound = sound * env * amp;
	sound =  Pan2.ar(sound ,Lag.kr(LFNoise1.kr(1.0),2,panrand,pan));
	Out.ar(out, sound);
}).add;

SynthDef("autoglob", {arg argA=10, argB=0.2,argC=400, ampLag=2,out=0,panFreq=10;
	var amp = NamedControl.kr(\amp,0.2,ampLag);
	var sig =
	Formant.ar(
		(LFNoise1.kr(LFNoise1.kr(0.1,1,0.5) * argA,1) * 140).scaleneg(argA),
		(LFNoise1.kr(LFNoise1.kr(0.02,0.5,0.5) * argB ,1,1 )*800).scaleneg(argB),
		(LFNoise1.kr(1,0.5,1) * argC),
		(Gendy1.kr(
			/*ampdist*/ 2
			,/*durdist*/ 0.1
			, /*adparam*/ 0.001
			, /*ddparam*/ 0.99
			,/*minfre*/ 0.0001
			,/*maxfreq*/ 2
			,/*ampscale*/ 0.000001
			,/*durscale*/ 0.01
			,/*initCPs*/ 12
			,/*knum*/ 1
			,/*mul*/ 0.5)
	));
	sig = Pan2.ar(sig, LFNoise1.kr(LFNoise1.kr(panFreq,100,100)),amp);
	Out.ar(out,sig);
}).add;

SynthDef("autoformant", {arg fund=80,form=300,bw=600,ampLag=2,out=0,speed1=0.1, speed2=0.1,pres=0.5;
	var amp = NamedControl.kr(\amp,0.2,ampLag);
	var sig, fundfq, formfq, bwfq, randy;

	randy = [LFNoise0.kr(0.5*speed2,100,100)/100,LFNoise0.kr(0.2*speed2,100,100)/100,LFNoise0.kr(0.75*speed2,100,100)/100,SinOsc.kr(0.5*speed2,pi/2).scaleneg(0),SinOsc.kr(0.33*speed2,pi/4).scaleneg(0),Pulse.kr(0.1*speed2,pi/5).scaleneg(0)];

	fundfq = SelectXFocus.kr(LFDNoise1.kr(LFDNoise1.kr(0.5,1,1)*speed1,0.5,0.5) * randy.size,	randy,randy.size/(pres*10),true) * (fund*2)	;
	formfq = SelectXFocus.kr(LFDNoise1.kr(LFDNoise1.kr(0.5,1,1)*speed1,0.5,0.5) * randy.size,randy,randy.size/(pres*10),true) * (form*2)	;
	bwfq = LFDNoise1.kr(LFDNoise1.kr(0.5,1,1)*speed1,bw,bw);
	sig = Formant.ar(fundfq	,formfq	,bwfq);
	sig = Pan2.ar(sig, LFNoise1.kr(LFNoise1.kr(0.5*speed1).range(0.1,10)),amp);
	Out.ar(out,sig);
}).add;

)

// Organismes cheuloux

g=[]; e=[]; // < METS ça / ! ! ! \
g = g.add(Synth(\autoglob,[\argA,10.0.rand,\argB,30.rand,\argC,rrand(500,1400),\amp,0.2,\panFreq,0.05, \ampLag, 0.2]))
g.do({arg i; i.set(\amp, 0, \ampLag, 20)})
g.do({arg i; i.free}); g=[];

e = e.add(Synth(\autoformant,[\fund,100.rand,\form,600.rand,\bw,1800.rand, \amp, 0.05, \ampLag, 0.2]))
e.do({arg i; i.set(\amp, 0, \ampLag, 10)})
e.do({arg i; i.free}); e = [];



// Rand sines
(Ndef(\ff, { Mix.fill(6, {arg i;  SinOsc.ar( LFNoise1.kr( [0.125,0.025,0.0375].choose).range(106,150) + (i*4) * 5, 0)}).dup
	* Line.kr(0, 1, 60) // Attaque douce
	* 0.05 }).play)
Ndef(\ff).fadeTime = 30
Ndef(\ff).clear(10)




Ndef(\basss, { SinOsc.ar([60,55] + FSinOsc.kr(0.125,0, 4) + 10)}).play.stop

Ndef(\sub, { FreqShift.ar( Ndef(\basss), 25) * 0.5}).play
Ndef(\sub).fadeTime = 50
Ndef.clear(5)

Ndef(\klik, { Pulse.ar([0.5, 0.501], 0.2) * Saw.ar(190 * LFNoise0.kr(12.5).range(0.1,30),0.1, 1) * 0.8}).play

// Gratte et Cherche
Ndef.clear; Pdef.clear; Ndef(\rrr, { { BrownNoise.ar(LFNoise1.kr(4)) + PinkNoise.ar(LFNoise1.kr(15)) * 0.5}!2 * 0.1 + Dust2.ar(40, LFNoise0.kr(10).range(0,0.7)) }).play
Ndef(\rrr).fadeTime = 20
Ndef(\rrr).clear(0)

Ndef(\piii, {SinOsc.ar([2999, 2900, 1090, 4092, 4999]) * SinOsc.kr(0.0125) * 0.3}).play
Ndef(\piii).fadeTime = 120
Ndef(\jiii).clear(100)

Ndef(\jiii, {SinOsc.ar([3999, 4010, 4090, 4402, 4299]) * SinOsc.kr([0.0125, 0.031]) * 0.3}).play
Ndef(\jiii).fadeTime = 60

Ndef.

(Ndef(\grat, { arg amp=0.2; var sig, fm, am;
	fm = LFNoise1.kr([4, 4]) + VarSaw.kr(0.75, 0, 0.5, /*Accidents*/ 0.5, -0.5);
	sig = BrownNoise.ar(1)
	* LFSaw.kr(LFNoise1.kr(0.5).range(0.5, 6)!2)
	* (SinOsc.kr(1.2) + VarSaw.kr(1.8, 0, LFNoise1.kr(0.125).range(0.2, 0.7)) + LFPulse.kr(0.9, 0, 0.5, 2, -1))
	* LFPulse.kr(LFNoise1.kr(0.5).range(0.25, 4), 0, LFNoise1.kr(2).range(/*Densité*/ 0.09, 0.25))
	;
	sig = BPF.ar(sig, fm.range(120, 780), LFNoise1.kr([1,1]).range(0.1, 0.05), 2);
	(sig max:-0.8 min:0.8) * amp
}).play)
Ndef(\grat).fadeTime = 30
Ndef(\grat).set(\amp, 0.4)
Ndef(\grat).clear

// Droit
(Ndef(\droit, {arg freq=600, amp=0.3; var sig;
	sig = Mix.fill(5, {var f;
		f = freq * ( 1 / (7.rand + 1) + 1) * XLine.kr(0.000001, 1, 0.5);
		SinOsc.ar(f , 0,  LFNoise1.kr(Rand(0.001, 0.25)).range(0.1, 0.5))
		+ LFTri.ar(f / 2, 0, LFNoise1.kr(Rand(0.001, 0.25)).range(0.1, 0.5))
		+ LFSaw.ar(f / 3, 0, LFNoise1.kr(Rand(0.001, 0.25)).range(0.1, 0.25))
	})!2 ;
	// sig = sig * ( 1 + BrownNoise.ar());
	sig = sig * amp;
}).play)
Ndef(\droit).set(\amp, 0.2, \freq, 150)
Ndef(\droit).clear(0)
Ndef(\droit).fadeTime = 0


// Space ship
(Ndef(\rezone, { arg freq = 180, amp=0.2; var sig;
	sig = LFPulse.ar([freq, freq*1.05], 0) + LFSaw.ar(freq*1.01,0, 2, -1) * SinOsc.ar(freq*0.99, 0, LFSaw.kr(0.01), 1);
	// sig = PitchShift.ar(sig, 0.2, [0.25, 1.75], 0.05, 0.015, 1.5) + sig; // Complexifier
	sig = sig min:1 max:-1;
	// sig = sig * ( 1 + PinkNoise.ar());
	sig = sig * amp;
}).play)
Ndef(\rezone).clear(10)
Ndef(\rezone).fadeTime = 60
Ndef(\rezone).set(\freq,250, \amp, 0.1)

Pdef.clear; Ndef.clear;


// SPACE FIGHT
( Ndef(\s, {
	var sig;
	sig = {WhiteNoise.ar(0.05) / LFNoise1.ar(/*DENSITY*/ 0.5 ) }!2;
	sig = Decay2.ar(sig, 0.1001, LFNoise1.kr(4).range(0.01,0.5), SinOsc.ar( PitchShift.ar(sig,0.2, LFNoise1.kr(0.5).range(/*SPEED*/ 0.001,0.05)) * /*PITCH*/ 100 + 88, 0, 0.01));
	sig = FreeVerb2.ar( sig[0], sig[1], /*MIX*/ LFNoise1.kr(0.5).range(0,0.95), /*ROOM*/ LFNoise1.kr(0.2).range(0,0.85), /*DAMP*/ LFNoise1.kr(1).range(0,0.3));
	sig * /*AMP*/ 0.4 min:0.25 max:-0.25;
}).play)
Ndef(\s).stop(4)
Ndef(\s).fadeTime(2)

Pdef.clear; Ndef.clear;
// Chorale grenouilles
(  Ndef(\f, { var in, sig, fm, amps;
	in = WhiteNoise.ar(0.5);
	fm = {LFNoise0.kr( rrand(0.1, 0.01)).range(1, 5)};
	amps = {LFNoise1.kr( rrand(0.2, 0.4), 1, 1)};
	sig = {Mix.fill( 12, {BBandPass.ar( in, LFNoise1.kr(fm).range(1000, 3000), LFNoise1.kr(0.1).range(0.0001, /*>*/ 0.005), amps)})}!2;
	sig
}).play)
Ndef(\f).fadeTime = 10
Ndef(\f).clear(100)



// Ecoulements de Formants
(Ndef(\e, {{ var sig;
	sig = Formant
	.ar( LFNoise1.kr(0.04, 50, 160), LFNoise1.kr( LFNoise1.kr(0.25).range(0.1,/*>*/ 60), 1050, 260), 132, 0.1) * LFPulse.ar(/*>*/24, 0, 0.5, 2, SinOsc.kr( LFNoise1.kr(2, 10, 10.5)));
	sig = PitchShift.ar( sig, 0.2, sig * sig, 0.5)
}!2}).play)
Ndef(\e).fadeTime=10
Ndef(\e).stop(40)

// Nid de bébés formants
Ndef(\ee, { FreqShift.ar( Ndef(\e), -200 ) * LFSaw.ar(110,0, 0.5) * LFPulse.ar(90) }).play
Ndef(\ee).fadeTime = 10
Ndef(\ee).stop

Ndef(\ee).fadeTime = 10


Pdef.clear;Ndef.clear;
// Clik n' cut
Ndef(\aa, {arg speed=10, freq= 340; Decay2.ar( Impulse.ar( Pulse.ar), 0.001, 0.15, SinOsc.ar(freq * SinOsc.kr([2,2.1]).range(0.5, 1.5))) min:0.5 max:-0.5}).play

Ndef(\aa).fadeTime = 10;
Ndef(\aa).set(\speed, 10, \freq, 30);
Ndef(\aa).stop

