(
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


SynthDef("kick", {arg out=0,amp=0.5,pan=0,att=0.02,rel=0.2, sus=0,attC=0, relC=6,
	freqA=2840,freqB=61,freqC=33,freqAC=(-4.85),freqBC=(-12);
	var env, sweep, sig, fm;
	env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).ar(2);
	sweep = Env([freqA,freqB,freqB,freqC],[att,sus,rel],[freqAC,0,freqBC]).ar;
	// sweep = sweep * LFSaw.kr(90,1);
	sig = Mix.fill(4, {arg i; LFPar.ar(sweep * ( 1 + (i*0.12)), pi*(i*0.66),(0.5/(i+1.25)))});
	// fm = LFSaw.ar(604 * LFNoise0.kr(),0, LFClipNoise.kr(100,0.5));
	fm = RLPF.ar(fm, 682 , 0.01,0.1); // <-- change le filtre

	sig = sig * env * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;


SynthDef("kick-adsr", {arg out=0,amp=0.5,pan=0,att=0.02,dec=0, rel=0.2, sus=0,attC=0, relC=6,
	freqA=2840,freqB=61,freqC=33,freqAC=(-4.85),freqBC=(-12);
	var env, sweep, sig, fm;
	env = Env([0,1,0.25,0.25,0],[att,dec, sus,rel],[attC,0,relC]).ar(2);
	sweep = Env([freqA,freqB,freqC,freqC],[att,sus,rel],[freqAC,0,freqBC]).ar;
	// sweep = sweep * LFSaw.kr(90,1);
	// sig = Mix.fill(2, {arg i; LFPar.ar(sweep * ( 1 + (i*0.12)), pi*(i*0.66),(1/(i+1.25)))});
	sig = SinOsc.ar(sweep);

	fm = LFSaw.ar(604 * LFNoise0.kr(),0, LFClipNoise.kr(100,0.5));
	fm = RLPF.ar(fm, 682 , 0.01,0.1); // <-- change le filtre
	// sig = sig * (fm + 1);
	sig = sig * env * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef("bip", {
	arg out=0, att=0.001, rel=0.05, freq=80, pan=0, sus=0, amp=0.1;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	sig = SinOsc.ar(freq, pi/2);
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(out,sig);
}).add;


SynthDef("bipfm", {
	arg out=0, att=0.001, rel=0.05, freq=80, pan=0, sus=0, amp=0.1, fmrate=0, dur=0.1;
	var sig, env, fm, duration;
	duration = att + rel + sus;
	fm = LFPar.kr(duration+dur / Rand(1, 50), 0.5).range(-6, 2.5) * fmrate;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	sig = SinOsc.ar(freq*(fm+1), pi/2) + Saw.ar(freq/2*(fm+1));
	sig = Ringz.ar(sig, freq*fm + LFPar.kr( dur+duration).range(100, 1200), LFTri.kr( Rand(0.6, 18) ).range(0, 0.0125), 0.1) + sig / 2;
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(out,sig);
}).add;

// Blip
SynthDef("blip",{arg out=0,freq=60,nharm=3,amp=0.5,pan=0,att=0.003,rel=0.002,phase=0,sus=0;
	var env = Env([0,1,1,0],[att,sus,rel]).ar(2);
	// panoramic = pan;
	Out.ar(out,Pan2.ar(Blip.ar(freq,nharm) * env,pan, amp));
}).add;

// Noise
SynthDef("noise", {arg out=0,bw=1.5, amp=1, pan=0, freq=1800,
	att=0.001, rel=0.5, sus=0.02, attC=20,relC=(-6);
	// freqA=30000, freqB=80, freqC=3500,  attSweep=0.1, relSweep=0.15, attSweepC=0, relSweepC=0;
	var sig, env, sweep;
	env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).kr(2);
	// sweep = Env([freqA, freqB, freqC], [attSweep, relSweep], [attSweepC,relSweepC]).kr(2);
	// sig = BBandPass.ar(PinkNoise.ar(),sweep,bw * env,1/bw);
	sig = BBandPass.ar(PinkNoise.ar(),freq,bw * env,1/bw);
	Out.ar(out,Pan2.ar(sig * env,pan, amp));
}).add;

SynthDef("clic", {
	arg att=0.001, rel=0.2, freq=800, pan=0, sus=0, amp=0.1, rq=0.25;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	sig = BPF.ar( ClipNoise.ar(1), freq, rq, 1/rq.sqrt);
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(0,sig);
}).add;

// Snare
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


// Snare
SynthDef("oldsnare", {arg out=0,amp=1,fq=320, hifreq=1020, noiseDecay=0.002,pan=0,
	att=0.001,dec=0.01, rel=0.1,attC=(0),decC=0,relC=(-12),sinDel=0,
	noiseAtt= 0.002,noiseRel= 0.3, noiseAttC=(\wel),noiseRelC=(\wel),noiseDel=0,
	crash = 0.1;
	var sig, sin, env, noise, noiseEnv,harms, noiseAmp;
	noiseAmp = amp/1.5;
	env = Env([0,0,1,0.5,0],[sinDel,att,dec,rel],[0,attC,decC,relC]).kr();
	noiseEnv = Env([0,0,1,0.7,0],[noiseDel, att,dec, rel],[0,attC,decC,relC]).kr(2);
	harms = [0.9,1,1.1];
	sin = Mix.fill(harms.size, {arg i; LFSaw.ar(fq*harms[i],pi/2,1/((i*0.5)+1.5));});
	// sin = Mix.fill(harms.size, {arg i; LFSaw.ar(fq*harms[i] * LFNoise1.kr(20).range(1,4), pi/2, 1/(i*0.5+1.5))});
	sin = sin * env * amp;
	noise = Mix.ar([ClipNoise.ar(0.3), Dust2.ar(fq*50,0)]);
	noise = Mix.ar([ Ringz.ar(noise,fq, noiseDecay), Ringz.ar(noise, hifreq, noiseDecay) ]);
	noise = noise * noiseEnv * noiseAmp;
	sig = Mix.new([sin, noise]);
	Out.ar(out, Pan2.ar(sig, pan));
	DetectSilence.ar(sig, 0.00001, crash, 2);
}).add;

SynthDef("clap",{
	arg out=0, att=0.001, rel=0.5, relC = -12, pan=0, amp=0.2, fq=900, del=0.05, rq=0.2;
	var sig, env, enva, envb, envc;
	env = Env.perc(att, rel, amp, relC).kr(2);
	enva = DelayN.ar(env,0.2,del*2);
	envb = DelayN.ar(env,0.2,del);
	envc = DelayN.ar(env,0.2,del*3);
	sig = Mix.fill(6,{arg i; var delay;
		delay = DelayN.ar(env, 0.2, rrand(0,del));
		BPF.ar(ClipNoise.ar(), fq * Rand((i*0.25) + 1, (i*0.25) + 1.1), rq, 1 + (1/rq) * (1/6)) * delay;
	});
	sig = sig!2;

	Out.ar(out, sig);
}).add;



SynthDef("nkick", {arg out=0,amp=0.5,pan=0,att=0.02,rel=0.2, sus=0,attC=0, relC=6, freq=220, fb=2,
	freqA=2840,freqB=61,freqC=33,freqAC=(-4.85),freqBC=(-12);
	var env, sweep, sig, fm;
	env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).ar(2);
	sweep = Env([freqA,freqB,freqB,freqC],[att,sus,rel],[freqAC,0,freqBC]).ar;
	// sig = Mix.fill(4, {arg i; LFPar.ar(sweep * ( 1 + (i*0.12)), pi*(i*0.66),(0.5/(i+1.25)))});

	sig = Mix.fill(5, {arg i; SinOscFB.ar(sweep * (4/i+1), fb*env) } );

	sig = sig * env * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;


SynthDef("nclap",{
	arg out=0, att=0.001, rel=0.5, relC = -12, pan=0, amp=0.5, fq=900, del=0.05, rq=0.2;
	var sig, env, enva, envb, envc;
	env = Env.perc(att, rel, amp, relC).kr(2);
	enva = DelayN.ar(env,0.2,del*2);
	envb = DelayN.ar(env,0.2,del);
	envc = DelayN.ar(env,0.2,del*3);
	sig = Mix.fill(6,{arg i; var delay;
		delay = DelayN.ar(env, 0.2, rrand(0,del));
		BPF.ar(ClipNoise.ar(), fq * Rand((i*0.25) + 1, (i*0.25) + 1.1), rq, 1 + (1/rq) * (1/6)) * delay;
	});
	// sig = sig * SinOsc.ar(777, pi/2, 0.1, Saw.ar(fq, sig * (-2.5) + 0.5) ) ]) ; // calme
	// sig = sig min:0.125 max:-0.125	* 1.5;
	sig = Ringz.ar(sig, LFSaw.kr(180).range(50, 200), 0.1 ,0.1, sig) / 1.5;
	sig = sig!2;

	Out.ar(out, sig);
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

~rotb = {arg quant = 2, rest = 0.5, brk=1; var ttnb = TempoClock.timeToNextBeat(quant); if( ( ttnb > rest) , { TempoClock.tempo / [3, 4, 5].choose}, {ttnb / rrand(1,brk) + 0.05 max:0.05} ) };
~tnb = {TempoClock.timeToNextBeat max:0.05};

// t = PdefAllGui();
)

TempoClock.default.nextBar - TempoClock.default.beats % 4

~onBeat.(4)

Pdef.clear


Pdef.removeAll

~nstop.()

t = PdefAllGui(8);

~varia = {LFPar.kr( LFNoise1.kr(0.0125,0.25)) * 0.2 }.play

~changeTempo = { TempoClock.tempo = (4.rand + 1 /2 ).postln}


TempoClock.tempo = ((4.rand+1) / (4.rand+1) ).postln
TempoClock.schedAbs(TempoClock.nextBar, TempoClock.tempo = ([1,2, 0.5, 0.25, 1/5].choose).postln )
TempoClock.tempo = 2


TempoClock.tempo = 1


// PHASING KICKS /////////////////////////////////////
~gfree.(); ~pstop.(); ~nstop.();
(~ksines = ~ksines.addAll(Synth("kick-adsr", [
	\att, 0.01,
	\dec,0.05,
	\rel, 20,
	\relC, 0,
	\sus, 0,
	\freqA, rrand(360,250) + 100,
	\freqB, rrand(80.0,90) ,
	\freqC, rrand(45.0,56) + 40 + 20.0.rand,
	\freqBC, -40.rand,
	\amp, 0.4])
))



~gfree.()

TempoClock.tempo = 1
Pdef.clear

// KICK //////////////////////////////////////////////

Pbindef(\k, \instrument, \kick, \amp, 0.6, \rel, 0.15, \freqBC, -4, \freqB, 96, \freqC, 38)
Pbindef(\k,\dur, Pseq([3/4, 5/4],inf))
Pbindef(\k, \dur, 1/2).play
Pbindef(\k, \dur, 1/100)

(Pbindef(\k, \dur, Prand([
	Pseq([3/4, 5/4],2),
	Pseq([Prand([ Pseq([1/4],2), Pshuf([ 3/8, 1/8 ]) ]), 1/2 ]),
	Pseq([1/3],3),
	Pseq([1/8, 1/4, (1/2) + (1/8)]),
	// Pseq([1/2, 1/2])
], inf)))



/* Algorythmize */
~k.stop; ~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1]);

Pbindef(\k, \freqB, 96 + Pseq((0..300),inf)) // Monte en freq

Pbindef(\k, \rel, 0.1)


Pbindef(\k, \freqB, 126, \freqC, 46, \rel, 0.15, \freqBC, -6) // Stabilise freq


Pbindef(\k, \dur, Prand([ Pseq([1]), Pseq([3/4, 3/4, 2/4] /*edit*/ ,2)],inf) )


// Milford Graves
Pbindef(\k, \dur, (Pwalk( (0..200)/1000, Pseq([Pwhite(-10,10,1), 0],inf), 1, 100) * Pseq([1,-1],inf)) + Pseq([0.5, 0.5, 3/4] /* speed up */  * 1,inf) , \rel, 0.2 )

~k.play

// complexe deep pre batuk
Pbindef(\k, \rel, 0.125, \dur, Pseq([ Pseq([1/4], 8) , Pseq([ 1/2, Prand([1/2, 1/4, Pseq([1/8],4), Pseq([1/3],3), 1]), Prand([1/4,  1/2, Pseq([3/4, 1/4]) ]) ],inf)]) )


TempoClock.tempo = 0.5;
Pbindef(\k, \dur, 1/3000)
Pbindef(\s).stop

// AUTO KICK ///////////////////////////////////////////
( // Préparer les patterns
/*Pbindef(\k, \instrument, \kick, \amp, 0.6, \rel, 0.3, \freqBC, -12);*/
Pbindef(\k, \dur, Pseq([
	Prand([
		Pseq([3/4, 3/4, 1/2 ],4),
		Pseq([3/4, 5/4],4)
	],4),
	Pseq([1/6],12),
	Pwrand([
		Prand([ Pseq([1/6],6), Pseq([1/6],12)]),
		Pseq([ 3/4, 3/4, 1/2 ],2),
		Prand([ Pseq([1/2], 8), Pseq([ 1/2 ], 4)]),
		Prand([ Pseq([1]), Pseq([3/4, 3/4, 2/4],2)],4),
		Pseq([ 1/2, Prand([	1/2, Pseq([1/4, 5/4]), Pseq([1/4], 2), Pseq([1/8],4), Pseq([1/3, 1/3, 1/2, 1/3],2), 1	]) ],8),
		Prand([1, Pseq([1/5, 0.175, 1/8, 1/4,1/8, 1/8, 1/5, 0.175, 1/8, 1/2]), Pseq([1/3, 1/6, 1/2],3)],8),
		Pseq([
			Pseq([1/4, 1/2, 3/4, 1/2],3),
			Prand([ Pseq([1/3],3), Pseq([1/3],6)])
		], 8),
		Prand([ Pseq([ 1/4, 1/4, 1/4, 1/2, 1/4, 1/4, 1/4],2), Pseq([1/5, 0.175, 1/8, 1/2]), Pseq([1/5, 0.175, 1/8, 1/4,1/8, 1/8]) ],4)
	],
	[0.25, 0.5, 1.25, 1, 0.75, 0.25, 1, 0.5].normalizeSum
	,inf)
])
 );

Pbindef(\hot, \instrument, \bip, \freq, [600, 573, 577, 601, 603] * Pseq([ Pseq([1], 15 ), Pseq([[0.7, 0.8678, 0.979, 1, 1.13, 1.672, 4, 3.74]]) ],inf), \amp, 0.035, \dur, 1/6);
Pbindef(\p, \instrument, \bip, \freq, 1111 * ({rrand(0.5,2)}!10), \rel, 0.02, \amp, 0.05, \pan, [-1, 1]);

Pbindef(\hot, \dur, Pfunc({~lastKick[\dur]}) * Pwrand([1, 0.5, Pshuf([3/4, Prand([1/4, 5/4])]) ], [0.5, 0.4, 0.1],inf));

Pbindef(\p, \dur, Pfunc({~lastKick[\dur]}) / Pwrand([1, 2], [0.75, 0.25],inf) );

~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;})

)

// Définir un routine qui coupe tout et lance le kick
(
~brk = Routine{
	"Patience".postln;
	(60*2).wait;
	"Top".postln;
	// Coupe tout
	~gfree.(); ~pstop.(); ~nstop.(); Synth.new("snare", [\amp, 0.8, \rel, 0.05,\att, 0.001, \pan,0, \relC, 3, \fq, 335, \cutoff, 0.0125]);
	3.wait;
	~k.play(quant:[4, 0, 0.1]);
	10.wait;
	Pbindef(\hot).play(quant:[4]);
	Pbindef(\p).play(quant:4);
}; ~brk.play
)

Pbindef(\k).stop


 // Ligne droite
Pbindef(\k, \dur, 1/2)
Pbindef(\k, \dur, 1)
Pbindef(\k, \dur, Prand([ Pseq([1/2],4), Prand([ Pseq([1/4], 8), Pseq([1, Prand([1/8, 1/2, Pseq([3/4, 1/4])],4) ]) ]) ],inf) )

Pbindef(\k, \freqB, 96, \freqC, 36, \rel, 0.15, \freqBC, -6) // Stabilise freq

// PLOCS ////////////////////////////////////////////


(Pbindef(\hot, \instrument, \bip, \freq, [600, 573, 577, 601, 603] * Pseq([ Pseq([1], 15 ), Pseq([[0.7, 0.8678, 0.979, 1, 1.13, 1.672, 4, 3.74]]) ],inf), \amp, 0.02, \dur, 1/6);
Pbindef(\p, \instrument, \bip, \freq, 1111 * ({rrand(0.5,2)}!10), \rel, 0.02, \amp, 0.02, \pan, [-1, 1]);)

(Pbindef(\hot, \dur, Pfunc({~lastKick[\dur]}) * Prand([1, 0.5, Pshuf([3/4, Prand([1/4, 5/4])])],inf));
Pbindef(\p, \dur, Pfunc({~lastKick[\dur]}) / Prand([2],inf) ))

Pbindef(\hot, \dur, Pfunc({~lastKick[\dur]}) * Prand([1, 0.5, Pshuf([3/4, Prand([1/4, 5/4])])],inf));
Pbindef(\p, \dur, Pfunc({~lastKick[\dur]}) / Prand([2, 2, 1.5],inf) ).play

(Pbindef(\hot, \dur, 1/8);
Pbindef(\p, \dur, 1/4))

~pstop.();

(~k.stop; ~k.play(quant:4);
Pbindef(\hot).play(quant:[4]);
Pbindef(\p).play(quant:4))

(Pbindef(\vent, \instrument,\noise,\dur, 0.08,\freq, 30000, \sus, 0.000,\attSweepC, 20,\bw,Pwhite(0.1,0.005),\amp,Pseq([Pseq((1..250))*0.00035, Pseq([0.125],inf)]), \relC,-20).play(quant:8);
Pbindef(\vent2, \instrument,\noise,\dur,0.081,\sus,0,\freq, 30000, \rel,0.025,\att,0,\bw,0.002,\amp,Pseq([Pseq((1..150))*0.00035, Pseq([0.075],inf)]), \pan, Pwhite(-1.0,1)).play(quant:8);)

Pbindef(\p, \amp, 0.035).stop
Pbindef(\hot, \amp, 0.05).play

// Pbindef(\p, \dur, Pseq( [ Pseq([1/6], 6 ),  Pfuncn({ ~lastKick[\dur] / 4 }, 4 ) ], inf))
Pbindef(\p, \sus, Pif( Pfunc({~lastKick[\dur]}) > (2/4), Pkey(\dur) * 0.125, 0, 0) )
Pbindef(\p, \sus, 0).clear

Pbindef(\hot, \dur, Prand([ Pseq([ 1/6 ], 6), Pfuncn({~lastKick[\dur] / 2 }, 2) ], inf))
Pbindef(\hot, \rel, Pif(Pfunc({~lastKick[\dur] >= (3/4)}), Pwhite(0.1, 0.5), Prand([ 0.05, Pkey(\dur)/2]), 0.05))
Pbindef(\hot, \detune, Pif( Pfunc({ ~lastKick[\dur] < (3/4)}), Pwalk((0..50)*50, Pwhite(-2, 2), 1, 0), [0, 20], 0) , \rel, 0.2)

Pbindef(\p, \dur, Pfunc({ ~lastKick[\dur]}) / Pwrand([1,Pseq([4],4), Pseq([2],2), Pseq([3],3)], [0.7, 0.1, 0.1, 0.1], inf)).play(quant:4)
Pbindef(\p, \dur, Pfunc({ ~lastKick[\dur]}) / Pif( Pfunc({ ~noKick.(3/4) || (~nextBeat.(8) < 0.25) }),  Prand([2, 3, 5],inf), 1,1) )

Pbindef(\p, \detune, Pif( Pfunc({ ~noKick.(3/4) && (~nextBeat.(4) < 0.5) }), Pstutter(6, Pwhite(10,500)) ,0) )

Pbindef(\p, \dur, Prand([ Pseq([1/8],8), Pseq([1/3],3), Pseq([1/7],7), Pseq([1/4],8), Pseq([1/2], 4)], inf)).play(quant:4)

Pbindef(\hot).stop

/* Snarifize */
Pbindef(\k, \instrument, Pseq([ \kick,\kick, \kick, Prand([\kick,\kick,\snare])],inf), \rel, 0.2)
Pbindef(\k, \instrument, Pseq([ \kick, Prand([\kick, \snare])],inf)).play // ++
Pbindef(\k, \instrument, \kick) // Sans snare


/* Montée en freq */
Pbindef(\k, \freqB, 96 + Pseq((0..300)),inf) // Monte en freq
Pbindef(\k, \freqC, 33 + Pseq((0..200),inf) )
Pbindef(\k, \freqB, 61, \freqC,  LFSaw.kr(0.4) ).range(0.05, 0.6) , 0, LFSaw.kr(10.5) * LFPulse.kr(15) * LFSaw.kr(3)) * 0.2;
}).play)33) // raz


~k.play(quant:4)


// HAT /////////////////////////////////////////////////////////
Pbindef(\h, \instrument, \noise, \freq, [440, 820, 2800, 3200], \bw, 0.01, \att, 0.001, \amp, 0.03, \rel, 0.045)

Pbindef(\h, \dur, 1/8, ).play(quant:[4,0.5])
Pbindef(\h, \dur, Pseq([ Pseq([1/8],4), /*Pseq([1/4], 2), */ Pseq([1/6],3) ],inf))
Pbindef(\h, \dur, 1/16, \amp, 0.04).play(quant:4)
Pbindef(\h, \dur, Prand([ Pseq([ 1/8],8), Pseq([1/16],16)],inf) )

/* Algo */
Pbindef(\h, \dur,Pstutter(Pwhite(1,4)*2, Prand([1/6, 1/4, 1/8, Pseq([1/8],4)],inf)) , \amp, Pwhite(0.02,0.05), \rel, Pwhite(0.01,0.1) + Pfunc{ if(~lastKick[\dur] >= (3/4)) { rrand(0.1,0.5)} {0.045} } ).play(quant:4)


// KICK POUR SNARE
Pbindef(\k, \instrument, \kick)

// complexe deep pre batuk
Pbindef(\k, \rel, 0.2, \dur, Pseq([ Pseq([1/8], 8) , Pseq([ 1/2, Prand([1/2, 1/4, Pseq([1/8],4), Pseq([1/3],3), 1]), Prand([1/4,  1/2, Pseq([3/4, 1/4]) ]) ],inf)]) )

// CLAPPY SNARE ///////////////////////////////////////////
Pbindef(\s, \instrument, \snare, \dur, Prand([1, 1, 1.5],inf), \amp,0.2, \relC, -6, \rel, 0.3, \cutoff, Pstutter(8, Pwhite(0.01, 0.05)))
Pbindef(\s).play(quant:[4, 1])

Pbindef(\s,\dur, 2, \amp, 0.5, \cutoff, 0.01, \rel, 0.4).

/* crazy drummer */
Pbindef(\s,\instrument, \snare, \amp, Pwhite(0.0, 0.0125) + Pseq([ Pseq((0..5000)/5000), Pseq([1],inf) ]), \dur, Pwrand([1/8,1/4], [0.85, 0.15],inf), \rel, Pwhite(0.1,0.3) ).play(quant:[4, 1])

Pbindef(\s, \dur, Pwrand([1/8, Pseq([1/16],2), 1/4], [0.925,0.025, 0.05], inf), \rel, Pwhite(0.05,0.2), \amp, Pwhite(0.001,0.15) )

Pbindef(\s, \dur, Pif( Pfunc({~lastKick[\dur] <= (1/8) }), Pfunc({~lastKick[\dur] * 1.5 }),  Pwrand([1/8, Pseq([1/16],2), 1/4], [0.925,0.025, 0.05],inf) ), \rel, Pwhite(0.05,0.2), \amp, Pwhite(0.001,0.15) )

// accent au début des 8 temps
Pbindef(\s, \amp, Pif( Pfunc({~nextBeat.(8) <= 0.0125}), 0.2, Pwhite(0.001,0.2)))

Pbindef(\s, \cutoff, Pfunc({ rrand(0.001, ~nextBeat.(4)/10 )}) + (Pkey(\amp)/50) )

Pbindef(\s, \dur, 1/8, \rel, 0.1)

Pbindef(\k, \dur, 1/8)
Pdef.gui

Pbindef(\s, \amp, Pkey(\dur)/2 * Pwhite(0.8, 1.2))
Pbindef(\s, \rel, Pkey(\dur) * Pwhite(0.8,1.2))
Pbindef(\s, \cutoff, ( Pkey(\dur)/2 ))

/* Variable amplitude */
Pbindef(\s, \amp, Prand([0.5, 0.1,0.2, 0.7],inf)  / 4 )


/* Speed up */
Pbindef(\s, \amp, 0.5, \rel, 0.25, \cutoff, 0.02, \dur, Pseq([1, 1, Prand([Pseq([1, 1]), Pseq([1/4, 3/4]), /*Pseq([1/3, 4/6,2/3, 2/6])*/ ])],inf))

/* plus sec */
Pbindef(\s, \cutoff, 0.0075, \rel, 0.25)

/* plus gras plus souvent */
Pbindef(\s, \amp, 0.5, \hifreq, 5000, \cutoff, Pwhite(0.005, 0.1), \rel, Pwhite(0.05, 0.5))


/* + */
Pbindef(\s, \dur, 1/4)

Pbindef(\s, \dur, Prand([1/2, 1/3, 2/3, 2/6],inf))
Pbindef(\s, \dur, (1 / (Pexprand(1,8)*2)).trace )

Pbindef(\s, \cutoff, 0.025, \fq, 420)

Pbindef(\s, \dur, 1, \amp, 0.4)
Pbindef(\s, \dur, Pseq([1/2, 1/2, 1, 1/4, 3/4, 1/2, 1/2],inf))

/* Vague w/ variable freq */
Pbindef(\s, \hifreq, Pwhite(1330, 660), \rel, Pwhite(0.5, 1), \noiseDecay, 0.01, \noiseRel, 0.5, \dur, 4)

/* Algorythmize */
~s = Pbindef(\s).stop.collect({|e| ~lastSnare = e;}).play(quant:[4, 0, 0.05])



// FEELLLLLL ///////////////////////////////////////////////////
~pstop.();

TempoClock.tempo = 1

~pplay.()

Pbindef(\s).stop; ~k.stop
~k.play; TempoClock.tempo=1;

Pbindef(\k, \dur, Pseq([ Pseq([1/8],8), Pseq([ 1/3 ], 3) ],inf)); Pbindef(\s, \dur, Pseq([3/4, 5/4],inf), \amp, 0.1, \rel, Pwhite(0.15,0.3), \relC, Pwhite(-3, 6.0), \cutoff, Pseq([0.1, 0.001],inf) );
Pbindef(\p).stop; Pbindef(\hot).stop;
Pbindef(\feel, \instrument, \bip, \freq, {rrand(690, 1200)}!4, \dur,Pfunc({~lastKick[\dur] }) / Prand([1.5, 2],inf), \amp, 0.05, \rel, Pwhite(0.01,0.1)).play(quant:[4,1/3])


Pbindef(\feel, \dur, Pstutter(Pwhite(1,4)*2, Prand([1/6, 1/4, 1/8],inf)) )

Pbindef(\feel, \dur, Pstutter(Pwhite(1,4)*2, Prand([1/8,1/3, 1/2, 1/4, 1/8, 1/12, 1/16],inf)))

Pbindef(\feel, \rel, Pwhite(0.01, 0.2) * Pkey(\dur), \freq, {rrand(700, 900)}!4 * Pwhite([1, 1], [1, 0.9]))

/* Algoryrhmize */
Pbindef(\feel, \dur, Pfunc({ ~lastKick[\dur] }))

Pbindef(\h, \rel, Pfunc({if (~lastKick[\dur] >= (1) ) { rrand(0.5,2)} {rrand(0.01,0.1)} } ) ).play

Pbindef(\h, \detune, Pfunc({if (~lastKick[\dur] >= 1 ) { rrand(-30.0, 100.0)} {0} } )  )

Pbindef(\s, \stretch, Pfunc( { if (~lastKick[\dur] >= 1) {4} {1} } ))
Pbindef(\s, \rel, Pfunc( { if (~lastKick[\dur] >= 1) {rrand(0.5,1)} {rrand(0.01,0.3)} } ))
Pbindef(\s, \amp, Pkey(\dur).ceil)



Pbindef(\k, \dur, Prand([1/4, 1/8],inf), \amp, 0.5, \rel, 0.2, \relC, -1)
Pbindef(\k, \dur, Prand([1/4, 3/4, 5/4],inf), \amp, 0.6)

Pbindef(\k, \dur, Pstutter(8, Prand([1/4, 1/8],inf)), \rel, 0.1)

~k.play(quant:4); Pbindef(\k, \dur, 1/8, \instrument, Pstutter(Pwhite(1,2), Pwrand([\kick, \bip,\clap,\snare], [0.4, 0.2, 0.3, 0.1] ,inf)) )

Pbindef(\k, \dur, Pwrand([1/8, 3/4],[0.9, 0.1], inf))

~k.stop

(~pstop.(); ~k.play(quant:4);
Pbindef(\tot, \instrument, \blip, \freq, {rrand(390, 800)}!4, \dur, Pstutter(Pwhite(1,4)*2, Prand([1/8,1/3, 1/2, 1/4, 1/8, 1/12, 1/16],inf)), \amp, 0.15, \rel, Pwhite(0.005,0.1)).play();


Pbindef(\tot, \sus, Pfunc{ if ((~lastKick[\dur] >= (3/4)) && 0.25.coin) {rrand(0.051,0.5)} {0}}, \dur, Pfunc({ ~lastKick[\dur] / 2 }) ))

Pbindef(\k, \instrument, \kick)


Pdef.gui
~pplay.()

Pbindef(\h, \rel, 0.025).play



Pbindef(\k, \instrument, \kick)


Pbindef(\k, \dur, Pwrand([1/8, 1.5, 1],[0.8, 0.1, 0.1].normalizeSum, inf)); ~k.play

(Pbindef(\snark, \instrument, \snaredel, \pan,Pwhite(-1.0,1),\dur,Prand([1,2],inf),\rel,Pwhite(0.1,1),\relC,-12,
	\deldur,Pwhite(0.05,0.3),\delvit,Pwhite(0.01,0.5),\delfq,Pwhite(1,30),
	\amp,Pwhite(0.5,0.7),\ff,Pwrand([Pwhite(10,100,1), Pwhite(2000,5000,1)],[0.7,0.3],inf)
).play(quant:[4,2]))



Pbindef(\snark, \dur, Pseq([1/4,3/4],inf))

Pbindef(\snark, \dur, Pfunc{~lastKick[\dur]} / Prand([1,2],inf) , \amp, Pfunc{ if (~noKick.(1)) {rrand(0.7, 1)} {0} }, \deldur, Pfunc{~lastKick[\dur]} / Prand([1, 2],inf) )


Pbindef(\snark, \rel, Pfunc{ if ((~noKick.(2/6)) && (0.5.coin)) {rrand(0.1,0.35)} {rrand(0.001,0.1)}})

Pbindef(\snark, \amp, 1)
Pbindef(\snark).stop.clear;

Pbindef(\h).stop; Pbindef(\hot).stop; Pbindef(\p).stop;

// Très vénère
Pbindef(\k,  \instrument, \kick, \rel, Pkey(\dur)*0.2, \amp, 0.5, \freqB, 219,\freqA, 6000, \freqC, 33, \dur, 1/2);

/*Pbindef(\temp, \instrument, \bip, \dur, 1/4, \freq, [1500, 650, 325], \amp, 0.075).play(quant:1);
Pbindef(\temp, \dur, Pwrand([Pseq([1/2],2), Pseq([1/8],8)], [0.9, 0.1], inf))*/


Pbindef(\k, \dur, Pseq([Pshuf([0.35, 1/2.5]), 1/4, 1/2, 1/4, 1/4], inf), \rel, 0.15)

Pbindef(\k, \dur, 1)

// Batukadize
Pbindef(\k ,\dur, Pseq([1/5, 0.175, 1/8, 1/2]*2,inf))

Pbindef(\k, \dur, Pseq([1/5, 0.175, 1/8, 1/4,1/8, 1/8, 1/5, 0.175, 1/8, 1/2] * 2,inf))

Pbindef(\k, \dur, Prand([1, Pseq([1/5, 0.175, 1/8, 1/4,1/8, 1/8, 1/5, 0.175, 1/8, 1/2]*1)], inf))

Pbindef(\k, \dur, Pseq([ Pseq([1/8],8), Pseq([1/2,1/4,1/2],4)],inf), \relC, -3)

Pbindef(\s, \instrument, \snare, \dur, 2, \rel, 0.3, \relC, 6, \cutoff, 0.5).play(quant:([4,1]))

Pbindef(\hs).stop; Pbindef(\s).stop

Pbindef(\k, \dur, 4, \amp, 1, \freqB, 70, \rel, 1)

/* Algorythmize */
~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1])

// HARD SNARE

Pbindef(\hs, \instrument, \snare, \dur, Pseq([2, Pshuf([ 1/8, 1/4, Prand([2, 4, 1/8],1) ]) ],inf), \fq, 600, \cutoff, Pwhite(0.001,0.05) , \rel, 0.1, \relC, 36, \amp, 0.25).play

Pbindef(\hs, \dur, Pseq([4, 1/4, 7/4, 8],inf))
Pbindef(\hs, \dur, 1/8, \amp, Pexprand(0.5, 0.00001))

Pbindef(\hs, \amp, Pfunc{ if (~noKick.(3/4)) { rrand(0.0001, 0.25)} { rrand(0.00001, 0.05) } })


// GROOVES & BREAKS//////////////////////////////////

(Pbindef(\k, \dur,
	Pseq([ Pseq([1/8],16),
		Pseq([
			Pseq([1/3],2),
			Pseq([1/4],1),
			// Pseq([1/6],2)
		],inf)
],inf);))

~k.play(quant:4)

Pdef.gui
Pbindef(\k, \relC, -6, \freqA, 3000)

(Pbindef(\k, \dur,
	Pseq([
		(1/6),
		Pwrand([
			Pseq([1/4, 2/6, 1/4]),
			Pshuf([ Pseq([((2/6)+(1/4)) / 5],5), 1/4])]
		, [0.8,0.2]) // < change weights
		,Pwrand([ 1/4,Pseq([1/4, 1])], [0.9,0.1])
	],inf)
))

/* Algorythmize */
~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1])

/// NEW TEK //////////////////////////////////////////////////////////
~k.stop
Pdef.removeAll

TempoClock.tempo = 1

~pplay.()

Pbindef(\k, \instrument, \kick, \freqB, 180, \freqBC, -20, \freqC, 60, \rel, 0.4, \dur, Pseq([1/2, 1/5, 1/5, 1/2, 3/5],inf) ,\amp, 0.5).play(quant:4)

Pbindef(\kk, \instrument, \bip, \detune, Pwalk( (1..1000), Prand([1, 2, 0, -1, -2],inf), 1, 200), \rel, 0.125, \dur, 1/16, \freq, [1902, 1839, 1298, 766, 677, 4000] * 1 * Pseq([1,3],inf), \amp, 0.015).play(quant:4)


Pbindef(\kk, \dur, Pif( Pfunc({~noKick.(1/2)}), Prand([1/16, 1/8 ],inf), 1/16), \rel, Pif( Pfunc({~noKick.(1/2)}), Pwhite(0.125, 0.3), 0.125) )
Pbindef(\k, \dur, Prand([ Pseq([3/4],4), Pseq([1/2, 1/5, 1/5, 1/2, 3/5])],inf) )
Pbindef(\k, \dur, Prand([ Pshuf([1/8, 1/4],6), Pshuf([1/5, 1/10, 1/10, 2/5]), Pshuf([ 1/8, 1/8, 1/4, 1/2]) ],inf))

Pbindef(\kk, \dur, Pif( Pfunc({~noKick.(3/4)}), Pfunc({~lastKick.()}), 1/16), \rel, Pif( Pfunc({~noKick.(1/2)}), Pwhite(0.125, 0.3), 0.125) )

Pbindef(\k, \rel,0.1, \dur, Pseq([1, Prand([ Pshuf([1/8, 1/8, 1/6, 1/4, 1/6, 1/6]), Pseq([1/9],9), Pseq([1/7],7), Pseq([1/8, 1/4, 1/8],2) ]) ],inf))

Pbindef(\kk, \dur,Pfunc({~lastKick[\dur]}) / Pif( Pfunc({~lastKick[\dur] < (3/4) }), Pwhite(1.25,5), Pwhite(1,3) ,1 ), \sus, Pif( Pfunc({~lastKick[\dur] < (3/4)}), 0, Pwhite(0 ,Pkey(\dur)*1.5)), \rel, 0.1).play
Pbindef(\kk , \detune, Pif( Pfunc({~lastKick[\dur] > (3/4)}), Pwhite([0, 50, 100], [10, 400, 600]), 0,0))
Pbindef(\kk, \dur, 1/16, \rel, 0.1, \sus, 0).play

Pbindef(\kk, \instrument, \bipfm, \fmrate, Pif( Pfunc({~lastKick[\dur] < (3/4) }), 0, Pwhite(0.5, 0.2)), \sus, )


// tests

TempoClock.tempo

/* RAND ON THE BEAT *////////////////////////////////////////////////////////
(SynthDef("bipfm", {
	arg out=0, att=0.001, rel=0.05, freq=80, pan=0, sus=0, amp=0.1, fmrate=0, dur=0.1;
	var sig, env, fm, duration;
	duration = att + rel + sus;
	fm = LFPar.kr(duration+dur / Rand(1, 50), 0.5).range(-6, 4.5) * fmrate;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	sig = SinOsc.ar(freq*(fm+1), pi/2) + Saw.ar(freq/4 *(fm+1) + 10.rand); // * Decay2.kr(Impulse.kr(6), 0.01, 0.125);
	sig = Ringz.ar(sig, freq*fm + LFPar.kr( dur+duration).range(100, 200), LFTri.kr( Rand(0.6, 18) ).range(0, 0.0125), 0.1) + sig / 2;
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(out,sig);
}).add;)


Pdef.clear

(~rotb = {arg quant = 2, rest = 0.5, brk=1; var ttnb = TempoClock.timeToNextBeat(quant); if( ( ttnb > rest) , { TempoClock.tempo /
	// [8 ,12, 14, 6, 15, 7]
	[1, 2, 3]
	.choose
}, {ttnb / rrand(1,brk) + 0.05 max:0.05} ) };
~tnb = {TempoClock.timeToNextBeat max:0.05})


///// INTRO DE RANDO //////

(
Pbindef(\k, \instrument, \kick, \rel, 0.15, \dur,  Pseq([ 1, Pseq([0.75, Prand([0.75, 0.25, 1.25])]), Pseq([1.5, 0.5]) ],inf), \freqB, 50, \freqBC, 23, \freqC, 60, \amp, 0.75, \freqA, 1000 );
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
Pbindef(\hot, \stretch, Pseq([1,0.5, 0.25],inf));
)

Pbindef(\tmp, \instrument, \clap, \dur, Pseq([ Pseq([2], 8), Pseq([1.5],2)],inf), \fq, [200, 400, 900, 1500], \del, 0.01, \rel, 0.125, \rq, 0.05, \amp, 0.2).play(quant:4)

Pbindef(\basse, \instrument, \bip, \dur, Pseq([1.5, 2],inf), \freq, Pwrand([120, 132, 126], [0.35, 0.15, 0.5],inf) / [1.25, 0.75], \rel, 0.4, \att, 0.05, \amp, 0.2 ).play(quant:[4,0.5])



Pbindef(\tmp, \dur, 1.5)
Pbindef(\k, \instrument, \kick, \rel, 0.15, \dur,  Pwrand([1/2, 1/4], [0.75, 0.25],inf) , \freqB, 180, \freqBC, -20, \freqC, 60, \amp, 0.75, \freqA, 8000 );

///// TRANSITION VERS RANDOM BEAT ????
///// A faire

Pbindef(\k, \instrument, \kick, \rel, 0.15, \dur,  Pfunc({~rotb.(4, 0.5)}) , \freqB, 180, \freqBC, -20, \freqC, 60, \amp, 0.75, \freqA, 8000 );

/* Algorythmize */

~k.stop; ~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:[4, 0, 0.1])

TempoClock.tempo=1

Pbindef(\k, \instrument, \kick, \dur,  Pfunc({~rotb.(6,  [2.25, 4, 0.25].choose, ) }) )


(Pbindef(\s, \instrument, \snare, \cutoff, 0.0075, \fq, [1000, 188] * Pwhite(0.9, 1.5), \amp, 0.3, \rel, Pwhite(0.005,0.1), \rel, 0.15, \dur, 2 ).stop.play(quant:[2, 1.25]);
Pbindef(\h, \instrument, \bipfm, \amp, 0.06, \fmrate, 0.75, \freq, [400, 440, 1480],\dur, Pfunc({~lastKick[\dur]}) , \pan, Pwhite(-0.75, 0.75)).stop.play(quant:4))


Pbindef(\s, \instrument, Prand([\snare, \snaredel],inf), \delfq, 0.03, \delvit, Pwhite(0.0001, 0.05), \deldur, Pwhite(0,0.5), \sus, Pwhite(0, 0.25), \rel, Pwhite(0.2, 0.6), \ff, Pwhite(100, 2900))

Pbindef(\h,	\sus, Pif( Pfunc({~lastKick[\dur] > 0.5 }), Pfunc({~lastKick[\dur] - rrand(0.25,0.5) }), 0, 0 ), \fmrate, 0.275 ).play(quant:[2])

Pbindef(\h, \fmrate, Pif(Pkey(\dur) > 0.75, Pwhite(0.25,2.5), 0.75, 0.75))

// Grosse Trace de Noise //
Pbindef(\s, \rel, Pwhite(0.1,0.5), \relC, Pwhite(0,12) ).play(quant:[3, 1.25])

Pbindef(\s, \dur, 2 + Pwrand([0, Pseq([ -1.75, 0.25 ]) ], [0.8, 0.2],inf))



///


Pbindef(\s, \instrument, \snare, \dur, 6/4 + Pwhite(0, 4), \rel, Pwhite(0.05,0.3), \cutoff, Pwhite(0.01,0.1), \amp, 0.2, \att, Prand([ 0.01, Pwhite(0.01,0.75,1) ],inf), \fq, 180 * Pwrand( [ 1, [1,10], 10], [0.9, 0.05, 0.05],inf)).play(quant:[4, 1])

Pbindef(\s, \dur, Prand([6/4, 1, Pshuf([ Prand([1/4, Pseq([1/8],2)]), 7/4])],inf) )

Pbindef(\s, \rel, Pwhite(0.05, 0.2), \att, 0.005)



(Ndef(\bb, {

	SinOsc.ar([145, 150] * 6  ) * LFSaw.kr([145, 150]) + Pulse.ar([440, 330, 220], LFNoise1.kr(5).range(0.01,0.8), 0.4)
	+ Saw.ar([150, 145] * LFSaw.kr( TempoClock.tempo).range(1,0.2) )

	* 0.05!2 }).play)



Pbindef(\k, \dur, Prand([3/4, Pseq([1/4, 1/5, 0.175, 1/8, 1/4,1/8, 1/8, 1/5, 0.175, 1/8, 1/2]*1)], inf))

Pbindef(\k, \dur, Pseq([ Pseq([1/8],8), Pseq([1/2,1/4,1/2],4)],inf), \relC,-6).play(quant:4)


//// NEWWWWW


(~nstop.(); ~pstop.(); Pbindef(\s).stop;

Pbindef(\k, \dur, Pseq([ Pseq([1/8],8), Pseq([3/4,5/4],inf) ],inf), \relC,-6, \rel, Pseq([1, Pseq([0.4],7)],inf)).play(quant:4);

Pbindef(\kk, \dur, Pseq([1/12], inf), \detune, Pseq( {rrand(0,100)*20}!8 , inf), \rel, Pwhite(0.1, 0.2) ).play(quant:4) ;

Pbindef(\ss, \instrument, \snare, \dur, Pseq([ 1/2, Pshuf([3/4, 1/8, 1/8]), Pshuf([ 1/3, 2/3]) ], inf), \rel, 0.1, \cutoff, 0.1, \fq, 1650 * [0.5,1], \amp, 0.3).play(quant:[4, 1/2]))

Pbindef(\s).play


(Pbindef(\k, \dur, Pseq([ Pseq([1/8],8), Pseq([2/4,5/4, 1/4],inf) ],inf), \relC,-6, \rel, Pseq([1, Pseq([0.4],7)],inf)).play(quant:4);
Pbindef(\kk, \dur, Pseq([ Pseq([1/4], 4), Pseq([1/12],inf) ]), \detune, Pseq( {rrand(0,100)*20}!8 , inf), \rel, Pwhite(0.1, 0.2) ).play(quant:4) ;)

Pbindef(\ss, \instrument, \snare, \dur, Pseq([ 1/4, Pshuf([3/4, 1/8, 1/8]), Pshuf([1/6],3) ], inf), \rel, 0.1 + Pif( Pfunc({~onBeat.(4)}), Pwhite(0.2, 1), 0), \cutoff, 0.1 + Pif( Pfunc({~onBeat.(4)}), 0.0001, 0), \fq, 1650 * [0.5,1], \amp, 0.3).play(quant:[4, 1/2])

Pbindef(\ss, \dur, 1/4, \cutoff, 0.001)

Pbindef(\s).play



(Ndef(\mbass, { var sig;
	sig = Saw.ar([180, 190], 0.5) + BrownNoise.ar(0.3)!2 ;
	sig = Decay2.kr( Impulse.kr( 1/TempoClock.tempo / 2  - LFPulse.kr(0.5, 0.5, 0.5, /* ON */ 0) ), 0.01, 0.5, VarSaw.kr(0.25, 0, 0.25) * sig );
	sig = RLPF.ar( sig, 333 + LFNoise1.kr(0.5).range(0,500), 0.12);
	sig = sig + PitchShift.ar(sig, 0.5, LFNoise0.kr(0.25).range(2,10) ,0.5);
	// sig = sig + SinOsc.ar( 1400 * LFPar.kr( LFNoise0.kr(1).range(0.5, 4) * LFSaw.kr(0.4).range(0.1, 2) ).range(0.05, 0.6) , 0, LFSaw.kr(10.5) * LFPulse.kr(15) * LFSaw.kr(3)) * 0.2;
}).play)


TempoClock.tempo =


Pbindef(\k).stop; Pbindef(\ss, \dur, 1/8).play;



Pbindef(\h, \instrument, \blip, \dur, 1/8, \amp, 0.4, \freq, [1400, 1600] / 2).play(quant:4)


Pbindef(\k, \rel, Pseq([ 2 , Pseq([0.3],inf)]), \dur, Pseq([1, Pseq([1/4],4) ], inf), \freqB, 100, \freqBC, -3, \freqA, 5000, \freqC, 66, \amp, 1)
Pbindef(\k, \dur, 1/8)
Pbindef(\k).stop; ~k.play


Pbindef(\ss, \dur, Prand([1/4, 1/8],inf))

Pbindef(\s, \att, 0.05, \rel, 0.2, \dur, Prand([ 3/4, 2, 3, 1/4], inf))

Pbindef(\ss, \rel, Pwrand([0.05, 0.5], [0.95, 0.05],inf))




// Pour compresseur
Pbindef(\s, \instrument, \snare, \amp, 0.7, \dur, Pseq([2, 2, 2, Prand([1, Pseq([1/2, 1/2])])],inf), \noiseRel, Pwrand([0.05, 1], [0.9, 0.1],inf), /*\out, ~compIn.index */).play

/*Tout ds compresseur*/ Pdef.all.do({arg i; i.set(\out, ~compIn.index)})
/*Tout hors du compresseur*/ Pdef.all.do({arg i; i.set(\out, 0)})


///// HH kkrrr //////////////////////////

TempoClock.tempo = 90/60

Pdef.clear

Pbindef(\hhk, \instrument, \nkick, \dur, Pseq([5/4, 7/4],inf), \rel, 0.5).play(quant:2)
Pbindef(\s, \instrument, \nclap, \dur, 3, \del, 0.1, \rq, 1 ,\amp, 0.5, \rel, 0.5, \relC, 6).play(quant:[2, 0.75])


Pbindef(\hhk, \dur, Pseq([1/2, 1/2, 3/4],inf), \rel, 0.25);
Pbindef(\s, \dur, Pseq([1/2, 1, 3/4 ],inf), \rel, 0.25)
Pbindef(\h, \instrument, \bipfm, \dur, Pseq([1/4, 1/4, 1/4, 1/8, 1/8],inf), \fmrate, 0.5, \rel, 0.1, \amp, 0.07 ).play(quant:2)




Pbindef(\s, \fq, 3500, \rel, 0.4)
Pbindef(\hhk, \fb, 2)


///// LIVE DEFINITION
TempoClock.tempo = 1

Pbindef(\k, \instrument, \kick, \dur, Pseq([1/8, 3/8 + Prand([3/4])],inf) * 2, \rel, Pseq([0.2, 0.5, 2],inf), \freqB, 190, \amp, 0.8, \freqBC, -20, \rel, 0.3).play(quant:4)
Pbindef(\s, \instrument, \snare, \fq, 300, \cutoff, 0.001, \amp, 0.2, \dur, Pseq([1/4, 7/4],inf)).play(quant:[4, 1.5])
Pbindef(\son, \instrument, \son, \dur, 2).play(quant:[4, 0.5])
Pbindef(\son, \instrument, \son, \dur, Pfunc({ ~lastKick[\dur] })).play(quant:[4, 0.5])

Pbindef(\k, \dur, 1/2); Pbindef(\s, \dur, 2);
Pbindef(\k, \freqAC, Pstutter(24, Pwhite(-6, 6)) , \freqBC, Pstutter(32, Pwhite(10,-20)))

(SynthDef("son", {
	arg freq = 180, amp=0.1, dur=0.5; var sig, env, duration;
	duration = dur;
	env = Env([0, 1, 0.5, 0], [0.05, 0.1, duration - 0.05 - 0.1], [0,0, 12]).kr(2);
	sig = BrownNoise.ar(1);
	sig = Mix.fill(16 ,{arg i; BBandPass.ar(sig, freq * (i + 1 ), 0.05, 8 )});
	// sig = Mix.fill(8, {arg i; Saw.ar(freq * (i+Rand(0.5, 2))/4 * LFNoise1.kr(Rand(12,18)).range(0.8, 1.4),0.75)});
	sig = Compander.ar(sig, sig, 0.5, 0.5, 3) ;
	sig = sig + Ringz.ar(sig, 88 * LFPar.kr(5).range(0.25, Rand(1,6)), 0.25, 0.03);
	// sig = Decay2.kr( Impulse.kr(8), 0.01, 0.25, sig) * Line.kr(1.0,0,2) + Decay2.kr(Impulse.kr(4), 0.125, 2, PitchShift.ar(sig min:0.8 max:-0.8 * 9, 0.5, LFTri.kr( LFNoise0.kr(1).range(0.25, 1), 2).range(0, 0.5) * 1 + 0.5) );

	// sig = sig min:1 max:-1;
	sig = Pan2.ar(sig, 0 + LFTri.kr(8).range(-0.25, 0.25));
	sig = sig * amp * env;

	// Out.ar(~compIn.index, sig); nil; // VERS COMPRESSEUR
	Out.ar(0, sig);
}).add)
