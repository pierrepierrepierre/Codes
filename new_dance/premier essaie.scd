// new dance

Pdef.removeAll;

TempoClock.tempo = 60/60

Pbindef(\kick, \instrument, \kick, \freqA, 2000, \freqB, 220, \freqBDur, 0.1, \freqC, 40,\amp, 0.5, \dur, Pseq([1/2,1/2,1/4,1/3,1/3,1/3],inf)).play(quant:4)
Pbindef(\kick, \dur, Pseq([Pseq([1/2, 1/3], 2), 1, 1],inf))
Pbindef(\kick, \freqBC, Pseq([Pgeom(-3, 1.02, 100)],inf))
Pbindef(\kick, \dur, Pseq([1/2, 1/4, 1/2, 1/2, 1/4],inf)).play
Pbindef(\kick, \dur, Pshuf([1/2, 1/2, 1/4, 1/2, 1/4, Prand([Pseq([1/4],4), Pseq([1/8],8), Pseq([1/3],3)])],inf))
Pbindef(\kick, \dur, 1/4, \amp, Pwrand([0.5, Pwhite(0.01,0.25,1), 0],[0.8,0.1,0.1],inf))
Pbindef(\kick).play

Pbindef(\claire, \instrument, \snare,\dur,Pshuf([2, 2, 2, 2, 1],inf), \hifreq, 1000, \fq, 420, \noiseDecay, 0.03, \amp, 0.2, \noiseRelC, -3).play(quant:[9,3]).stop

Pbindef(\claire, \dur, Pseq([0.5, 1.5, 1, 2],inf))

Pbindef(\clap, \instrument, \clap, \dur, Prand([0.5,0.25],inf), \amp, Pseq([0.2],inf), \rq, Pwhite(0.2,0.6), \rel,Pwhite(0.2,0.4), \freq,900, \stretch, 0.5).play(quant:[4,0.5])
Pbindef(\clap).stop



TempoClock.tempo = 1.5
// MARACUJA

Pbindef(\kick, \dur, Pseq([ Pseq([1/3], 3), Pseq([1/2], 3)],inf)).play(quant:2)
Pbindef(\claire, \dur, 2).play(quant:[4,1])
Pbindef(\hat, \instrument, \noise, \dur, 1/6, \amp, 0.2, \att, 0.01, \rel, 0.01, \freqB, 1000).play(quant:1)


Pbindef(\kick, \dur, Pseq([ Pseq([1/2], 3), Pseq([1/3],3)],inf))
Pbindef(\claire, \dur, Pseq([2, 4],inf)).play(quant:4)
Pbindef(\hat, \dur, 1/4).play(quant:4)

Pbindef(\basse, \instrument, \saw, \dur, Pseq([ Pseq([1/3], 3), Pseq([1/2],3)],inf), \freq, [80, 94] * Pseq([Pseq([1, 1.115],3),Pseq([1.5, 1.615],3)],inf), \rel, 0.2, \amp, 0.15).play(quant:4)
Pbindef(\basse, \freq, [180, 198] * Pseq([1, 1, Prand([1.5, 1.25]),1, 1, 1, 1.15],inf)).play

Pbindef(\tar, \instrument, \dubitar, \dur, Prand([12],inf), \sus, 3 , \freq, Pshuf([1, 1.75, 1.25, 1.5],inf) * [40,60], \amp, 0.2, \speed, 1.5).play(quant:[4,2])

Pbindef(\kick, \dur, 1/4)
Pbindef(\basse).stop; Pbindef(\kick, \dur, Pseq([ Pseq([1/3],6), 3])); Pbindef(\claire, \dur, 1/3)
Pbindef(\kick, \dur, Pseq([ Pseq([1/3], 3), Pseq([1/2], 3)],inf)).play
Pbindef(\hat).play
Pbindef(\claire, \dur, 4).play
Pbindef(\tar, \speed, 1.5).play

/// UNE BASSE
(SynthDef("saw", { arg freq=420, amp=0.3, pan=0, att=0.001, phase=0, rel=0.005, sus=0, out=0;
	var env, sig;
	env = Env([0,1,1,0],[att, sus, rel]).ar(2);
	sig = Mix.fill(3, {arg i;
		LFSaw.ar(freq * (1 + ((i+1)/20)).postln, pi/((i*2)+1),1/2);
	});
	sig = BLowPass.ar(sig, freq, 0.1);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;)


Pbindef(\bass, \instrument, \saw, \dur, )

Pbindef(\glouglou, \instrument, Pseq([\saw, \sine],inf),\freq, [95, 162] * Pseq([1, 1.2,1.4],inf), \rel, 0.2, \dur, Pseq([Pseq([1/4],8), 1/2,1/2],inf)).play(quant:[4, 1.5])
Pbindef(\glouglou).stop

/// UN GENDY NOISY
(SynthDef("gendymax",{ arg amp=0.1, att=0.01, sus=0, rel= 0.1, attC=3, relC = (-3);
	var sig, env;
	env = Env([0,1,1,0],[att, sus, rel], [attC, 0, relC]).kr(2);
	sig = Mix.fill(10,{Gendy2.ar(Rand(0.1,2.1),Rand(0,2.0),Rand(0,0.5),Rand(0.01,0.8),Rand(40, 120),Rand(120, 3020),Rand(10,0.07),Rand(0,0.03)) * (1/5)});
	sig = Mix.ar([sig, ClipNoise.ar(Line.kr(1,0.00001,0.1)), LFSaw.ar(180)* Line.kr(1,0.00001,0.15)]);
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, LFNoise1.kr(8,0.5)));
}).add)

z.free; z = {((Gendy2.ar(1,1,1,1,63,500,0.005,5))*0.2)!2}.play

Pbindef(\bizz, \instrument, \gendymax, \dur, 2, \rel, 0.01, \sus,0.5, \amp, 0.2).play(quant:[4,0])
Pbindef(\bizz).stop


x.free; x = {arg amp=0.1; ( Mix.fill(10,{Gendy2.ar(2.5.rand,1.05.rand,0.5.rand,0.33.rand,100.rand,720.rand,0.07.rand,0.03.rand) * (1/5)}) * amp)!2}.play

x.set(\amp,0)

y.free; y = {arg amp=0.1; (Decay2.ar(Impulse.ar(2),0.01,0.5, Formant.ar([20,44],LFNoise0.kr(1,500,500),880)) * amp)!2}.play;
y.set(\amp, 0)

/// UN TRUC POUR FAIRE LE DUB

(SynthDef("dubitar", {
	arg out=0, amp=0.25, sus= 1, pan=0, freq=90, speed=4;
	var sig;
	sig = Decay2.ar(
			Impulse.ar(XLine.kr(speed,speed,sus,1)), 0.01, 0.5,
		LFSaw.ar([freq, freq * 0.98],0, Gendy2.ar(0.1,0.15,1,1,1200, 1300,0.01,0.01)));
	sig = sig * XLine.kr(amp, 0.05, sus,1,0,2);
	Out.ar(out, sig);
}).add
)

x = Synth(\noiseUp,[\amp, 3, \sus, 1, \panFreq, 8.rand])
x.free

Pbindef(\pub, \instrument, \noise, \dur, 1/4,\sus, 0.2).play

Pbindef(\pip, \instrument, \sine, )

Pbindef(\tar, \instrument, \dubitar, \dur, Prand([6,4,8],inf), \sus,Pwhite(1, 2), \freq,[40,70,76], \amp, 0.2, \speed, Prand([6, 3],inf)).play(quant:[4,2])
Pbindef(\tar).stop

Pbindef(\kick, \dur, 1/2, \rel, 0.1, \amp, 1).play

Pbindef(\kick, \dur, 1/2).play; Pbindef(\claky, \instrument, \clap, \dur, Pseq([1/4, 1/8, 1/8, 1/2],inf), \amp, [0.25,0.1], \freq, [700,3000]).play(quant:4)
Pbindef(\claky, \dur, Pseq([1/6],inf)); Pbindef(\kick, \dur, 1/4);



Pbindef(\boom, \instrument, \kick, \dur, 1/2, \amp, Pseq([0.7,Pseq([0.25],7)],inf)).play(quant:4)
Pbindef(\boom, \dur, Pseq([Pseq([1/6],6), Pseq([1/2,1/4,1/4],inf)]));
Pbindef(\claky, \dur, Pseq([Pseq([1/6],6), Pshuf([1/4,1/8,1/8,1/2],inf)]))

Pbindef(\boom, \dur, Pseq([Pseq([1/8],16*2), Pseq([1/2,1/4,1/4],inf)]), \amp, 0.6);
Pbindef(\claky, \dur, Pseq([Pseq([1/8],16*2), Pshuf([1/4,1/8,1/8,1/2],inf)]))

Pbindef(\fofor, \instrument, \formant, \dur, 1).play(quant:[4,1.5])
Pbindef(\fofor, \freq, Pwhite(10,60), \addFreq, [3000, 1030], \rel, 1, \lenmul, Pwhite(1,3), \att, 0.01, \rel, Pwhite(0.1, 0.3), \amp, 0.1)
Pbindef(\fofor, \dur, Pseq([1, 1/2, 1/2],inf), \lenmul, Prand([Pwhite(1,3, 4), 0.5, 1, 4],inf))
Pbindef(\fofor, \dur, Pseq([1/4, 1/4, 1/8, 1/8, 1/4, 1/2, 1/2],inf))
Pbindef(\fofor, \dur, Pseq([1/2],inf), \amp, 0.2, \lenmul, 2)

Pbindef(\fofor, \rel, Pwhite(0.2,0.5), \lenmul, 2, \freq, 120, \addFreq,Pwalk(Array.geom(50,500,1.01),Prand([-2,-1,1,2],inf), 1).trace, \bwFreq, 1400, \dur, 1/3).play



Pbindef(\debile, \instrument, \sine, \dur, Prand([0.1, 0.05, 0.075, 0.025],inf), \freq, Pwhite(8000,8100), \rel, Pwhite(0.01, 0.05), \sus, 0, \amp, Pwhite(0.01, 0.4)).play

Pbindef(\globy,\instrument, \glob,\rel, 0.5, \sus, 1, \dur, 4).play(quant:[4,3])
Pbindef(\globy, \argA, 0.710, \argB, 120, \argC, 3, \amp, 0.5)
Pbindef(\globy).stop

Pbindef(\groovybee, \instrument, \blip, \dur,1/4, \freq, Pstutter(Prand([1,4,2],inf),130 + Pseq([12, 20, -30],inf)), \nharm, 2, \rel, 0.2).play(quant:[4,0])