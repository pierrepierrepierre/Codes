(
SynthDef("shk", { arg amp=0.2, freq=1200, pan=0, att=0.01, rel=0.1, rq=1;
	var sig, env;
	env = Env.perc(att, rel, amp).kr(2);
	sig = {RLPF.ar(WhiteNoise.ar(), freq * Rand(0.9, 1.1), rq)}!2;
	sig = Balance2.ar(sig[0], sig[1], pan, env);
	Out.ar(0, sig);
}).add;

SynthDef("ki", {arg out=0,amp=0.5,pan=0,att=0.02,rel=0.1, sus=0,attC=0, relC=6,
	freqA=5040,freqB=121,freqC=63,freqAC=(-3),freqBC=(0), fb=0.1;
	var env, sweep, sig, fm;
	env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).ar(2);
	sweep = Env([freqA,freqB,freqB,freqC],[att,sus,rel],[freqAC,0,freqBC]).ar;
	sig = Mix.fill(6, {arg i; SinOscFB.ar(sweep * ( 1 + (i*0.666)), fb ,(0.5/(i+1.25)))});
	sig = sig * env * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;



SynthDef("clap",{arg out=0, att=0.001, rel=0.5, relC = -12, pan=0, amp=0.2, fq=900, del=0.05, rq=0.2;
	var sig, env;
	env = Env.perc(att, rel, amp, relC).kr(2);

	sig = Mix.fill(6,{arg i; var delay;
		delay = DelayN.ar(env, 0.2, rrand(0,del));
		BPF.ar(WhiteNoise.ar(), fq * Rand((i*0.25) + 1, (i*0.25) + 1.1), rq, 1 + (1/rq) * (1/6)) * delay;
	});
	sig = sig!2;

	Out.ar(out, sig);
}).add;

SynthDef("snare", {arg out=0,amp=0.5,fq=320, hifreq=1020, cutoff=0.01,pan=0,
	att=0.001, rel=0.3,attC=(0),relC=(-3), crash = 0;
	var sig, env, harms;
	harms = [3.94613,2.5909,2.77733,2.0675,1.16941,1,1885,1.10361,3.4638,1.38030,1.24318];
	env = Env([0,1,0],[att,rel],[attC,relC]).kr(1 - crash * 2);
	sig = Mix.ar([BrownNoise.ar(0.25), ClipNoise.ar(0.25)]);
	sig = RHPF.ar(sig,[3000,7000],0.1,1)
	+ Mix.fill(harms.size, {arg i; Ringz.ar(sig, fq * harms[i].postln, cutoff, 1/(cutoff*50+harms.size+i))})
	;
	sig = sig * env * amp / 1.5;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;


SynthDef("snaredel", {
	arg out=0, amp=0.5, att=0.002,sus=0.01, rel=0.001,
	attC=0,relC=(-24),
	pan=0, ff=1200, deldur=0.5, delvit=0.3,delfq=0.5,
	crash=2;
	var env, sig, envsin, sin,envdel;
	var rs = 0.0005, fqs = ff * [0.366, 1, 1.683, 1.333];

	env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).ar();
	envsin = Env([0,1,0],[att,rel*0.01],[attC,relC - 30]).ar();
	envdel = Env([0,1,1,0],[att,sus,rel],[24,0,24]).ar(2);
	sig = Mix.fill(fqs.size, {arg i;
		BHiPass.ar(
			ClipNoise.ar(0.5),
			fqs[i],
			rs*(fqs),
			fqs.size/((i+1*6))
		);
	});
	sin = Mix.fill(fqs.size, {arg i; SinOsc.ar(fqs[i],0,fqs.size/((i+1*6))) });
	sig = (sig * env * 0.5) + (sin * envsin * 1);
	sig = sig * env;
	sig = sig + CombN.ar(sig,delvit+0.1,LFNoise1.kr(delfq,delvit,delvit+0.01),deldur); // COMB DELAY
	// sig = sig * envdel;
	sig = Pan2.ar(sig,pan);
	sig = sig * amp;
	DetectSilence.ar(sig, time:crash, doneAction:2);
	Out.ar(out,sig);

}).add;

~pstop = {Pdef.all.do{arg i; i.stop}; ~s.stop; ~k.stop};
~presume = {Pdef.all.do{arg i; i.resume}; ~s.resume; ~k.resume};
~pplay = {arg quant=1; Pdef.all.do{arg i; i.play(quant:quant)}; ~s.play(quant:quant); ~k.play(quant:quant); Pbindef(\k).stop};
~preset = {Pdef.all.do{arg i; i.reset}; ~s.reset};
~nstop = {Ndef.all.do{arg i; i.stop}};

~gfree = { [g, e, x, y, z, ~sines, ~ksines].do{arg i; if(i.class == Array) { i.do{arg j; j.free}; i.free } {i.free} }};

~noKick = {arg t; (((~lastKick[\amp] < 0.1) && (~lastKick[\dur] >= (t/2))) || (~lastKick[\dur] >= t))};

~onBeat = {arg d; ( TempoClock.default.nextBar - TempoClock.default.beats) == d};

~onBeat = {arg d; ( TempoClock.default.nextBar - TempoClock.default.beats % d ) <= 0.01};

~nextBeat = {arg quant=1; TempoClock.nextTimeOnGrid(1) - TempoClock.beats};

)

TempoClock.default.tempo = 2
~preset.()

(Ndef(\in, {
	Mix.ar( SinOscFB.ar( [555, 549], Decay2.kr(Dust.kr(0.1!5), 0.5, 10).range(0, 2) , 0.1 )  * 0.2 )!2
	// + RHPF.ar( Saw.ar(46, Pulse.ar(122) ), 2000 * LFNoise1.kr(180).range(0.5, 2), LFSaw.kr( LFNoise1.kr(7).range(0.001, 88) ).range(0,1), 0.1)
	// + RLPF.ar(ClipNoise.ar(LFNoise1.kr(77).range(0, 1.0)), LFNoise1.kr(17).range(0, 1577), LFNoise1.kr(2).range(0,0.8))
}).play)

Ndef(\in).fadeTime=20
Ndef.clear
///////////////////////////////////////////////// RANDOM ON THE BEAT


/* RAND ON THE BEAT *////////////////////////////////////////////////////////
( SynthDef(\live, { arg out=0, att=0.001, rel=0.05, freq=80, pan=0, sus=0, amp=0.3, fmrate=0, dur=0.1;
	var sig, env, fm, duration, del, env2;
	duration = att + rel + sus;
	fm = LFPar.kr(duration+dur / Rand(1, 50), 0.5).range(-6, 4.5) * fmrate;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	del = DelayC.ar( 1, 0.2, 0.1 );
	env2 = Env([1,1], [dur]).kr(2);

	sig = Mix.ar( SinOsc.ar( [ 78, 89, 230, 178 , 189, 562, 1890 , 3569], pi/2, [ 1, 1, 0.8, 0.7, 0.6, 0.5, 0.2, 0.2]) ) * env ;
	sig = Formant.ar(6, 1289, 2676, 2) + sig ;
	// sig = sig + BrownNoise.ar( Line.kr(0, 2, dur) );


	sig = Pan2.ar(sig, pan, amp * env2);
	Out.ar(out,sig);
}).add;

SynthDef("bipfm", {
	arg out=0, att=0.001, rel=0.05, freq=80, pan=0, sus=0, amp=0.1, fmrate=0, dur=0.1;
	var sig, env, fm, duration, del, env2;
	duration = att + rel + sus;
	fm = LFPar.kr(duration + dur / Rand(1, 50), 0.5).range(-16, 14.5) * fmrate.exp;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	del = DelayC.ar( 1, 0.2, 0.1 );
	sig = SinOsc.ar(freq*(fm+1), pi/2) + Saw.ar(freq/4 *(fm+1) + 10.rand);

	sig = Formant.ar( Line.kr(70, 1380, dur * fmrate), Line.kr(400, 700, sus) * LFSaw.kr( 56 * (1/dur)), 89) * del + sig;

	// sig = Ringz.ar(sig, freq*fm*fmrate + LFPar.kr( dur+duration).range(100, 200), LFTri.kr( Rand(0.6, 18) ).range(0, 0.0125), 0.1) + sig;
	// sig = Formlet.ar(sig, fmrate * env + fm * 89 + 300, 0.1, 0.1 ) * sig;
	// sig = ClipNoise.ar() + BrownNoise.ar() + Saw.ar(LFNoise1.kr(39).range(200, 2000), 2) * LFSaw.kr(0.25, 1).range(0,15) + sig;
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(out,sig);
}).add;)

(~rotb = {arg quant = 2, rest = 0.5, brk=1; var ttnb = TempoClock.timeToNextBeat(quant); if( ( ttnb > rest) , { TempoClock.tempo /
	[5, 7, 8, 12]
	// [0.01]
	// [3, 6, 1.5, 8]
	.choose
}, {ttnb / rrand(1,brk) + 0.05 max:0.05} ) };
~tnb = {TempoClock.timeToNextBeat max:0.05})
Ndef.clear
TempoClock.tempo=1

Pdef.clear

Pbindef(\live, \dur, 1, \instrument, \live, \rel, Pkey(\dur) * 0.5, \amp, 0.3).play

Pbindef(\k, \dur, Pfunc({~rotb.([6, 8, 3].choose, [0.5, 1.25, 1.75].choose )}));

~k.play

Pdef.clear;
Ndef(\form).play

// START
(~pstop.(); ~k.stop; ~k = Pbindef(\k, \instrument, \ki, \amp, 0.75, \freqAC, Pwhite(-1.0, 1), \freqB, 76, \freqC, 43, \freqA, 2000, \rel, Pkey(\dur) * 0.25, \dur, Pseq([1/2, 3/4, Prand([1/4, 1/2, 1/3])],inf) ).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1]);
Pbindef(\h, \instrument, \bipfm, \amp, 0.06, \fmrate, 0.175, \freq, [400, 440, 1480],\dur, Pfunc({~lastKick[\dur]}), \sus,  Pif( Pfunc({~lastKick[\dur] > 1 }), Pfunc({~lastKick[\dur] - rrand(0.25,0.5) }), 0, 0 ) , \pan, Pwhite(-0.75, 0.75)).play(quant:4)
)

Pbindef(\h, \dur, 1/2)
Pbindef(\k).stop

~k.stop

Pbindef(\h,	\fmrate, 0.275 )
.play(quant:[2])



Pbindef(\sh, \instrument, \shk, \dur, Prand([ 1/8, 1/8, 1/4, 3/8, 1/8],inf), \amp, Pwhite(0.05,0.1) * Pseq([Pseq((0..300) / 300), Pseq([1],inf) ]), \freq, [5800, 5780] + Pwalk((0..2000), Pseq([ Prand([1, 2, 4, 6],30), Prand([-5, -2, 0, 2, 5],inf ) ],inf ) ), \rel, 0.08, \rq, 0.125 ).play; // Free HAT


Pbindef(\s, \instrument, \snare, \cutoff, 0.0075, \fq, [1000, 188] * Pwhite(0.9, 1.5), \amp, 0.2, \rel, Pwhite(0.01,0.2), \dur, 4 ).play(quant:[4, 2]);


Pbindef(\sh, \instrument, \shk, \dur, Pfunc({ ~lastKick[\dur] / [1].choose }), \amp, Pwhite(0.05,0.1) ).play; // SLAVE HAT


Pbindef(\sh, \rq, 0.01, \amp, 0.1, \dur, 1/12, \rel, 0.01)



Pbindef(\s, \instrument, Prand([\snare, \snaredel],inf), \delfq, 0.03, \delvit, Pwhite(0.0001, 0.05), \deldur, Pwhite(0,0.5), \sus, Pwhite(0, 0.25), \ff, Pwhite(100, 2900), \dur, Pfunc({ ~lastKick[\dur]}), \amp, Pfunc({ if(~lastKick[\dur] > 1, {0.15}, { [0, 0, 0, 0, 0.1].choose })}) )



Pbindef(\h,	\fmrate, 0.375 )
.play(quant:[2])

Pbindef(\h, \fmrate, Pif(Pkey(\dur) > 1, Pwhite(0.25,1.5), 0.75, 0.75))

// Grosse Trace de Noise //
Pbindef(\s, \rel, Pwhite(0.1,0.5), \relC, Pwhite(0,12) ).play(quant:[3, 1.25])

Pbindef(\s, \dur, 2 + Pwrand([0, Pseq([ -1.75, 0.25 ]) ], [0.8, 0.2],inf))


////////////////////////////////////////























///////// NO //////

~k.stop; ~k = Pbindef(\k, \instrument, \ki, \amp, 0.5, \rel, 0.05, \dur,  Pfunc({ ~rotb.([16].choose, [1].choose,)})).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1]);

Pbindef(\k, \dur,  Pfunc({ ~rotb.([6].choose, [1.5, 0.25, 3].choose, 1)}) )
Pbindef(\k, \dur, Pseq([1/4, 3/4, 1/2],inf))

Pbindef(\blip, \instrument, \bipfm, \dur, Pfunc({ ~lastKick[\dur] }), \freq, 1200, \fmrate, Pwhite(0, 0.1), \sus, Pif( Pkey(\dur) > 0.75, Pkey(\dur)*0.8, 0 ), \rel, 0.05).play(quant:[4, 0]);

Pbindef(\bip, \dur, Pseq([ Pseq([1/4],8), 1],inf), \rel, Pkey(\dur)*0.1, \sus, Pkey(\dur) * 0.8 ).play

Pbindef(\sh, \instrument, \shk, \dur, Prand([ 1/8, 1/8, 1/4, 3/8, 1/8],inf), \amp, Pwhite(0.05,0.2), \freq, [5800, 5780] + Pwalk((0..2000), Pseq([ Prand([1, 2, 4, 6],30), Prand([-5, -2, 0, 2, 5],inf ) ],inf ) ), \rel, 0.08, \rq, 0.125 ).play;

Pbindef(\sh, \instrument, \shk, \dur, Pfunc({ ~lastKick[\dur] / [1,2].choose }), \amp, Pwhite(0,0.1), \freq, [2200, 2280]).play;

Pbindef(\s, \instrument, Prand([\snare, \snaredel],inf), \dur, Pfunc({ ~lastKick[\dur] * 4 }), \sus, Pwhite(0, 0.25), \rel, Pif(Pfunc{~lastKick[\dur] > 1}, Pfunc({~lastKick[\dur] * (0.5 + 0.5.rand)}), 0.15 ), \cutoff, 0.00175, \fq, [1000, 188] * Pwhite(0.9, 1.5), \delfq, 0.03, \delvit, Pwhite(0.0001, 0.05), \deldur, Pwhite(0,0.5) ).play.stop


Pbindef(\bip, \sus, Pif( Pfunc({~lastKick[\dur] > 0.5 }), Pfunc({~lastKick[\dur] }), 0, 0 ))

