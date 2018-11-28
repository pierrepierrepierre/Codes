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


//////// FRENCH TOUR ///////////////////

(Ndef(\bass, {  arg fLag=0, fbLag=0, amp=0.15, mod=0, fmod=0;
	var freq = NamedControl.kr(\freq, 147, fLag ),
	freqB = NamedControl.kr(\freqB, 0, fbLag );
	// var sig =

	SinOscFB.ar( [138 , 122]
		* LFNoise0.kr(149).range(0.85,1)
		+ LFPulse.kr(1 * LFPar.kr(0.25).range(0.7, 1), 0, LFNoise0.kr(0.1).range(0.05, 0.33), 20 )
		,( Pulse.kr( 6 * LFNoise0.kr(0.1).range(0.1, 1) / 2) + Saw.kr(LFNoise0.kr(0.2).range(0.02, 0.4) / 3) + LFPar.kr(0.03 /2) ).range(0, 0.7) // Feedback
	)

	+ SinOsc.ar( [666, 678] * 2.5 * LFNoise0.kr(500).range(0.9, 1.5), 0, 0.1 * LFPulse.kr(LFNoise0.kr(0.004).range(0.001, 0.5)))

	// +( Mix.fill(15, {arg i; SinOsc.ar( 2+i * 88 * LFNoise0.kr(166).range(0.8, 1)) * (i+1/100) }) * (LFSaw.kr(0.3) + LFPar.kr(0.33) + LFPulse.kr(0.38, 0, LFNoise0.kr(1).range(0.1, 0.7)) ).range(0, 1) * Saw.kr(44, 0.5, 0.5))

	* (
		LFPulse.kr(1 * LFNoise1.kr(2).range(0.05, 0.5),0, LFNoise0.kr(2).range(0.5, 0.8) ).range(0.2, 1)
		+
		LFPulse.kr(3 * LFNoise1.kr(1).range(0.1, 0.5),0, LFNoise0.kr(2).range(0.8, 0.97) ).range(0, 1)
	)!2

	+ Formant.ar( 6 + Line.kr(130, 1055, 60), 390 * LFNoise1.kr(677).range(1, 7), 388, 2)


	* amp }).play)

Ndef(\bass).set(\fLag, 0, \freq, 134);
Ndef(\bass).set(\amp, 0.3)
Ndef(\bass).set(\fbLag, 20, \freqB, -10);
Ndef(\bass).set(\fmod, 10, \mod,4)
Ndef(\bass).gui

Ndef(\bass).clear(0)
Ndef(\bass).fadeTime = 0
Ndef(\bass).play


(Ndef(\bassfollower, {arg freq=620, amp=0.24, rel=0.1, rate=8;
	var sig = SinOsc.ar(freq * [1, 1.05, 1.11, 1.012, 1.213, 2.5] * In.ar(2).range(0.9, 2), pi/2) ;
	sig = sig + WhiteNoise.ar( Line.kr(0, 2, 30));
	// + LPF.ar( ClipNoise.ar(1), LFNoise1.kr(170).range(80, freq), 1 ) + SinOsc.ar([3000, 3020]/3, 0, 0.05);
	// var sig = PitchShift.ar(In.ar(2), 0.2, 1000, 10, 10);
	sig = Amplitude.ar( LPF.ar( In.ar(2)*2, 120) ) * sig;
	sig = sig + WhiteNoise.ar( Line.kr(0, 2, 30));
	sig * amp
}).play)
Ndef(\bassfollower).set(\amp, 0.1, \freq, 1820)
Ndef(\bassfollower).fadeTime = 20
Ndef(\bassfollower).clear()
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
	// Decay2.kr(Dust2.kr(0.2), 0.01, 0.1, SinOsc.ar([222, 223] * LFPulse.kr(0.4).range(1,0.66)) )
	// + SinOsc.ar(233, 0, 0.2)
	WhiteNoise.ar(0.5)
	* 0.5
}).play)


~sines.do({arg i; i.free}); ~sines = [];

Ndef(\nz, { WhiteNoise.ar( 0.1!2 ) + BrownNoise.ar( LFNoise0.kr( 1.0.rand!2).range(0, 0.1))  * 0.0 }).play
Ndef(\nz).clear(0)
Ndef(\nz).fadeTime= 20

~sines = ~sines.addAll(Synth(\cello, [\ampLag, 100, \amp, 0.075, \freq, 55 + 10.0.rand] ))

 /*CONTROL PRECIS */
~info.value(~sines)

(~sines[0
].set(
	\freq, 45
	,\freqLag, 60
	// \amp, 0.05
	// ,\ampLag, 60
))

/* BATCH CONTROL -- Freqs */
( ~sines
.do({ arg i; i.set(
	\freq, 0
	,\freqLag,40.rand
	,\amp, 0
	// ,\ampLag, 0
	// \out, ~compIn.index
)});)






