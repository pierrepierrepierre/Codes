(SynthDef(\kick, {arg out=0, att=0.01, sus=0, rel=0.05, amp=0.1;
	var sweep, sig, env;
	env = Env([0, 1, 1, 0], [att, sus, rel]).kr(2);
	sweep = Env([3000, 280, 40], [0.01, rel], [4, -12]).kr(0);
	sig = SinOsc.ar(sweep, pi/2) + Pulse.ar(sweep, 0.5, 2);
	sig = sig * env * amp;
	Out.ar(out, [sig, sig]);
}).add;)

(SynthDef(\hat, {arg out=0, att=0.01, sus=0.0, rel=0.05, amp=0.1;
	var sig, env;
	env = Env([0, 1, 1, 0], [att, sus, rel]).kr(2);
	sig = WhiteNoise.ar() + BrownNoise.ar() + PinkNoise.ar();
	sig = BPF.ar(sig, 888, 0.4,2)!2;
	// sig = sig + Formant.ar(TempoClock.tempo*4, 2800, 60, 1);
	sig = Mix.fill(4, { SinOsc.ar( Rand(444, 1288) * [1, 1.05], pi/2, 1/2)})!2 + WhiteNoise.ar(0.4);
	// sig = Pulse.ar(LFNoise0.ar(300).range(2444, 3000), 0.2, 2);
	// sig = SinOsc.ar([1666, 1656], pi/2) * 0.5;
	sig = sig * env* amp;
	Out.ar(out, sig);
}).add;)

(SynthDef(\snare, {
	arg out=0, att=0.01, sus=0, rel=0.4, amp=0.1;
	var sig, env;
	env = Env([0, 1, 1, 0], [att, sus, rel]).kr(2);
	sig = WhiteNoise.ar(0.5!2) + Mix.fill(6, { SinOsc.ar(LFNoise0.kr(500).range(255, 3733), pi/2) * 1/4 });
	// sig = Pulse.ar( LFNoise0.kr(Rand(40, 500)).range(300, 1600), 0.4!2) + BrownNoise.ar( Line.kr(0,2, sus+rel)) + sig;
	// sig = PitchShift.ar(sig, 0.5, Line.kr(0, 500, 0.5), 0.2);
	sig = sig * env* amp;
	Out.ar(out, sig);
}).add)

(SynthDef(\crash, {
	arg out=0, att=0.01, sus=0.1, rel=0, amp=0.1, dur=1;
	var sig, env;
	env = Env([0, 1, 1, 0], [att, dur, rel], [0, 0]).kr(2);
	// sig = Decay2.ar(
		// Impulse.ar(TempoClock.tempo * TChoose.kr(1, [3,2,4])),
		// 0.01, 0.2,
		// SinOsc.ar([1800, 1820], 0, LFPar.kr(2.5).range(0.5, 1))
		sig = Saw.ar([555, 520] * Line.kr(1, 0.75, 1) * LFSaw.kr(TempoClock.tempo * 3).range(1, 02.7) );
	// +Formant.ar( Line.kr(20, 100 * Rand(1, 5), 0.3), Line.kr(150, 3005, 2), Line.kr(120, 30, 15))
// );
	// sig = sig + WhiteNoise.ar( Line.kr(0, 1, sus));
	sig = sig * env* amp;
	sig = Pan2.ar(sig, LFNoise1.kr(0.5));
	Out.ar(out, sig);
}).add)

(SynthDef(\bass, {
	arg out=0, att=0.01, sus=0.1, rel=0.33, amp=0.1, freq=92;
	var sig, env, sweep;
	env = Env([0, 1, 1, 0], [att, sus, rel], [0, 0]).kr(2);
	sweep = Env([freq*3, freq * Line.kr(1, 2, 10)], [att*2]).kr(0);
	sig = SinOscFB.ar(sweep * LFPulse.kr(TempoClock.tempo / 1.5).range(1,0.85), 0.75) ;
	// sig = PitchShift.ar( sig, 0.5, LFPar.kr(TempoClock.tempo * 1.75).range(0, 8));
	sig = sig * env* amp;
	Out.ar(out, sig);
}).add)

(SynthDef(\play, {arg out = 0, bufnum=0, start=0, sus=0, att=0.01, rel=0.125, ampLag=0.01, rateLag=0.01, loop=0, dur=1;
	var sig, env, duration;
	var amp = NamedControl.kr(\amp,0.5,ampLag);
	var rate = NamedControl.kr(\rate,1,rateLag);

	env = Env([0,1,1,0], [att, TempoClock.beatDur* dur*sus, rel]).kr(2);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rate, 1, BufFrames.ir(bufnum) * start, loop);
	sig = HPF.ar(sig, 140);
	// sig = sig + PitchShift.ar(sig, 0.25, LFSaw.kr(0.25, 0.5).range(0, 1));
	// FreeSelfWhenDone.kr(sig); // frees the synth when the PlayBuf is finished
	Out.ar(out, sig * amp);
}).add)

(a = Buffer.read(s,
	// "/home/pierre/Musique/Musique maison/RAV2E/RAV2.2/samples/beyonce.wav"
	// "/home/pierre/Musique/Musique maison/RAV2E/RAV2.2/samples/bebidol.wav"
	"/home/pierre/Musique/Musique maison/RAV2E/RAV2.2/samples/kopp-johnson-gilet-jaune.wav"
);)



(Pbindef(\p, \instrument, \play, \bufnum, a.bufnum,
	\sus, 1,
	\dur, 1/4
).play(quant:([4, 0.75])))

Pbindef(\p, \start, 0.02856 + Pseq([0, 0.005],inf), \amp, 1)
Pbindef(\p, \rate, Pstutter(8, Pseq([1, 2],inf)))


(Pbindef(\pp, \instrument, \play, \bufnum, a.bufnum,
	\sus, 0.5,
	\dur, Pseq([2, Pseq([1/4],8)],inf)
).play(quant:([4, 0.25])))

Pbindef(\pp, \start, 0.3, \amp, 0.1).stop

TempoClock.tempo = 5500/60
TempoClock.nextBar


Pbindef(\k, \instrument, \kick, \dur, 1/8, \amp, 0.1 * Pseq([ 1, 0, 0, 0, 0, 0, 0, 0],inf)).play(quant:[8, 0])

(Pbindef(\k, \dur, 1/2, \amp, 0.7 * Pseq([
	// Pseq([1],8),
	// 1, 0.5, 1, 0,
	// 1, 0.25, 0, 0,
	// 1, 0.5, 0, 0,
	1, 0, 1, 0,
	// 1, 0, 1, 0,
	// 1, 0, 1, Pwrand([0, 1], [0.7, 0.3]),
	// 1, 0,
],inf)).play(quant:[8]);
);

Pbindef(\k, \rel, 0.1)


Pbindef(\h, \instrument, \hat, \dur, 1/4, \amp, 0.05 * Pseq([ 1, 0, 0, 0],inf)).play(quant:[8, 0])
(Pbindef(\h, \dur, 1/4 ,\amp, 0.35 * Pseq([
	// 0.5, 0, 1, 0,
	// Pseq([0.25, 1, 0.5, 0], 4),
	1, 1, 1, 1,
	1, 1, 0, 1,
	// 0
	// 1, 0, 1, 0,
	// 1, 1, 1, 1,
	// Pseq([1, 0], 16),
	// 1, 0, 0.5, 0,
	// Pseq([1],16)
	// 1, 0, 1, 0.5,
	// 1, 0, 1, 0,
	// 1, 1, 1, 1,
	// Pseq([1, 1, 1, 0],7),
	// Pseq([1],8)
	// Prand([0, 1]), 0, 0, 0,
	// Prand([0, 1]), 0, 0, 0,
],inf)).play(quant:4);
)


(Pbindef(\s, \instrument, \snare, \dur, 1/2, \amp, 0.7 * Pseq([
	// 0.2, 0.2, 0.2, 0,
	// 0
	// 1, 0, 1, Pwrand([0, 0.5], [0.8, 0.2]),
	// 1, 0, 1, 0.5,
	// 0, 0.75, 1, 0,
	// 0, 0, 1, 0.5,
	// Pseq([1], 16),
	// 0.5, 1, 0, 0,
	// 1
	// 0, 0, 1, 1,
	// 0, 1, 1, 0,
	// 0, 0, 0, 0,
	0, 0, 1, 0,
	// 0, 1, 0, 0.5,
	// 0, 1, 0, 0
],inf)).play(quant:[8, 0]);
)
Pbindef(\s, \rel, 0.2)

(Pbindef(\c, \instrument, \crash, \dur, 1/4, \amp, 0.6 * Pseq([
	0, 0, 0, 0,
	// 1, 0, 1, 0,
	// 0.5
	// 0, 0, 0, 0
],inf)).play(quant:[8]))

(Pbindef(\b, \instrument, \bass, \dur, 1/2 ,\amp, 0.5 * Pseq([
	0, 0, 0, 0,
	// 0.5, 0, 1, 0,
	// 1, 0, 1, 0,
	// 0, 0, 1, 0,
],inf), \freq, Pstutter(8*12, Prand([87, 92, 77],inf) + 30 * Pseq([
	1, 1, 0.97, 1,
	2, 1, 1.15, 1,
	1, 1, 2, 1,
	1.1, 1, 1.5, 1,
],inf))).play(quant:8))

Pbindef(\b, \sus, 0, \rel, 0.2)

Pbindef(\k).stop; Pbindef(\s, \amp, 0.1);  Pbindef(\b).stop;/// DROP

Pbindef(\k).play(quant:[8]); Pbindef(\s, \amp, Pseq([0.1, 0, 0, 0, 0, 0, 0, 0],inf) ) /// REPARS




(Ndef(\mic, {
	var sig = In.ar(3);
	Out.ar(0, sig!2);
}).play)
Ndef(\mic).clear