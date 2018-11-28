
// TocTOc
( Ndef(\toc, {
	SinOsc.ar(LFNoise0.kr( 10 ).range(166,166) * [1,0.48] ,pi/2, 0.5)
	*
	Env.perc(0.001, LFNoise0.kr(1).range(0.1,0.15), 1, LFNoise1.kr(0.5).range(3,-6)).kr(0, Impulse.kr(1.5))
	// * {LFNoise2.kr( LFNoise0.kr(0.5).range(0.25,8) )}!2
	* Pan2.kr( 0.5, LFNoise2.kr( LFNoise0.kr(0.5).range(0.25,8)))
}).play)
Ndef(\toc).stop




(Ndef(\tac, {
	Decay2.kr(Impulse.kr( 4 * LFPulse.kr( LFNoise0.kr(0.5).range(0.25,2), 0, LFNoise0.kr(0.5).range(0.25,0.75), LFNoise0.kr(0.5).range(1,4))), 0.001, 0.01, SinOsc.ar( 440 * [0.2,5] * LFNoise0.kr(0.015).range(0.7,3)))
}).play)


(Ndef(\basz, {
	SinOscFB.ar([120, 128+LFNoise1.kr(1).range(-10,50)],  LFNoise2.kr(5).range(0.4, pi/2), 0.5, Pulse.ar(115, 0.2, 0.1))
	* Decay2.kr(Impulse.kr(4), 0.01, 0.35, LFSaw.kr(0.25))
}).play)


(Ndef(\saz, {
	RLPF.ar( Saw.ar(245), LFNoise1.kr(0.125).range(300, 1600), LFSaw.kr(0.135).range(0.1, 1))
	* Decay2.kr(Impulse.kr(4), 0.01, 0.175, LFSaw.kr(0.5))!2
}).play)



Pbindef(\k, \instrument, \kick, \dur, 6.5/6, \amp, 1, \freqA, 4500, \freqAC, 3, \freqB, 89, \freqBC, 8, \rel, 0.1).play(quant:4)

Pbindef(\k, \dur, Prand([1/4, 1/8],inf),\amp, 0.4)

Pbindef(\k, \instrument, Pstutter(2, Prand([ \kick, \snaredel, \snare, \clap, \nclap, \nkick],inf))).play



(Ndef(\hollow, {
	var sig = Mix.fill(180, { var son;
		son =  SinOsc.ar( 600 + 20.bilinrand, pi.rand, 0.01 );
		Pan2.ar(son, LFSaw.kr(0.1 + 0.001.rand, 1))
	});
	sig = sig * LFSaw.kr(0.1 + 0.001.rand, 1) * PinkNoise.ar( LFNoise1.kr(4).range(0,0.25), 1) * Dust2.ar( LFNoise0.kr(0.5).range(0.5,130), 1,1 );
	sig = RLPF.ar(sig, [LFNoise1.kr(0.633).range(200, 1000), LFNoise1.kr(0.33).range(200, 2000)], LFSaw.kr(0.125).range(0.1, 1), 0.25)

}).play)
Ndef(\hollow).stop

(Ndef(\clik_digi, {var sig;
	sig =
	Formant.ar(
		LFNoise2.kr( 0.1 ).range(0.05,15),
		LFNoise2.kr( 0.1 ).range(66, 2090),
		LFNoise2.kr( 0.1 ).range( 80, 3080)
	);
	sig = PitchShift.ar( sig, 0.5, 0.2 + LFPulse.kr(0.125, 0, 0.05).range(0,2), 0.2, LFNoise1.kr(0.7).range(0,0.5));
	sig = sig + DelayC.ar(sig, 0.2, 0.1, Saw.ar(2506 * LFNoise1.kr(0.4).range(0.1,2)) + BrownNoise.ar(LFNoise1.kr(0.6!2).range(0,0.1)));
	sig!2;
}).play)


(Ndef(\u, { var freq, sig;
	freq = LFNoise0.kr(0.4).range(0.125,1);

	sig =
	LFSaw.kr(freq) * LFPar.kr(freq*2) * LFPulse.kr( freq * 3 ) *
	Formlet.ar( Impulse.ar( LFNoise0.kr(1).exprange(0.5,20)), [2080,3000,170] * LFNoise1.kr(0.01!2), 0.01, 0.05);

	sig = sig + Decay2.ar( sig, 0.01,LFNoise0.kr(0.5).exprange(0.1,1.5), Saw.ar([2300,5004], 0.005 ) + SinOsc.ar([2400, 5020]*2, 0, 0.01))

	* 2

}).play)
~nstop.()


(Ndef(\rand_oiseaux, {
	var sig;

	sig = Formant.ar( LFSaw.kr(0.1).exprange(0.1,0.820), LFNoise1.kr( LFNoise0.kr(0.25).exprange(4,150)).range(780,9290), LFNoise0.kr(0.25).exprange(1,20),0.1);
	sig = sig + (sig*WhiteNoise.ar());
	Pan2.ar(sig, LFNoise2.kr(0.5))
}).play)


(Ndef(\truc, {
	var sig= Saw.ar([300,350], 0.2 * LFPar.kr(2, [0,0.2], LFTri.kr(2.5).range(0,1))) ;
	sig = sig ;
	sig = VarSaw.ar( 90, [0, 0.33], [LFTri.kr(0.125).range(0.25, 0.75), LFTri.kr(0.0125,pi/6).range(0.25, 0.75)])/3 + sig;
	// sig = sig +
	Formant.ar(1000 +  LFPulse.kr(0.5) - LFPulse.kr(0.75) + 40 * LFTri.kr(0.125) + 100 + LFPulse.kr( LFNoise1.kr(0.125).range(0.25, 0.8),0, 0.75, LFNoise1.kr(40).range(40, 500)), 1000 * LFNoise2.kr(0.125).range(0.025, 6), 400 - LFNoise2.kr(0.125).range(0.25, 4))!2 / 2;

}).play)

(Ndef(\oiseaux, {
	var sig , one, two, three;
	one = SinOsc.kr(1.12) + LFSaw.kr(1.2) + LFPar.kr(0.6);
	two = LFTri.kr(1) + LFCub.kr(1.75) + FSinOsc.kr(3) + LFSaw.kr(0.5);
	three = SinOsc.kr(0.1) + LFTri.kr(0.75) + LFPulse.kr(0.5);

	sig = Formant.ar( one.exprange(0.1,2), two.range(1440, 8000), three.range(10,30), 0.1);
	Pan2.ar(sig, LFNoise2.kr(2))
}).play)
Ndef(\oiseaux).stop


(Ndef(\wou, {
	var sig , one, two, three, env, trig, mod;
	trig = Dust.kr(1);
	env = Env([0,1,0.6,0], [0.001, 0.005, 0.3]).kr(0, trig);

	mod = LFPulse.kr(0.25, pi/2, 0.05).range(0,1000);

	one = 120;
	two = 700 + (mod/50);
	three = 1200 - (mod);

	sig = Formant.ar(
		one,
		two,
		three);

	sig = env * sig;

	Pan2.ar(sig, LFNoise2.kr(2), 0.1)
}).play)


({var sig, env, mod, one, two, three;

	env = Env([0,1,0.6,0], [0.001, 0.005, 10]).kr(0);
	mod = Env([[100,2040], [10]]).kr(0);

	// one = 200 + (mod/100);
	one = XLine.kr(100,460, 0.1);
	two = 780 + (mod/20);
	three = 13;

	sig = Formant.ar(
		one,
		two,
		three,
		0.5 * LFNoise1.kr()
	)
	+ RLPF.ar(BrownNoise.ar(), Line.kr(280, 800, 0.01), 0.15,0.5 * LFNoise1.kr(140))
	;

	sig = env * sig!2 *2;
}.play)


(Ndef(\vowel, {
	Formant.ar(7, 1830, [600, 300]) * 0.8
}).play)
Ndef(\vowel).fadeTime=0.5



(Ndef(\son, { var sig =
	Saw.ar([100+LFTri.kr(0.26).range(-20,30), 120+LFTri.kr(0.25).range(-20,30)]) + SinOscFB.ar(66 + LFPulse.kr(0.125,0,0.2, LFSaw.kr(2).range(0, 500)),2,0.2)
	* LFPar.ar(2 + LFPulse.kr(0.33).range(0,4))
	* 0.2 !2;
	// sig = Resonz.ar(sig, 1333 + LFSaw.kr(5).range(0,1333), 0.1) + sig * 4
}).play)