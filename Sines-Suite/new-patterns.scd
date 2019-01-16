(
SynthDef("kick", {arg out=0,amp=0.5,pan=0,att=0.001,rel=0.1, sus=0,attC=6, relC=6,
	freq=86,freqC1=2,freqC2=(-8), cutoff=360, rq=1;
	var env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).ar(2);
	var sweep = Env([freq*50,freq,freq,freq/2],[att,sus,rel],[freqC1,0,freqC2]).ar;
	// var sig = Mix.fill(4, {arg i; LFPar.ar(sweep * ( 1 + (i*0.12)), pi*(i*0.66),(1/(i+1.25)))});
	var sig = LFPar.ar(sweep, pi/2) + LFPulse.ar(sweep*0.95, pi/2, 0.1);
	sig = LPF.ar(sig, freq*4) + Resonz.ar(sig, cutoff, rq);
	sig = sig * env * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef("bloc", { arg out=0, freq=880, amp=0.5, att=0.01, sus=0, rel=0.1, pan=0, lpf = 600;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel], [3,0,-3]).kr(2);
	sig = Mix.ar([
		LFPulse.ar(LFNoise1.ar(freq,freq/2,freq), pi/3, 0.5,0.5,-0.25),
		SinOscFB.ar(freq,LFNoise1.kr(150,0.5,1), 0.3),
		SinOscFB.ar(freq/3,LFNoise1.kr(50,0.5,1), 0.3),
	]);
	sig = BLowPass4.ar(sig, lpf, 0.25);
	sig = BHiShelf.ar(sig, freq, 1, 3);
	sig = Pan2.ar(sig, pan, env * amp);
	Out.ar(out, sig);

}).add;
)

/*(
Pbindef(\snare,\instrument,\snare,\dur,4,\amp, 0.5, \noiseRelC, Pwhite(-3,-6),\noiseRel,0.2,\fq,Pwhite(400,410.0),\hifreq,Pwhite(3050,3020), \noiseDecay, 0.005).play(quant:[4,3]);

Pbindef(\kick, \instrument,\kick,\amp,1,\freqA,Pwhite(2540,2550), \freqAC,-8,\freqBC,-3, \freqC,Pwhite(42,44.0), \freqB,Pwhite(55.0,58),\dur,Pseq([3/4,1],inf),\rel, 0.2, \relC,-16).play(quant:[4,0]);


Pbindef(\vent, \instrument,\noise,\dur, ~pat,\sus, 0.000,\attSweepC, 20,\bw,Pwhite(0.1,0.005),\amp,0.25, \relC,-20).play(quant:[4,0]);

Pbindef(\vent2, \instrument,\noise,\dur,~pat,\sus,0,\rel,0.025,\att,0,\bw,0.002,\amp,0.15, \pan, Pwhite(-1.0,1)).play(quant:[4,0];);

Pbindef(\vent4, \instrument, \formant, \dur,Pseq([3/4, 1/4, 1, 1/4],inf), \sus, 0.1, \rel, 0.01, \att,0.001, \lenmul,Pwhite(0.05, 0.5), \freq,[890, 650], \addFreq, [300, 800],\panrand, 0).play;
)*/

Pbindef(\k, \instrument, \kick, \dur, Pseq([3/4,5/4],inf), \freq, 86,  \amp,0.5 ).play(quant:4)
Pbindef(\snare, \dur, Prand([ 2, Pseq([], inf)).play(quant:[4,3])

Pbindef(\heartbeat).stop
Pbindef(\heartbeat).collect({|e| ~lastKick = e;}).play(quant:[8,0,0.1])


Pbindef(\contre, \instrument, \bloc, \sus, 0.2, \att, 0.001, \rel, 0.2, \amp, 0.05, \freq, 86).play(quant:[4,3/4])

Pbindef(\wouin,\instrument,\blip,\dur,Prand([1/6,1/8,1/10],inf),\att,0.001,\rel,Pwhite(0.02,0.005),\sus,Pkey(\dur) * Pexprand(0.05, 0.1),\freq,Pstutter(Pexprand(500,260),Pwhite([400,600,2000],[1800,1000,4000])),\amp,0.07, \pan, Pwhite(-0.5,0.5)).play(quant:[1,0])


Pbindef(\heartbeat, \dur, Pseq([Pseq([1/4],4),1, Pseq([1/8],16), ~pat])).play;
Pbindef(\wouin, \dur, Pseq([Pseq([1/4],8), Pseq([1/8],16), Prand([1/6, 1/8, 1/10],inf)]));
Pbindef(\vent, \dur, ~pat);
Pbindef(\vent2, \dur, ~pat).play;
Pbindef(\vent4, \dur, ~pat).play;

Pbindef(\heartbeat, \dur, Pseq([1/6, 7/6, 1/2, 1/2],inf)).play(quant:4)

Pbindef(\basse, \instrument, \bass, \dur, Pseq([1/6, 1/3, 1,1/6, 1/3],inf), \freq,Pseq([84, 90, 90, 75, 128],inf), \att, 0.001, \rel, Pkey(\dur) * 0.2, \amp, 0.5, \sus, Pkey(\dur) * 0.2).play(quant:4)
Pbindef(\basse, \rq, 0.05)

Scale.directory

Pbindef(\ronde, \instrument, \formant, \rel, 0.01, \att, 0.01, \sus,0.2, \lenmul, 20, \addFreq, 800, \freq,  Pseq([Pseq([80], 2), 80 * Prand([1,1.375,1.125, \rest],3) ],inf).trace,\nharm, 3, \amp, 0.5, \dur, Pseq([Pseq([1/3],inf)])).play

Pbindef(\wouin, \dur, Pseq([ Pseq([1], 2), Pfuncn({~lastKick[\dur]},1), Pseq([1/2]) ],inf).trace)

~pat.value

~pat = Pseq([(1/6),(1/4),(2/6),Prand([1/4, 2.25, 1.25])],inf)
~pat = Pseq([Pseq([1/8],8), Pseq([1/6, 1/8],6), ~pat],inf)
~pat = Pseq([Prand([Pseq([4]), Pseq([1/7],7)]), ~pat])
~pat = Prand([Pseq([1/4],Prand([4,8,12])), Pseq([1/2],Prand([2,4])), Pseq([1],Prand([2,1])), Pseq([1/8],Prand([8, 12]))],inf)

Pbindef(\heartbeat, \dur, ~pat)


Pbindef(\heartbeat, \dur, Pseq([Pseq([1/8],8),1, 1/8, 1/8, ~pat]));
Pbindef(\vent, \dur, Pseq([Pseq([1/4],4), 2, Pseq([1/8],8)],inf)).play;
Pbindef(\wouin, \dur, Pseq([Pseq([1]), Prand([1/6, 1/8, 1/10],inf)]))
Pbindef(\vent4, \dur, Pseq([Pseq([1/3],6), 1/6],inf)).play

Pbindef(\heartbeat, \dur, Pseq([1, Pseq([(1/6),(1/4),(2/6),(1/4)],inf)]));
Pbindef(\vent, \dur, Pseq([Pseq([1]), Pseq([1/4],2), Pseq([1/8],inf)]));
Pbindef(\dubbysnare, \amp, Pseq([Pseq([0.2],8), Pseq([0.5],inf)]), \dur, Pseq([Pseq([1/8],8), Pseq([4],inf)] ) );

(
Pbindef(\heartbeat, \dur, Pseq([Pseq([1/8], 8), Pseq([1],4), Pseq([(1/6),(1/4),(2/6),(1/4)],inf)]));
Pbindef(\vent, \dur, Pseq([1, Pseq([1/12], 12), Pseq([1/8],inf)]));
Pbindef(\vent2, \dur, Pseq([Pseq([2],2), Pseq([1/6], 12), Pseq([(1/6),(1/4),(2/6),(1/4)],inf)]));
Pbindef(\dubbysnare, \dur, Pseq([ Pseq([1/8,1/4, 2.125]), Pseq([4],inf)]))
)

Pbindef(\heartbeat, \dur, Pseq([Pseq([1],2),  Pseq([(1/6),(1/4),(2/6),(1/4)],1), Pseq([1/7],7), Pseq([(1/6),(1/4),(2/6),(1/4)],inf)]));
Pbindef(\wouin, \dur, Pseq([Pseq([1/12],12), Pseq([1/4],4), Prand([1/6,1/8,1/10],inf)]))

[1/12, 1/6, 1/8, 2/12,].sum

Pbindef(\vent, \dur, 1/10)

Pbindef(\vent2, \dur, 1/10)