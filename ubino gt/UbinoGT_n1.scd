(
SynthDef("bip", { arg dur=1, amp=0.5;
	var sig, env, env2, env3;
	dur = TempoClock.beatDur * dur;
	env = Env([0, 1,1, 0], [0.01, dur , 0.01]).kr(2);
	env2 = Env([0, 1,1, 0], [0.01, 0, 0.5]).kr(0);
	env3 = Env([0, 1,1, 0], [0.01, dur * 0.5, 0.2]).kr(0);

	sig = Pulse.ar( LFNoise0.kr(0.0400).range(60, 66) + [0, 2.33]) * env3 * 0.05;

	sig = sig + SinOsc.ar( Env([3000, 150, 66], [0.01, 0.05]).kr(0), pi/2, env2 * 0.25 );

	sig = sig + Decay2.ar(Impulse.ar( TempoClock.tempo * 12 * LFPulse.kr(TempoClock.tempo, 0.5, 0.25).range(1, 2)), 0.01, 0.05, ClipNoise.ar(0.25) + SinOsc.ar( LFNoise0.kr(400).range(1000, 4000), pi/2, 0.05));

	// SNARE
	sig = sig + DelayC.ar( Decay2.ar(Impulse.ar(0), 0.01, 0.25), dur, dur/2, ClipNoise.ar(1) + SinOsc.ar(LFNoise0.kr(400).range(1000, 400) , pi/2) * 0.5);


	sig = Pan2.ar(sig, 0, 1) * amp;
	Out.ar(0, sig*env);
}).add
;

Pbindef(\b, \instrument, \bip, \amp, 1, \dur, 2).play
)

TempoClock.beatDur

TempoClock.tempo = 90/60

(Ndef(\tt, {

	SinOsc.ar([4055, 4130]) /2 +Line.kr(0, 1000, 100)

	// WhiteNoise.ar(1)!2

	// + SinOsc.ar( LFNoise1.kr(0.02).range(40, 300) + LFSaw.kr(4 * LFNoise0.kr(0.1).range(0.1, 100)).range(0, 400) )

	// + SinOsc.ar( LFNoise1.kr(0.02).range(40, 3000) + LFSaw.kr(4 * LFNoise0.kr(0.1).range(0.1, 100)).range(0, 400) );

}).play)


Ndef(\ii, { SinOsc.ar(4444 * LFNoise0.kr(100).range(0.7, 1.2), 0) + SinOsc.ar(4409* LFNoise0.kr(100).range(0.7, 1.2), 0) + SinOsc.ar(4450 * LFNoise0.kr(100).range(0.7, 1.2), 0) / 5!2 }).play.stop


