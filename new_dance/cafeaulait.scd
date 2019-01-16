TempoClock.tempo



Pdef.clear



///// INTRO DE RANDO //////

(
Pbindef(\k, \instrument, \kick, \rel, 0.15, \dur,  Pseq([ 1, Pseq([0.75, Prand([0.75, 0.25, 1.25])]), Pseq([1.5, 0.5]) ],inf), \freqB, 65, \freqBC, 23, \freqC, 30, \amp, 0.75, \freqA, 5000 );
Pbindef(\hot, \instrument, \bip, \freq, [600, 573, 577, 601, 603] * Pseq([ Pseq([1], 15 ), Pseq([[0.7, 0.8678, 0.979, 1, 1.13, 1.672, 4, 3.74]]) ],inf), \amp, 0.1, \dur, 1/6);
Pbindef(\p, \instrument, \bip, \freq, 1111 * ({rrand(0.5,2)}!10), \rel, 0.02, \amp, 0.02, \pan, [-1, 1]);
Pbindef(\hot, \dur, Prand([1.5, 1, 1/2],inf), \amp, Pwhite(0.05, 0.2) );
// Pbindef(\p, \dur, Pfunc({~lastKick[\dur]}) / Prand([2, 4, 1.5],inf) );
Pbindef(\p, \dur, Prand([1/4, 3/8, 1/8, 1/8],inf), \amp, Pwhite(0.05,0.2) );
)

Pbindef(\p).play(quant:[4]); // 1st
Pbindef(\hot, \stretch, 1).play(quant:[4, 0.75]); // 2nd


(
~k.stop; ~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1]);
// Pbindef(\hot, \stretch, Pseq([1,0.5, 0.25],inf));
)

Pbindef(\tmp, \instrument, \clap, \dur, Pseq([ Pseq([2], 8), Pseq([1.5],2)],inf), \fq, [200, 400, 900, 1500], \del, 0.01, \rel, 0.125, \rq, 0.05, \amp, 0.2).play(quant:4)


Pbindef(\q, \instrument, \bip, \freq, 771 * ({rrand(0.5,2)}!10), \rel, 0.02, \amp, Prand([0.1, 0],inf), \pan, [-1, 1], \dur, 1/8).play(quant:4);

Pbindef(\r, \instrument, \bip, \freq, [900, 930, 910], \rel, Pwhite(0.01, 0.08), \amp, Prand([0.1, 0.05, 0.2, 0],inf), \pan, [-1, 1], \dur, 3/4 ).play(quant:4);

Pbindef(\s, \instrument, \bip, \freq, [700, 670, 688], \rel, Pwhite(0.01, 0.08), \amp, Prand([0.1, 0.05, 0.2, 0],inf), \pan, [-1, 1], \dur, Prand([1/6, 1/8],inf) ).play(quant:4);

Pbindef(\basse, \instrument, \bip, \dur, Pseq([1.5, 2],inf), \freq, Pwrand([120, 132, 126], [0.35, 0.15, 0.5],inf) / [1.25, 0.75], \rel, 0.4, \att, 0.05, \amp, 0.2 ).play(quant:[4,0.5])



Pbindef(\tmp, \dur, 1.5)
Pbindef(\k, \instrument, \kick, \rel, 0.15, \dur,  Pwrand([1/2, 1/4], [0.75, 0.25],inf) , \freqB, 180, \freqBC, -20, \freqC, 60, \amp, 0.75, \freqA, 8000 );

Pbindef(\tmp, \dur, 3/8, \amp, Prand( [0.25, 0.1, 0],inf), \rq, Pwhite(0.001,0.05))


Pbindef(\k, \instrument, \kick, \rel, 0.15, \dur,  Pfunc({~rotb.(4, 0.5)}) , \freqB, 180, \freqBC, -20, \freqC, 60, \amp, 0.75, \freqA, 8000 );





/* RAND ON THE BEAT *////////////////////////////////////////////////////////
(SynthDef("bipfm", {
	arg out=0, att=0.001, rel=0.05, freq=80, pan=0, sus=0, amp=0.1, fmrate=0, dur=0.1;
	var sig, env, fm, duration, del;
	duration = att + rel + sus;
	fm = LFPar.kr(duration+dur / Rand(1, 50), 0.5).range(-6, 4.5) * fmrate;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	del = DelayC.ar( 1, 0.2, 0.1 );
	sig = SinOsc.ar(freq*(fm+1), pi/2) + Saw.ar(freq/4 *(fm+1) + 10.rand);

	// sig = Formant.ar( Line.kr(70, 1780, dur), Line.kr(400, 700, sus) * LFSaw.kr( 56 * (1/dur)), 89) * del + sig;

	// sig = Ringz.ar(sig, freq*fm*fmrate + LFPar.kr( dur+duration).range(100, 200), LFTri.kr( Rand(0.6, 18) ).range(0, 0.0125), 0.1) + sig;
	// sig = Formlet.ar(sig, fmrate * env + fm * 89 + 300, 0.1, 0.01 ) * sig;
	// sig = ClipNoise.ar() + BrownNoise.ar() + Saw.ar(LFNoise1.kr(39).range(200, 2000), 2) * LFSaw.kr(0.25, 1).range(0,15) + sig;
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(out,sig);
}).add;)

(~rotb = {arg quant = 2, rest = 0.5, brk=1; var ttnb = TempoClock.timeToNextBeat(quant); if( ( ttnb > rest) , { TempoClock.tempo /
	[8, 5, 7]
	// [7, 4, 14]
	// [3, 6, 1.5, 8]
	.choose
}, {ttnb / rrand(1,brk) + 0.05 max:0.05} ) };
~tnb = {TempoClock.timeToNextBeat max:0.05})


// START
(~pstop.(); ~k.stop; ~k = Pbindef(\k, \dur, Pseq([1/4, 1.5],inf)).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1]);
Pbindef(\h, \dur, Pfunc({~lastKick[\dur]}), \amp, 0.05).play(quant:4);
Pbindef(\s, \dur, Pfunc({~lastKick[\dur]}), \amp, 0.05).play(quant:4);
)

Pbindef(\k).stop
Pbindef(\s, \dur, Pfunc({~lastKick[\dur] * 4}))
~k.stop
Pbindef(\k, \dur, Pfunc({~rotb.([8, 6].choose, [0.75, 0.5].choose )}))

TempoClock.tempo=1

Pbindef(\k, \instrument, \ki, \amp, 0.5, \dur,  Pfunc({~rotb.([6, 8].choose,  [0.75, 0.25, 1.5].choose, ) }), \freqAC, Pwhite(-1.0, 1), \freqB, 120, \freqC, 66, \freqA, 2000 );
Pbindef(\sh, \instrument, \clap, \dur, Prand([1/4, 1/8, 1/8],inf), \rel, 0.2, \amp, 0.2).play

Pbindef(\s, \amp, 0.1, \rel, Pif(Pfunc{~lastKick[\dur] > 1}, Pfunc({~lastKick[\dur]}), 0.15 ) )

(Pbindef(\s, \instrument, \snare, \cutoff, 0.0075, \fq, [1000, 188] * Pwhite(0.9, 1.5), \amp, 0.2, \rel, Pwhite(0.005,0.1), \dur, 4 ).stop.play(quant:[2, 1.25]);
Pbindef(\h, \instrument, \bipfm, \amp, 0.06, \fmrate, 0.75, \freq, [400, 440, 1480],\dur, Pfunc({~lastKick[\dur]}), \sus, Pkey(\dur) * 0.8 , \pan, Pwhite(-0.75, 0.75)).stop.play(quant:4))


Pbindef(\s, \instrument, Prand([\snare, \snaredel],inf), \delfq, 0.03, \delvit, Pwhite(0.0001, 0.05), \deldur, Pwhite(0,0.5), \sus, Pwhite(0, 0.25), \ff, Pwhite(100, 2900), \dur, Pfunc({ ~lastKick[\dur]}), \amp, Pfunc({ if(~lastKick[\dur] > 1, {0.15}, { [0, 0, 0, 0, 0.1].choose })}) )

Pbindef(\h,	\sus, Pif( Pfunc({~lastKick[\dur] > 0.5 }), Pfunc({~lastKick[\dur] - rrand(0.25,0.5) }), 0, 0 ), \fmrate, 0.275 ).play(quant:[2])

Pbindef(\h, \fmrate, Pif(Pkey(\dur) > 0.75, Pwhite(0.25,1.5), 0.75, 0.75))

// Grosse Trace de Noise //
Pbindef(\s, \rel, Pwhite(0.1,0.5), \relC, Pwhite(0,12) ).play(quant:[3, 1.25])

Pbindef(\s, \dur, 2 + Pwrand([0, Pseq([ -1.75, 0.25 ]) ], [0.8, 0.2],inf))


////////////////////////////////////////







(SynthDef(\ki, {arg out=0, amp=0.25, att=0.01, rel=0.1, dec=0.05, attC=3, decC=0,relC=5, freq=60, fb=0;
	var sig, env;
	env = Env([0,1,0.8,0], [att, dec, rel], [attC, decC, relC]).kr(2);
	sig = SinOscFB.ar(freq, fb) min:0.1 max:-0.1 * 10;
	sig = sig * amp * env;
	Out.ar(out, [sig, sig]);
}).add;

SynthDef(\nz, {arg out=0, amp=0.25, att=0.01, rel=0.1, sus=0, attC=3, relC=5, freq=360, pan=0;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel], [attC, 0, relC]).kr(2);
	sig = Blip.ar(freq, 5) min:0.1 max:-0.1 * 10;
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(out, sig)
}).add;

SynthDef(\sn, {arg out=0, amp=0.25, att=0.01, rel=0.1, sus=0, attC=3, relC=5, freq=360, pan=0;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel], [attC, 0, relC]).kr(2);
	sig = ClipNoise.ar() * Formant.ar(500  * LFNoise1.kr(4).range(0.25, 20), 800 * LFNoise1.kr(4).range(0.25, 20), 400 * LFNoise1.kr(7).range(1, 10), 1, 0.1);
	sig = Resonz.ar(sig, freq, 0.5, 10);
	sig = sig * env * amp;
	Out.ar(out, [sig, sig]);
}).add;

SynthDef(\sna, {arg out=0, amp=0.25, att=0.01, rel=0.1, sus=0, attC=3, relC=5, freq=360, pan=0;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel], [attC, 0, relC]).kr(2);
	sig = Formant.ar(280, 1880 * WhiteNoise.kr(1), 320 * WhiteNoise.kr(1) );
	sig = WhiteNoise.ar() + (sig*sig) + BrownNoise.ar();
	sig = Formlet.ar(sig, freq, 0.0001,0.01);
	Out.ar(out, [sig, sig] * env * amp);
}).add;

)


///////////// MORCEAU GROOVE

~preset.(); Ndef.clear; ~pstop.()

(
Ndef(\nap, { SinOsc.ar([145, 150] * 6  ) * LFSaw.kr([145, 150]) + Pulse.ar([440, 330, 220], LFNoise1.kr(5).range(0.01,0.8), 0.4) /2 });

Ndef(\bb, {arg pulse=1;
	Saw.ar([150, 145] * LFSaw.kr( TempoClock.tempo / pulse).range(1,0.001) )
	* 0.2!2 });

Ndef(\saw, {arg pulse= 3;
	var beat = LFPulse.kr(pulse, 1, 0.25);
	Saw.ar(170 * LFPar.kr(18).range(0.2, 4) + (beat*[50,100])) + Saw.ar(166 - (beat * 100) ) min:0.1 max:-0.1 * beat});

Ndef(\bbsaw, {
	Select.ar(LFPulse.kr(0.25, 0, 0.25).range(0,1), [Ndef(\bb), Ndef(\saw)])});

Ndef(\fhh, {arg pulse=2;  Formant.ar(pulse*4, [1500, 800], [400, 100]) });
)

Ndef(\nap).play
Ndef(\bb).play


// PRENDRE LE TEMPS
Pbindef(\k, \instrument, \ki, \freq, 55, \fb, 1, \dur, 4, \rel, 1, \relC,-3, \amp, 1).play(quant:4);

// PRENDRE LE TEMPS
Pbindef(\snare, \instrument, \sna, \dur, 2, \freq, [1600, 500], \amp, 0.05 ).play(quant:[4, 1.5])


// ON COUPE
Ndef(\nap).stop(); Ndef(\bb).stop(0.5); Pbindef(\saw).stop(); Pbindef(\z, \instrument, \nz, \dur, 1/8, \pan, Pwhite(-1, 1.0), \freq, 1000 + Prand([280, 290, 380],inf), \rel, 0.03, \att, 0.001, \amp, 0.2).play;


//// POUSSE BOUDIN /////
Pbindef(\ki, \instrument, \kick, \dur, 1/2, \amp, 0.25).play(quant:4) // Augmenter amp, et freqA et accélérer
Pbindef(\ki, \amp, 1.5, \freqA, /*8000*/ 1000, \freqAC, 18)

Ndef(\bb).set(\pulse, 0.125); Ndef(\saw).set(\pulse,8)
Ndef(\bbsaw).play

(Pbindef(\snare, \dur, Pseq([1, 0.5, 0.25, 0.125, 0.625],inf ));
Pbindef(\k, \dur, Pseq([0.25, 3.75],inf), \rel, Pseq([0.2, 1],inf));
)

Ndef(\fhh).play


Pbindef(\pop, \instrument, \nz, \freq, Pseq([ Pseq([300],12), Pseq([1030],4) ],inf) , \dur, 1/8, \rel, 0.05, \pan, Pwhite(-1, 1.0), \amp, 0.25).play(quant:4)


Pbindef(\sn, \instrument, \sn, \dur, 2, \rel, 0.5, \relC, 6, \amp, 0.7, \freq, 80 + Pseq([50,100,200,300],inf)).play(quant:[4, 0.5]);

Pbindef(\k, \dur, 1, \amp, 1, \rel, 0.25, \relC, 12, \fb, 1, \freq, 55).play(quant:4)

Ndef(\bb).set(\pulse, 4)

~pstop.(); Pbindef(\ki, \dur, Pwrand([1/2, Pseq([1/3],3)], [0.8, 0.2], inf), \freqC, 100).play(quant:4); Pbindef(\k, \dur, 3, \rel, 1, \freq, 40, \amp, 3, \relC, 0).play(quant:2); Pbindef(\z, \dur, 1/12).play(quant:4)

Ndef(\sss, { {Saw.ar( LFNoise1.kr(0.125).range(100,300) )}!4 / 4 + Formant.ar(16, [2000, 1800], LFSaw.kr(0.25).range(1000,20)) }).play // Nappe monte

Pbindef(\sn, \dur, Prand([2, 1],inf), \amp, 0.5 , \rel, 0.3, \freq, Prand([10, 280],inf)).play(quant:[2, 0.75])

Pbindef(\pop, \rel, Pwhite(0.01,0.1), \freq,[800, 810, 300, 1030] ).play(quant:4)

Pbindef(\sn, \dur, ?? ,\amp, ?? , \rel, Pwhite(0.01, 0.3))

Pbindef(\pop, \dur, Pseq([ Pseq([1/8],4), Pseq([1/4],2)],inf)).play(quant:2)


Ndef(\sss).stop; Pbindef(\k, \dur, Pseq([1/4],inf), \rel, Pseq([ 0.1],inf) )


/////////// MONO BEAT /////////////////////////////

TempoClock.default.tempo = 1

Pbindef(\mono, \dur, 4).play.clear

(SynthDef(\mono, {arg dur=1;
	var len, env, sig,sweep, env2;

	len = Env([0,1,0], [dur,0.001]).kr(2);

	env = Env([0,1, 0], [0.01, 1], [6, 0]).kr(0);

	env2 = Env([0,0,1, 0], [0.5, 0.01,3], [0,0,6]).kr(0);

	sig = Decay2.kr( Impulse.kr(7), 0.01, 0.2, SinOsc.ar(500 * 10 * LFNoise1.kr(0.1).range(1,1.1), pi) * 0.05);

	sig = sig + SinOscFB.ar([78, 95] * Line.kr(100,1,0.01), 0, env) ; // KICK

	sig = SinOsc.ar( [1800, 2200, 1909, 2400] * {LFNoise1.kr(0.5).range(0.95, 1.5)}!4 * XLine.kr(1, 0.1, 14)) * 0.05 + sig;

	// sig  = sig + SinOsc.ar( [130, 203, 1920, 1880, 1309, 1320, 1300], 0, LFPar.kr(1.25 + LFPulse.kr(0.5)) * 0.1);

	// sig = In.ar(2) * env2 * 0.1+ sig;

	// sig = Formlet.ar( WhiteNoise.ar(), 700, 0.0001, 0.0025 + LFNoise1.kr(2).range(0.0001, 0.005), Done.kr(env) * 0.1 ) +sig;

	// sig = SinOsc.ar( 126 * LFSaw.kr(0.4 + LFNoise1.kr(0.25).range(0.5, 2) ).range(0.5, 5) + LFPulse.kr(5.872).range(10, 300) + LFSaw.kr(LFNoise0.kr(1).range(1, 30)).range(0,200) * LFSaw.kr(0.25, 1).range(10,0.5)) * 0.1 + sig * env2;

	// sig = Formlet.ar(ClipNoise.ar(), 400, 0.001, 0.02,0.5 ) + (sig*4);


	Out.ar(0, [sig, sig]);
}).add
)





Pbindef(\k).stop; Pbindef(\kk).stop;
Pbindef(\m, \instrument, \mono).play

Pbindef(\m, \dur, Pseq([0.5, 0.25, 0.5, 0.25, 1],inf) )

Pbindef(\m, \dur, Pseq([ 1/4, 1/8, Prand([1/3, 3/4, 1/4, 1/8])],inf) )

Pbindef(\m, \dur, 4).play

Pbindef(\m, \dur, Pseq([ Pseq([1/8],16), 2],inf))

Pbindef(\m, \dur, Pwrand([1/8, 2], [0.97, 0.03],inf))



(SynthDef(\dnc, { arg dur=1;
	var env, len, sig = 0, trig, trig2, swp;

	len = Env([1,1], [dur]).kr(2);
	trig = Impulse.kr(0.75);
	trig2 = Impulse.kr(2.5);
	swp = Env([3800, 97, 33], [0.05,0.15,0.15], [6, 3]).kr(0, trig2);
	env = Env([0,1,0], [0.1,0.3], [6, -3]).kr(0, trig);

	// sig = Formant.ar(4 + LFPulse.kr(0.5, 0.5, 0.2, 2), [700, 300, 2800], 150 - LFPulse.kr(0.5, 0.75, 0.1, 80) , 0.03);
	// sig = sig + Formant.ar(2, LFNoise1.kr(200).range(0,30) + 108 + LFPulse.kr(1.25, 0.5, 0.25, LFNoise0.kr(8, 200) ) , 30, 0.1);
	sig = sig + SinOscFB.ar([swp, swp*3.33], 1.2, env * 0.5 + 0.01);

	Out.ar(0, [sig, sig]); }).add)

Pbindef(\d, \instrument, \dnc, \dur, 4).play



//////////////////// INTRO MAIN DROITE

// DEF
( Pbindef(\k, \dur, Pseq([ 3/4, 1/2 ],inf) );
Pbindef(\hot, \dur, Pseq([1/8, 1/4],inf), \amp, Pwhite(0.05, 0.2) );
Pbindef(\p, \dur, Pseq([1/4, 1/8],inf), \amp, Pwhite(0.05,0.2) );
x = {ClipNoise.ar(1) + SinOscFB.ar([40,55, 77], 0.2, 0.75) * Env([0,1,0.8, 0], [0.01, 0.1, 0.01]).kr(2) };)

// DEF & CHANGE NOTES
( Pbindef(\k, \instrument, \kick, \amp, 0.75, \freqAC, 4);
Pbindef(\hot, \instrument, \bip, \freq, [600, 573, 577, 601, 603] * Pseq([ Pseq([1], 15 ), Pseq([[0.7, 0.8678, 0.979, 1, 1.13, 1.672, 1.4, 1.374]], rrand(1,4)) ],inf), \amp, 0.1);
Pbindef(\p, \instrument, \bip, \freq, 1111 * ({rrand(0.5,2)}!10), \rel, 0.02, \amp, 0.02, \pan, [-1, 1]); )

// PLAY
(Pbindef(\p, \stretch, 1).play(quant:[4]); // 1st
Pbindef(\hot, \stretch, 1).play(quant:[4, 0.75]); // 2nd
~k.stop; ~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1]);)

// STUPIDLY SQUARE
Pbindef(\k, \dur, Pseq([ Pseq([1/4],4), Pseq([1/2],inf)]) )

// MONTEE
(Ndef(\rise, { arg len = 60;
	Mix.fill(5, {arg i;  SinOsc.ar( rrand(33, 300) * Line.kr(1,2, len*1.2), 0, 0.15)} )
	+ VarSaw.ar( [66, 117] + LFNoise1.kr(3, 20), 0, LFTri.kr(0.125).range(0.25,0.75))
	* Decay2.kr( Impulse.kr(8), 0.01, Line.kr(0.1,0.35, len*1.4), LFPar.kr(0.66, 2)  )
	* Line.kr(0,1, len)
}).play(quant:4))



// STOP IN SNARE
Ndef(\rise).clear; ~pstop.(); Ndef(\stop).play; x.play


Pbindef(\p, \stretch, Pseq([ 2, 1, 3],inf)).play



/////////// LIVE  DEF /////////////////////////////

TempoClock.default.tempo = 1

Pbindef(\ld, \dur, 4).play

(SynthDef(\ld, {arg dur=1;
	var len, env, sig,swp, env2;

	len = Env([0,1,0], [dur,0.001]).kr(2);

	env = Env([0,1, 0], [0.01, 0.125], [6, 0]).kr(0);

	env2 = Env([0,0,1, 0], [0.5, 0.01,3], [0,0,6]).kr(0);

	swp = Env([150, 1, 0.75], [0.025, 0.075], -3).kr(0);


	sig = Saw.ar(10) + Saw.kr(4.9) + Pulse.kr(2, LFSaw.kr(0.1).range(0.1,0.9)) + LFPar.kr(2.1) * Mix.fill(4, { SinOsc.ar( rrand(80, 400), 0, 0.1 ) } ) min:0.1 max:-0.1 * 5;

	sig = sig + ( SinOsc.ar(68 * swp * env * [2, 2.1], pi/2) + SinOsc.ar(96) * Env.perc(0.01,1, 0.8).kr(0, DelayL.kr(Impulse.kr(1 - LFPulse.kr(0.25).range(0,0.5)),0.5,0.5))  ) * 2;

	sig = Mix.fill(5, {Saw.ar(Rand(200, 300) * Line.kr(0.5,3, dur) ) * 0.5 }) + sig * 2 ;

	// sig = sig + (sig*WhiteNoise.ar(0.5));

	// STRAIGHT KICK
	// sig = SinOsc.ar(80 * swp, pi/2, env);

	// HI- LINES
	sig = sig + ( Mix.fill(4, {arg i; SinOsc.ar( Rand(2300, 2400) * LFNoise1.kr(0.1 * i).range(0.8,1.2), 0, 0.2 ) }) * (0.5-env ) );

	// sig = PlayBuf.ar(2, b, 0.7 * LFNoise0.kr(0.33).range(0.25, 2.2), 1, 0, 1) + sig;

	// PLUIE ACIDE
	sig = Mix.fill(50, { WhiteNoise.ar( SinOsc.ar(rrand(40,5000)) ) * Decay2.kr( Dust.kr( Rand(0.1,10)), 0.01, 0.075 ) } ) * 2 + sig;

	sig = sig * 0.5;

	Out.ar(0, [sig, sig]);
}).add
)

Pbindef(\ld, \instrument, \ld).play

Pbindef(\ld, \dur, 1)