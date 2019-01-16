Ndef(\sin, {arg freq = 440, freqLag = 0, amp = 0.01, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play;
Ndef(\sin2, {arg freq = 476, freqLag = 0, amp = 0.01, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play;
Ndef(\sin3, {arg freq = 3836, freqLag = 0, amp = 0.05, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play;
Ndef(\sin4, {arg freq = 73, freqLag = 0, amp = 0.1, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play;
Ndef(\sin5, {arg freq = 83, freqLag = 0, amp = 0.1, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play
Ndef(\sin6, {arg freq = 783, freqLag = 0, amp = 0.1, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play
Ndef(\sin7, {arg freq = 793, freqLag = 0, amp = 0.2, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play
Ndef(\sin8, {arg freq = 760, freqLag = 0, amp = 0.2, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play
Ndef(\sin8, {arg freq = 3760, freqLag = 0, amp = 0.1, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play;
Ndef(\sin9, {arg freq = 3800, freqLag = 0, amp = 0.1, ampLag=0; Pan2.ar( SinOsc.ar(freq.lag(freqLag), 0, amp.lag(ampLag)), LFNoise1.kr(0.01) )}).play

(Ndef(\sin
	).set(
	\freqLag, 160
	,\freq, 802 + rrand(0, 50)
	// \ampLag, 120
	// ,\amp, 0.3
))

Ndef(\speedy, { Formant.ar(8, 1780, [600, 681], 0.5) }).play(quant:8);

Ndef(\speed, { Formant.ar(2, 3080, [600, 681]*2, 0.5) }).play(quant:8);

Ndef(\spp, { Decay2.ar( Impulse.ar(6), 0.01, 0.05, SinOsc.ar([777, 700], pi/2) * 0.5) }).stop.play(quant:8)



Ndef(\form).play
Ndef(\form).stop; Ndef(\cracks).stop; Ndef(\sin).play; Ndef(\sin2).play; Ndef(\sin3).play;


( Ndef(\fors, { var swp;
	Formant.ar( LFPar.kr(0.0007).range(120, 400), LFNoise1.kr(0.0001, pi.rand).range(810, 4300) , LFPar.kr(0.001).range(2010, 800) , {LFNoise1.kr(LFNoise0.kr(0.1).range(0.01, 0.2)).range(0.025, 0.1)}!2)
	+ Formant.ar( LFPar.kr(0.00071).range(120, 400), LFPar.kr(0.0002, pi.rand).range(800, 4300) , LFPar.kr(0.0011).range(2010, 800) , {LFNoise1.kr(LFNoise0.kr(0.1).range(0.01, 0.2)).range(0.025, 0.1)}!2)
	 *2
}).play)

Ndef(\fors).clear(30)

// NoiseCracks
(Ndef(\cracks, {arg freq=600, shift=0, amp=0.025, density=0.001, dec=0.05, bpf=280, bpw=0.5;
	var sig;
	sig = Mix.fill(5, {var f, r;
		f = freq * ( 1 / (7.rand + 1) + 1) * XLine.kr(0.000001, 1, 0.5) / 1.5;
		r = {LFNoise1.kr(Rand(0.001, 0.25)) / 4 + 0.25 };
		SinOsc.ar(f , 0,  r) + LFTri.ar(f / 2, 0, r) + LFSaw.ar(f / 3, 0, r) * 0.5;	}) ;
	sig = sig * ( 1 + BrownNoise.ar());
	sig = sig.exp.exprange / (1) * Decay.kr(Dust2.kr(density), dec) + sig; // Bourrine // Craquements
	sig = sig * Decay.kr(Dust2.kr(density * 200), dec).exp.exprange; // Craquement et souffle
	sig = FreqShift.ar(sig, shift, 0, sig);
	sig = BBandPass.ar(sig, bpf, bpw);
	sig = Pan2.ar(sig, LFNoise0.kr(100));
	sig = sig * amp;
}).play)

Ndef(\cracks).fadeTime = 0

Ndef(\cracks).set(\bpf, 620, \bpw, 0.75, \density, 0.005, \shift, 0)
Ndef(\cracks).set(\density, 0.5, \bpf, 80, \bpw, 1)
Ndef(\cracks).set(\density, 0.125, \bpf, 480, \bpw, 1)
Ndef(\cracks).set(\amp, 0.05)
Ndef(\cracks).stop.clear

Ndef(\filt, { }).play
Ndef(\bpw, { }).play
Ndef(\shift, { LFSaw.kr(0.001, 1).range(-100, 10000)}).

Ndef(\cracks).map(\bpf, Ndef(\filt), \bpw, Ndef(\bpw), \density, 4, \shift, Ndef(\shift))
Ndef(\cracks).set(\shift, 1500)


Ndef(\cracks).lag(\bpf, 120)
Ndef(\cracks).set(\bpf, 1700)
Ndef(\cracks).lag(\shift, 100)
Ndef(\cracks).play
Ndef(\cracks).stop
Ndef(\cracks).fadeTime = 200
Ndef(\cracks).set(\amp, 0)


// BassPlops
(Ndef(\duum, { var sig =
	SinOscFB.ar( 125 * SinOsc.kr([10,10.1] * 3) ) * Decay2.kr( Impulse.kr([0.333, 0.25]) + Impulse.kr(2, 0, 0.1 ), 0.01, LFNoise1.kr(0.01).range(0.25, 1.5) );
	sig;
}).play)
Ndef(\duum).stop.clear
Ndef(\duum).fadeTime = 0


// Blips & Bleed
(Ndef(\bleep, { arg shift =1; var sig;
	sig = Formant.ar( 10 * SinOsc.kr(0.1, 0, 1, Pulse.kr(0.8)) * LFPulse.kr( 1 , width:0.66), 289 * SinOsc.kr(20.1), 1880 * SinOsc.kr(0.12) + 100) * 0.2!2;
	sig = Formlet.ar( ClipNoise.ar(sig * LFNoise0.kr(20)), LFNoise2.kr(200, 2000, 2000 + Pulse.kr(LFNoise0.kr(0.01).range(0.01,0.3), 0.1, 2000,LFNoise0.kr(27).range(2000,4000))), 0.001,0.005) * LFPulse.kr( LFNoise0.kr(2,0.5,0.5)) + sig;
	sig = PitchShift.ar(sig, 0.2, LFNoise0.kr(16, 0.25,0.25) * shift) * LFPulse.kr( LFNoise0.kr(2).range(0.2, 17), 0, 0.25, 1,1);
}).play)
Ndef(\bleep).clear
Ndef(\bleep).lag(\shift, 1400)
Ndef(\bleep).set(\shift, 0)
Ndef(\bleep).play


(Ndef(\cress, {arg freq= 0, amp=0.5;
	var rand, sig;
	rand = TRand.kr(0,10, Impulse.kr(freq));
	sig = Mix.fill(4, {arg i; SinOscFB.ar( ( i+1* (33 + rand) + 1020) * 5, 0.2, 0.2 )});
	sig = sig * LFPar.kr( {LFNoise1.kr(2).range(0, 10.5) }!2);
	Pan2.ar(sig * amp);
}).play)
Ndef(\cress).set(\freq, 20)
Ndef(\cress).set(\amp, 1)
Ndef(\cress).fadeTime=90
Ndef(\cress).clear

~gfree.(); ~nstop.(); Synth.new("snare", [\amp, 1, \rel, 0.0125,\att, 0.0001, \pan,0, \relC, 3, \fq, 335, \cutoff, 0.0125]);

(Ndef(\form, { arg freq = 2.0;
	Formant.ar( LFNoise1.kr(0.1).range(10,60), LFNoise1.kr({freq * 1.0.rand}!2).range(2000, 5000), LFNoise1.kr({freq * 1.0.rand}!2).range(3200, 10000)) * 0.15
	+ Formant.ar( 30 + LFSaw.kr( LFNoise0.kr(1!2).range(0.02, )).range(-10, 0), 2220, 808 * LFNoise2.kr(0.16!2).range(10,50), 2) * 0.5
	// + SinOscFB.ar([57, 46]  + 34 + (LFNoise1.kr(0.01).range(5, 10)), LFSaw.kr(0.001,1).range(0,1.5), 2.5) // BASSE
	+ SinOsc.ar(5000 + [0, 286] , 0, 0.4) // HiFreq
	// + ClipNoise.ar( LFSaw.kr(0.0125, 1).range(0,1.5) ) // Marées NOISE

	+ DelayC.ar(
		SinOscFB.ar( 3888 + LFNoise0.kr(100!2).range(0,200), LFNoise0.kr(20!2).range(0, 3), 0.2 )
		+ Pulse.ar(267 * LFNoise0.kr(300).range(0.2,1))
		+ ClipNoise.kr(0.85)
		+ SinOsc.ar(5000 + LFNoise0.kr(100).range(0, 1000), 0, LFNoise0.kr(100).range(0, 0.3))
		+ SinOsc.ar(LFNoise0.kr(LFNoise0.kr(0.5).range(0.5, 3)).range(400, 1000) + LFNoise0.kr(100).range(0, 500), pi/2, LFNoise0.kr(100).range(0, 0.7))
		, 0.2, 0 , 0
		+ 1 // BRUTAL NOISE
	)

	* Saw.ar(2666  * LFNoise1.kr( Line.kr(1, 500, 200) )  ) // CONTIENT la NOISE
	// * 0
}).play )

Ndef(\form).play.clear
Ndef(\form).set(\freq, 10)

Ndef(\taze, { ClipNoise.kr( )})


( // Pdef.clear; Ndef.clear;
Ndef(\fizz, {
	Formant.ar( 1020 + LFNoise1.kr([0.5, 0.5]).range(0,60), 7222 + LFNoise1.kr(60).range(0,1300), LFNoise2.kr(100).range(10,1000) ) * 0.1
	+ Formlet.ar(WhiteNoise.ar(0.25), [3020, 3080], 0.2, LFNoise1.kr(100).range(0.01,0.07), 0.5)
	+ SinOscFB.ar(1664 * LFNoise1.kr(77).range(0.95,1), LFSaw.kr(0.1 + LFPulse.kr(0.5),1, 0.5, 0.5), 1.5)
	+ BrownNoise.ar(LFSaw.kr(0.1 + LFPulse.kr(0.5),1, 0.5, 0.5) )
	* (0.1)
}).play)

Ndef(\fizz).clear(40);
Ndef(\form).stop; Ndef(\s).stop; Ndef(\fizz).clear;

Ndef(\t, {ClipNoise.ar() + WhiteNoise.ar() + BrownNoise.ar() * Line.kr(0, 2, 60)!2 }).play


// SPACE FIGHT
(Ndef(\s, { arg /*AMP*/ amp=0.1, dens=0.05;
	var sig;
	sig = {WhiteNoise.ar(0.05) / LFNoise1.ar(/*DENSITY*/ dens )}!2;

	sig = Decay2.ar(sig, 0.1001, LFNoise1.kr(4).range(0.01,1), SinOsc.ar( PitchShift.ar(sig,0.2, LFNoise1.kr(0.5).range(/*SPEED*/ 0.001,0.5)) * /*PITCH*/ 100 + 88, 0, 0.01));

	// sig = FreeVerb2.ar( sig[0], sig[1], /*MIX*/ LFNoise1.kr(0.5).range(0,0.95), /*ROOM*/ LFNoise1.kr(0.2).range(0,0.25), /*DAMP*/ LFNoise1.kr(1).range(0,0.5));
	sig = sig + DelayC.ar( [ sig[1] , sig[0]], 0.1, 0.05, LFSaw.kr(0.5).range(0.01,0.1));

	// sig = sig / 4 ;
	// * amp min:0.25 max:-0.25;
	// /*TO COMPRESSEUR*/ Out.ar([0, ~compCtrl.index], sig);
	sig * amp
}).play)
Ndef(\s).play
Ndef(\s).set(\amp, 0.15, \dens, 0.1)
Ndef(\s).stop.clear

Ndef(\basse, { SinOsc.ar( Line.kr(50, 200, 30)!2, 0, 0.5)}).play


(SynthDef(\hit, {arg amp=0.1;
	var sig =
	Env.perc(Rand(0.01,0.05), Rand(0.01,0.25)).kr(2) * (BrownNoise.ar(SinOsc.kr([40, 45]*10)/SinOsc.kr(0.1,pi/2) * LFPulse.kr(1,0,0.1)) + Decay2.kr(Dust.kr(10), 0.01,0.05, SinOsc.ar({Rand(6100,2000)}!4)) ) * (10*amp);
	Out.ar(0, sig);
}).add )

Pbindef(\h, \instrument, \hit, \dur, Prand([3, 2],inf), \amp, 0.1 ).play
Pbindef(\h).stop


~info = {arg group; group.size.do({arg i; group[i].get(\freq, {arg val; (i+"").post; val.post;}); group[i].get(\amp, {arg val; " : ".post; val.round(0.001).postln})})};

x = []
x = x.addAll({arg freq=66, amp=0.35, freqLag=0.1, ampLag=0.1, pan=0, panLag=0.1; Pan2.ar(SinOsc.ar(freq.lag(freqLag)), pan.lag(panLag), amp.lag(ampLag))}.play)

~info.(x)

(x[4
].set(\freq, 180.2, \freqLag, 120
))

x.do({arg i; i.set(\freqLag, 120+10.0.rand, \freq, 10020 + 100.0.rand) })
x.do({arg i; i.set(\ampLag, 0, \amp, 0.1)})
x.do({arg i; i.set(\panLag, 3, \pan, 1.0.bilinrand)})
x.do({arg i; i.free}); x=[];