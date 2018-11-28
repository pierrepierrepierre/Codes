s.boot;

{SinOsc.ar(80).softclip * 0.2}.play


(
b = Bus.control(s, 1); b.set(0);
c = Bus.control(s, 1);    c.set(0);

SynthDef("cello", {
	arg out=0, att=0.2, rel=0.2, gate=1, ampLag=0.5, freqLag=0, panLag=0, panMod=0, panFreq=0.5;
	var env, sig;

	var freq = NamedControl.kr(\freq,440,freqLag);
	var pan = NamedControl.kr(\pan,0,panLag);
	var amp = NamedControl.kr(\amp,0.05,ampLag);
	var pano = FSinOsc.kr(panFreq,0,panMod,pan);

	env = Env.asr(att, 1, rel).kr(0, gate);
	sig = SinOsc.ar(freq, 0, env * amp  / (freq.log/4) );
	sig = Pan2.ar(sig, pano);
	Out.ar(out, sig);
}).add;

SynthDef("fmcello", {
	arg out=0, att=0.2, rel=0.2, gate=1, ampLag=0.5, freqLag=0, panLag=0, panMod=0, panFreq=0.5, fm=7, qt=0;
	var env, sig;

	var freq = NamedControl.kr(\freq,440,freqLag);
	var pan = NamedControl.kr(\pan,0,panLag);
	var amp = NamedControl.kr(\amp,0.05,ampLag);
	var pano = FSinOsc.kr(panFreq,0,panMod,pan);

	env = Env.asr(att, 1, rel).kr(0, gate);
	sig = SinOsc.ar(freq * LFSaw.kr(fm, 1, qt,1), 0, env * amp  / (freq.log/4) );
	sig = Pan2.ar(sig, pano);
	Out.ar(out, sig);
}).add;



SynthDef("mousecello", {
	arg out=0, att=0.2, rel=0.2, gate=1, ampLag=0.5, freqLag=0, panLag=0, panMod=0, panFreq=0.5;
	var env, sig, vol;

	var freq = NamedControl.kr(\freq,440,freqLag);
	var pan = NamedControl.kr(\pan,0,panLag);
	var amp = NamedControl.kr(\amp,0.05,ampLag);
	var pano = FSinOsc.kr(panFreq,0,panMod,pan);

	vol = MouseY.kr(0.00000001,1);
	env = Env.asr(att, 1, rel).kr(0, gate);
	sig = SinOsc.ar(freq, 0, env * amp  / (freq.log/4) * vol );
	sig = Pan2.ar(sig, pano);
	Out.ar(out, sig);
}).add;

SynthDef("dxcello", {
	arg out=0, ampLag=0, att=0.2, sus=1, rel=0.2, freqLag=0, gate=1, panLag=0, harm=0, nb=0, dxLag=0.5;
	var env, sig, vol, max, min, focus, dxl, freq, pan, amp, dx;
	freq = NamedControl.kr(\freq,220,freqLag);
	pan = NamedControl.kr(\pan,0,panLag);
	amp = NamedControl.kr(\amp,0.1,ampLag);
	dx = NamedControl.kr(\dx,0.1,dxLag);

	focus = MouseX.kr(1.0,-1);
	dxl = Lag.kr(dx, 0.5); min = SinOsc.kr(freq/2, 0, dxl, 1); max = SinOsc.kr(freq/3, 0, dxl, -1); // disto
	vol = MouseY.kr(0.00000001,1) * MouseX.kr(1.0, 0.66);
	env = Env.asr(att, sus, rel).kr(0, gate);
	sig = [
		SinOsc.ar(freq),
		SinOsc.ar(freq * LFNoise1.kr(0.02).range(0.8,0.9)),
		LFSaw.ar(freq*LFNoise1.kr(0.01).range(1,1.2), pi/3.3),
		LFPulse.ar(freq*LFNoise1.kr(0.03).range(1.2,1.3)) * 0.8,
		LFSaw.ar(freq*2) * SinOsc.ar(freq*1.8) * LFPulse.ar(freq*3) * 0.75,
		LFSaw.ar(freq*LFNoise1.kr(0.015).range(1.5,1.6)) * 0.8,
		LFTri.ar(freq*LFNoise1.kr(0.012).range(2.5,2.6)) * 0.6
	];
	sig = sig min:min max:max ;
	sig = SelectXFocus.ar(0, sig, focus, true);
	sig = LPF.ar(sig, freq*6);
	sig = Pan2.ar(sig, pan);
	sig = sig * env * amp * vol ;
	Out.ar(out, sig);
}).add;

~info = {arg group; group.size.do({arg i; group[i].get(\freq, {arg val; (i+"").post; val.post;}); group[i].get(\amp, {arg val; " : ".post; val.round(0.001).postln})})};

~free = {arg group; group.size.do({arg i; group[i].free;})};
~set = {arg group, args; group.size.do({arg i; group[i].set(args.envirPairs);}) };

)

// PLAY CELLOS in group
~cell = ~cell.addAll(Synth("cello", [\amp, 0.1, \att, 10, \freq, 160 , \gate, 1 ]))

// set ONE
~info.(~cell)


(~cell[0
].set(
	// \gate, 1,
	\freqLag, 1, \freq, 17000,
	// \ampLag, 10, \amp, 0.25
))

~cell[0].release
~cell[0].set(\gate, 1, \att, 0.4, \freqLag, 5, \freq, 280 * 0)

// set ALL
~cell.do({arg i; i.release})
~cell.do({arg i; i.set(\gate, 1)})
~cell.do({arg i; i.set(\amp, 0.23)})


~free.(~cell); ~cell=nil;

// CELLO with Harmonics
x.free; x = Synth("dxcello",[\amp, 0.015, \freq, 372])
x.set(\dxLag, 10, \dx, 0)
x.set(\freqLag, 0, \freq, 89, \amp, 0.1)
x.set(\ampLag, 10, \amp, 0.3)
x.free

y.free; y = Synth("mousecello",[\amp, 0.1, \freq, 65])
y.set(\freqLag,10, \freq, 80)
y.set(\ampLag, 30, \amp, 0.5, \rel, 5)
y.set(\)
y.release
y.set(\gate, 1)

// NDEFS

Ndef(\lf, {SinOsc.ar([180, 175] - 80.rand, 0, 0.15) + SinOsc.ar(135, 0, 0.05) * Pan2.kr(1, LFNoise1.kr(2).range(-1, 1))}).play
Ndef(\lf).fadeTime = 20
Ndef(\lf).clear(50)

Ndef(\hi, {arg freq=1; SinOsc.ar(1 * LFNoise1.kr(28) + 800 + freq, 0, 0.1) }).play
Ndef(\hi).fadeTime=20
Ndef(\hi).set(\freq, 130)
Ndef(\hi).clear

Ndef(\arc, {RLPF.ar( SinOsc.ar( Saw.kr(1) + LFNoise1.kr(134) * [20, 400] + 80, 0,0.2), [120, 220],0.25,0.4 )}).play
Ndef(\arc).fadeTime = 10
Ndef(\arc).stop

Ndef(\rac, {SinOsc.ar( LFNoise1.kr([134, 200, 200, 1000]) * [20, 60, 80, 100] + [80, 600, 1260, 2800] * Rand(0.5, 3), 0,[0.3, 0.15, 0.1, 0.0125])!2 * LFSaw.kr(0.175) * LFSaw.kr(LFNoise1.kr(1))})

Ndef.clear(10)

{LFSaw.ar(40)}.plot(0.5)


Ndef(\bb, {arg fb=0, amp=0.3; SinOscFB.ar([40, 38], fb * LFPar.kr( LFNoise0.kr(0.125).range(0.125, 0.75) ), amp) }).play
Ndef(\bb).set(\fb, 1, \amp, 0)

Ndef(\b, {arg amp=0.2, fb=0; SinOsc.ar([79, 72] * LFSaw.kr(34, 1, fb)) * amp }).play
Ndef(\b).set(\amp, 0.2, \fb, 1.5)
Ndef(\b).clear

Ndef(\zz, { Mix.fill(5,{ SinOsc.ar(rrand(150,8480),0, 1/5)}) * LFNoise1.kr([2,3]).range(0,0.25) }).play
Ndef(\zz).fadeTime=20
Ndef(\zz).fadeTime = 10
Ndef(\zz).clear(0)
Ndef(\zz).stop(10)

/* Vent desert */
Ndef(\u, { BPF.ar( BrownNoise.ar( LFNoise1.kr(16).range(0,0.85)), 240 * LFNoise1.kr(0.008).range(0.5,1), LFNoise1.kr(18).range(0.01,0.045)!2 ) * 5}).play
Ndef(\u).fadeTime = 2
Ndef(\u).stop.clear()

/* Pulsed noise */
(Ndef(\wht, {
	var sig ;
	sig = SinOsc.ar(78, pi/2) + SinOsc.ar(200 * LFPar.kr( LFNoise1.kr(0.25).range(0.00125,0.01)).range(1,3), 0, 0.3 ) + BrownNoise.ar() * LFNoise1.kr(4,0.2)  ;
	sig = Formlet.ar( sig, 1300 * LFTri.kr(0.125).range(1,1.2), 0.001, 0.01, LFNoise1.kr(0.2).range(0.1, 0.3));
}).play)
Ndef(\wht).fadeTime = 20
Ndef.clear(40)

y.free

x.release
x.set(\gate, 1)

/* ON / OFF noise */
j.free; j = {arg amp=0.1; LFPulse.ar(0.6, 0, 0.1, BrownNoise.ar(amp) + SinOsc.ar(4000, 0, 0.01)*  LFNoise1.kr(0.5).range(0.9, 1.1), 0.02)!2}.play
j.set(\amp, 0.2)
j.free

// Play ONE CELLO
x.free; x = Synth.new("cello", [\amp, 0.2, \freq, 75])
x.set(\gate, 0, \rel, 1)
x.set(\freqLag, 20, \freq, 60, \gate, 1)

x.release

/*D*/ x.set(\gate, 1, \freq, 149)
/*C*/ x.set(\gate, 1, \freq, 120)
/*F*/ x.set(\gate, 1, \freq, 93)
/*A*/ x.set(\gate, 1, \freq, 230)
/*E*/ x.set(\gate, 1, \freq, 75)
x.release

x.set(\rel, 1.5, \att, 1.5, \amp, 0.4, \freqLag, 0.75)
x.set(\freqLag, 1.5, \ampLag,5, \amp, 0.5)

y = Synth.new("cello", [\amp, 0.2, \freq, 158, \att, 0, \rel, 1])
y.set(\gate, 1, \freqLag, 2, \freq, 68)
y.release

x.release; y.release

// FM Cello
Ndef(\t).clear; z.free; z = Synth("fmcello", [\amp, 0.2, \freq, 85, \att, 6])
z.set(\panMod, 0.4, \panFreq, 1)
z.set(\ampLag, 10, \amp, 0)

x.free; x = Synth("fmcello", [\amp, 0, \freq, 80, \qt,0, \fm, 13, \pan, 0, \panLag, 20, \panMod, 0, \panFreq, 1.74])
y.free; y = Synth("fmcello", [\amp, 0, \freq, 76, \qt,0, \fm, 13, \pan, 0, \panLag, 20, \panMod, 0.5, \panFreq, 1.74])
z.free; z = Synth("fmcello", [\amp, 0.02, \freq, 389, \qt, 0])
w.free; w = Synth("fmcello", [\amp, 0.005, \freq, 719, \qt, 0])

x.set(\ampLag, 80, \amp, 0, \freqLag, 40, \freq, 40)
y.set(\freqLag, 30, \freq, 233, \qt, 0.02, \ampLag, 10, \amp, 0.075)
y.set(\amp, 0, \ampLag, 30, \freqLag, 160, \freq, 40)

w.set(\ampLag, 0, \amp, 0.01, \freqLag, 0, \freq, 2090, \qt, 0, \fm, 0.01)
z.set(\amp, 0.01, \ampLag, 1, \qt, 0.000, \freqLag, 0, \freq, 2130)


//// NO NOISE

(Ndef(\t, { arg amp=0.1, pan=0;
	var sig, bow;
	bow = LFPar.kr(3 * LFNoise1.kr(4).range(0.5,1.5)).range(0,1)
	* LFPulse.kr(0.75 * LFNoise1.kr(5).range(0,1.75)).range(0.5,1.5)
	* LFPulse.kr(0.75 * LFNoise1.kr(1).range(0, 2.5),1).range(0.5, 2)
	;
	sig =
	SinOscFB.ar(
		[[55, 62], [139, 145]],
		bow.range( LFNoise1.kr(1).range(0.4, 0.8) , LFNoise1.kr(1).range(0.6, 0.9)) , // fb
		bow * 0.1 + 0.75
		+ RLPF.ar( BrownNoise.ar(0.6 * LFNoise1.kr(0.6) * bow.range(0,1) ), /*FREQ*/ 430, 0.1 + LFNoise1.kr(7).range(-0.09,0.5))
		+ SinOsc.ar([210, 218] /*FREQ*/ * 5 , 0, bow.range(0.8,0.2) * LFNoise1.kr(54))
	)

	// add Saw and Pulse, filtered : Vent du desert
	+ RLPF.ar( Saw.ar(55 + LFPulse.kr(0.12, 0, 0.2).range(0 ,250)) + Pulse.ar(55 + LFPulse.kr(0.16, 0, 0.2).range(0 ,150) + LFNoise1.kr(0.7).range(-6,6)), {LFNoise1.kr(17).range(300, 380)}!2, LFPulse.kr(0.33, 2.0.rand).range(0.5,0.1) + LFSaw.kr(0.335, 2.0.rand).range(0.5,0.1), 0.9)

	// Extra bass
	+ SinOsc.ar(37 + LFPulse.kr(0.05, 0, 0.33).range(0, 140), pi/2, 1)
	;
	// Resonnace hi freq
	sig = RLPF.ar(sig, [689, 730] + LFSaw.kr(0.012).range(0, 450), 0.01 * bow.range(1,5));

	// Mediums harmoniques digitales
	sig = Mix.fill(80, {arg i; SinOsc.ar(100 * (1 + (i*0.95)) + (LFNoise1.kr(0.1.rand) * bow.range(2,LFNoise2.kr(1.0.rand).range(0, i*rrand(1,10.02) ) ) ), pi.rand, 1/(i*i/(2+(i*0.5.rand))+1)) }) * bow.range(LFNoise1.kr(0.01).range(0.2,0.5),1) + sig;

	// Perturbations
	sig = BBandStop.ar(sig, TRand.kr(600, 2300, Dust.kr(3)), LFNoise1.kr( /*DEV SPEED*/ 3).range(0.001,7.0), 1.2);

	// Psycho high
	sig = sig + SinOsc.ar( [1000, 1040*LFPar.kr(18).range(0.9,1.3)] * 2, 0, 0.6 + LFNoise1.kr(16).range(-0.2,0.2));

	// A bit of noise
	sig = sig + Formlet.ar(WhiteNoise.ar(sig), 637, 0.001, LFNoise1.kr(0.01).range(0.01,0.1), 0.1);

	// Aluminium
	sig = Formlet.ar( WhiteNoise.ar(sig), LFNoise1.kr(1).range(1500, 1200) + Line.kr(0, 2000, 30), 0.0001, LFNoise1.kr(0.1).range(0.005,0.01), 0.15) * 0.35 + sig;

	// Harsh High
	sig = WhiteNoise.ar(sig * LFNoise1.kr( LFNoise1.kr(0.15).range(3, 30) ) )  + SinOsc.ar([3677, 3722],0, bow) * 0.035 + sig ;

	// sig = SinOsc.ar([1448, 1481] * LFSaw.kr(16).range(1,1.1), 0, LFNoise1.kr( bow.range(0.1,15)).range(0.05,0.4) ) + sig;

	Pan2.ar(sig, pan, amp);
}).play
)

Ndef(\t).set(\amp, 0.14)
Ndef(\t).fadeTime = 0
Ndef(\t).stop
Ndef(\t).clear

Ndef(\cc, {SinOsc.ar(70 + Line.kr(0, 300, 40), 0, 0.25 ) * Line.kr(1, 0, 60)!2 }).play;
Ndef(\bb, {SinOsc.ar(80 + Line.kr(0, 300, 30), pi/2, 0.25 ) * Line.kr(1, 0, 60)!2}).play;
Ndef(\bb).fadeTime= 0.1
Ndef(\bb).stop

Ndef(\gg, { SinOsc.ar( [82.2, 67] ) * 0 }).play
Ndef(\gg).fadeTime = 10
x.free
//////// FRENCH TOUR ///////////////////

(Ndef(\bass, {  arg fLag=0, fbLag=0, amp=0.2, mod=0, fmod=0;
	var freq = NamedControl.kr(\freq, 147, fLag ),
	freqB = NamedControl.kr(\freqB, 0, fbLag );
	// var sig =
	// freq = freq + Line.kr(0, 200, 30);
	SinOsc.ar( [freq + freqB.neg, freq + freqB] * LFNoise1.kr(17).range(0.8, 1.6)) * LFPulse.kr( LFNoise0.kr( LFNoise0.kr(1).range(0.5, 10) ).range(0, fmod), 1, 0.9, mod,1 )
	+ BrownNoise.ar(LFNoise1.kr(20).range(0.1, 1) * SinOsc.kr(1 * LFNoise1.kr(1)))
	+ VarSaw.ar( LFNoise0.kr(18).range(0.5, 190), 0, LFNoise1.kr(178), 2)
	+ SinOsc.ar( 400 * SinOsc.kr(173).range(0.7, 1.5), 0, 0.575)
	+ SinOscFB.ar([99, 88] * Line.kr(1, 10, 30), Line.kr(0, 3, 10), 3)
	+ SinOsc.ar([2568, 2690] + 1000 * LFSaw.kr( [0.1, 0.08] / LFNoise1.kr(3).range(0.2, 1), [0, 1]).range(0.9, 1.2) + 100 , 0, LFNoise1.kr(10!2).range(0, 0.25) * 3)
	+ SinOsc.ar(30 * [10.333, 10.34] * LFSaw.kr( LFNoise0.kr(3).range(10, 158)).range(0.8, 1), 0, LFNoise1.kr([50, 126]).range(0, 0.25) ) * 2
	+ Formant.ar( 74, 177  * LFNoise0.kr(0.09).range(0.5, 1) + Saw.kr(177 + SinOsc.kr(0.01).range(0, 200), 0.5), [66, 68.8] * 5 * LFNoise0.kr(0.27).range(0.5, 2) )
	* SinOsc.ar( [freq*100, freq*110], 0, 0.6, 1)
	* amp }).play)

Ndef(\bass).set(\fLag, 0, \freq, 134);
Ndef(\bass).set(\amp, 0.17)
Ndef(\bass).set(\fbLag, 20, \freqB, -10);
Ndef(\bass).set(\fmod, 10, \mod,4)
Ndef(\bass).gui
Ndef(\bass).clear(0)
Ndef(\bass).fadeTime = 0
Ndef(\bass).play


(Ndef(\bassfollower, {arg freq=620, amp=0.24, rel=0.1, rate=8;
	var sig = SinOsc.ar(freq * [1, 1.05, 1.11, 1.012, 1.213] * In.ar(2).range(0.9, 2), pi/2)
	+ LPF.ar( ClipNoise.ar(1), LFNoise1.kr(170).range(80, freq), 1 ) + SinOsc.ar([3000, 3020]/3, 0, 0.05);
	// var sig = PitchShift.ar(In.ar(2), 0.2, 1000, 10, 10);
	sig = Amplitude.ar( LPF.ar( In.ar(2)*2, 120) ) * sig;
	sig * amp
}).play)
Ndef(\bassfollower).set(\amp, 0.15, \freq, 620)
Ndef(\bassfollower).fadeTime = 20
Ndef(\bassfollower).clear(10)
Ndef(\bassfollower).play


(Ndef(\nz, { arg amp=0.2, freq=440;
	var sig = Saw.ar(freq * SinOsc.kr(5.55 * LFNoise1.kr(0.2) ) ) + LFPar.ar(freq*1.33) * VarSaw.kr(1, 0, Saw.kr(0.2).range(0.01, 0.8));
	sig = sig + Mix.fill(4, {SinOsc.ar( 300 + Rand(0,700.0), 1/8)});
	// sig = PitchShift.ar(sig, 0.2, Saw.kr(0.2).range(250, 0), 25, 2);
	sig = sig * Pulse.kr(0.25 , 0.1).range(0, 1) * PinkNoise.kr(0.7);
	sig = sig min:0.5 max:-0.5 * amp;
	Pan2.ar(sig, LFNoise0.kr(22));
}).play)
Ndef(\nz).play.stop
Ndef(\nz).set(\amp, 0.5)
Ndef(\nz).fadeTime= 20


(Ndef(\u, {
	Decay2.kr(Dust2.kr(0.2), 0.01, 0.1, SinOsc.ar([222, 223] * LFPulse.kr(0.4).range(1,0.66)) )
	// + SinOsc.ar(233, 0, 0.2)
	* 0.5
}).play)

//// FREQ SOLO //////


// PLAY CELLOS in group
~cell = ~cell.addAll(Synth("cello", [\amp, 0.03, \att, 0.1, \freq, 89.9 , \gate, 1 ]))

// set ONE
~info.(~cell)


(~cell[1
].set(
	// \gate, 0,
	\freqLag, 300, \freq, 30,
	\ampLag, 20, \amp, 0.2
))

~cell[0].release
~cell[0].set(\gate, 1, \att, 0.4, \freqLag, 5, \freq, 280 * 0)

// set ALL
~cell.do({arg i; i.release})
~cell.do({arg i; i.set(\gate, 1)})
~cell.do({arg i; i.set(\ampLag, 40, \amp, 0)})


~free.(~cell); ~cell=nil;




[x, y].do({arg i; i.release})

~freq = {[141, 122, 74].choose}

// AUTO CELLO //
(y.stop; y = Task({{
	// x.set(\gate, 0);
	// ~cell.do({arg i; i.release});
	~cell[~cell.size.rand].release;
		3.0.wait;
	// x.set(\gate, 1, \freq, 60 + 40.rand);
	// ~cell.do({arg i; i.set(\gate, 1)});
	~cell[~cell.size.rand].set(\gate, 1);
		10.wait;
	}.loop
}).play)

y.stop; x.release
y.play
y.reset

// Noise impactes pic-verts
v.free; v = { { RLPF.ar( SinOsc.ar((80 + 20.rand * LFSaw.kr(17).range(1,1.1)).postln, pi/2, Decay.kr(Impulse.kr(LFNoise1.kr(0.5).range(0.4, 0.08)), 2, 0.3)), 800, 0.5)  }!2}.play;
v.free

/* Cluster */
u = {{XLine.kr(0.2.rand, 0.0001,  Rand(1,5), LPF.ar(SinOsc.ar(60 + 30.rand), 133, 3 ) + RLPF.ar( BrownNoise.ar(LFPulse.kr(LFNoise1.kr(1).range(0.4,2),0, 0.5.rand)), 1800, 3.5), 0, 2)}!2}.play


// NOISE random start & stop//
(n.stop; n = Task({{
		o = {{XLine.kr(0.05, 0.1,  Rand(0.2,1.2), BrownNoise.ar( LFPulse.kr(LFNoise1.kr(5).range(1.0,18)) + Saw.kr(2) ) + SinOsc.ar([1720, 945], 0, 0.5), 0, 2)}!2}.play;
		rrand(1.0, 5).wait;
	}.loop
}).play)

n.stop
n.play
n.resume


// DOUCHE CONTINUE //
(Ndef(\wh, {{ BPF.ar( PinkNoise.ar(1 * (SinOsc.kr(0.01).range(0,05))),
	/*freq*/ 80 + 1200.rand,
	/*rq*/ 0.5,
	/*amp*/ 0.5
)}!2}))

Ndef(\wh).fadeTime=2
Ndef(\wh).stop
Ndef(\wh).play
Ndef.clear

u = Synth.new("cello", [\amp, 0.1, \freq, 659*1])
u.set(\amp, 0, \ampLag, 10)
u.set(\freq, 659/4, \freqLag, 100)
u.free


x = Synth.new("cello", [\amp, 0.2, \att, 1, \freq, 78])
y = Synth.new("cello", [\amp, 0.05, \freq, 220 * 0.5, \att, 3, \rel, 3])
x.set(\rel, 0.5, \att, 4)

x.release
x.set(\gate, 1, \freq, 57)
x.set(\amp, 0.03)

y.release
y.set(\gate, 1, \freq, 355 * 0.4)
y.set(\amp, 0.05)


/// GROUP CELLOS ///

/* BATCH MAKE */
( ~sines.do({arg i; i.free}); ~sines = 3.collect({arg i; Synth(\cello,[
	\freq,rrand(2060,5500).postln
	,\freqLag,0.025
	,\panLag,20
	,\pan,1.0.bilinrand
	,\amp,0
	,\ampLag,0.1
])}))

/* BATCH CONTROL -- Entrée */
( ~sines
.do({ arg i; i.set(\dum,0
	,\freq,exprand(100,520.0)
	,\freqLag,0.05
	,\pan,1.0.bilinrand
	,\panMod,0
	,\amp,0.12
	,\ampLag,0.1
)});)

/* CONTROL AU HASARD -- Panoramique modulation */
~sines[~sines.size.rand.post].set(\pan, 0, \panMod, 1.0.rand, \panFreq, 0.5.rand.postln)

/* ADD */
~sines = ~sines.addAll(Synth(\cello, [\ampLag, 100, \amp, 0.1, \freq, 750 + 20.0.rand] ))

 /*CONTROL PRECIS */
~info.value(~sines)

(~sines[1
].set(
	\freq, 60 + 10.rand
	,\freqLag, 178
	,\amp, 0.5
	,\ampLag, 30
))

/* BATCH CONTROL -- Freqs */
( ~sines
.do({ arg i; i.set(
	// \freq,exprand(110,220/4)
	// ,\freqLag,30
	\amp, 0
	,\ampLag, 20
	// \out, ~compIn.index
)});)

/// NEW Instrument DIGI Cello


