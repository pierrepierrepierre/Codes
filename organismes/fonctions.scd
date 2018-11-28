// école de marimba
(x.free; x = {
	var sig;
	sig = Mix.fill(20, {
		Decay2.ar(
			Impulse.ar(
				LFNoise0.ar(Rand(0.1, 1), 4, 5),
				0,
				SinOsc.ar( LFNoise2.kr(0.5, 35, 40), 0, 1 )
			),
			0.1.rand,
			0.99.rand,
			SinOsc.ar(
				LFNoise2.kr(0.2, 300, 380),
				0,
				0.1)
		)
	});
	Pan2.ar(sig);
}.play)

// micro grenouilles
( z.free; z = {
	var in, sig, fm, amps;
	// in = Mix.fill(4, { SinOsc.ar(rrand(200, 230), 0, 0.1)});
	in = WhiteNoise.ar(0.5);
	fm = {LFNoise0.kr( rrand(0.1, 0.01), 8, 8.5)};
	amps = {LFNoise1.kr( rrand(0.2, 0.4), 0.5, 0.5)};

	sig = {Mix.fill( 2, {BBandPass.ar( in, rrand(250, 500) * SinOsc.kr(fm, pi/2, 3,3.5), LFNoise1.kr(0.2, 0.005, 0.0051), 0.3 * amps)})}!2;

	Pan2.ar(sig);
}.play)



// ver géant
( z.free; z = {
	var in, sig, amp, fm;
	amp = {LFNoise1.kr(rrand(0.02, 0.04), 0.5, 0.5)};
	fm = {LFNoise1.kr(rrand(0.05,0.01), 3)};
	sig = { Mix.fill(4, {
		SinOsc.ar(rrand(230.0, 280) + fm ,0, amp)
	})}!2;

	sig = sig * LFPar.ar( fm + 350 , 0, 0.5);
	sig = sig * (LFNoise0.kr(1 + (fm*0.1) ) + Decay2.ar( Impulse.ar( 4 + fm) , 0.05, 1, sig));
	sig =	sig * (0.5 + DelayC.ar( sig, 0.5, 0.148));
	sig * 0.2
}.play)


{{SinOsc.ar(1000.rand.postln, 0, 0.1)}!3}.play
{{Mix.fill(3, { SinOsc.ar(1000.rand.postln, 0, 0.1)})}.dup}.play