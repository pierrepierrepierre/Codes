Pdef.clear

// YOLO ////////////////////////////////////////

(Pbindef(\k, \instrument, \kick, \dur, Pseq([3/4, 1/2, 5/4],inf), \rel, 0.15, \freq, 72, \amp, Pseq([0.35, Pseq([0.25],3)],inf), \freqA, 2200, \freqAC, 0, \freqB, 150, \freqBC, -10, \freqC, 80);
Pbindef(\chal, \instrument, \bip, \freq, [452,405], \att, 0.001, \amp, 0.075, \rel, 0.025, \pan, Pshuf([1,-1,0],inf), \dur, Pseq([1/2, 1/3, 2/3],inf))
)

(Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:4);
Pbindef(\chal).play(quant:4))


Pbindef(\k, \dur, 1/4, \rel, 0.1)
Pbindef(\k, \dur, Pseq([3/4, 1/2, 5/4],inf), \rel, 0.15 )


(Pbindef(\k, \rel, Pseq([0.75, Pseq([0.2],3) ],inf) , \dur, Pseq([3/4, 1/2, 3/4, 2/4],inf));
Pbindef(\vent, \instrument,\noise,\dur, 0.08,\freq, 30000, \sus, 0.000,\attSweepC, 20,\bw,Pwhite(0.1,0.005),\amp,0.125, \relC,-20).play;
Pbindef(\vent2, \instrument,\noise,\dur,0.081,\sus,0,\freq, 30000, \rel,0.025,\att,0,\bw,0.002,\amp,0.075, \pan, Pwhite(-1.0,1)).play)

Pbindef(\chal, \freq, [452,405] * Pseq([1,2],inf))
Pbindef(\chal, \dur, Pseq([1/2, 1/3, 2/3],inf) * Pseq([1, 1, 1, 0.5, 0.5, 0.5],inf) )

Pbindef(\sn, \instrument, \snare, \dur, Prand([2,4, 3],inf), \amp, Pseq([0.5, Pwrand([0.1,0.2, 0.5], [0.2, 0.75, 0.05],inf)]) / 2, \rel, 0.075, \fq, [160, 440]).stop.play(quant:[4,0.5])

Pbindef(\vent, \dur, Pstutter(8, Prand([ 1/8, 0.08],inf)))
Pbindef(\vent2, \dur, Pstutter(8, Prand([ 1/12, 0.081],inf)))


// Algo kik
Pbindef(\vent, \sus, Pfunc{ if((~noKick.(2/6)) && (0.3.coin)){rrand(0.07,0.0002)}{0.0001}})
Pbindef(\vent2, \dur,Pfunc{ ~lastKick[\dur] / 4})

Pbindef(\sn, \dur, 1).play(quant:[4,1])

Pbindef(\k, \rel, 0.1, \dur, Pseq([ Prand([3/4, Pseq([1/4],3) ]) , 1/2, 3/4, 2/4],inf) )

Pbindef(\sn, \dur, Pfunc{ if (~onBeat.(3) && (0.5.coin)) {~lastKick[\dur]} {[1,2,0.5].choose}}, \amp, Pfunc{ if (~noKick.(1/4)){0.2}{if(~onBeat.value(3)){0.3}{0}}}).play(quant:4)




Pdef.clear

Pbindef(\wouin,\instrument,\blip,\dur,Pseq([ Prand([1/6,1/8,1/10],inf), 1/4, 1/3, Pseq([1/12],18), 1/3, 1/4],inf),\att,0.001,\rel,Pwhite(0.02,0.005),\sus,Pkey(\dur) * Pexprand(0.05, 0.1),\freq,Pstutter(Pexprand(500,260),Pwhite([400,600,2000],[800,1000,4000])),\amp,0.02, \pan, Pwhite(-0.5,0.5))

Pbindef(\wouin, \dur,Pseq([ Pseq([1/3],6), Prand([1/3,1/4,1/12],inf)]), \amp, 0.035).play(quant:[4,3]);
Pbindef(\chal, \dur, Pfunc({~lastKick[\dur]}));
Pbindef(\vent2).stop; Pbindef(\vent, \dur, 1/8, \rel, 0.5, \amp, 0.1);
Pbindef(\k, \dur, 4, \rel, 2)

Pbindef(\wouin,\dur,Pfunc{if (~noKick.(1/2)) { ~lastKick[\dur] / rrand(13,6) } {[1/6,1/8,1/5,1/10].choose} })

// Batukadize
Pbindef(\k, \dur, Pwrand([ Pser([ Pn( Pshuf([0.35, 0.4]),1), 1/4, 1/2, 1/4, 1/4], /*Loop*/ Prand([2, 1, 5],4)), Pseq([5/4, 1/2, 3/4, 1/4, 1/4])], [0.9, 0.1], inf),\rel, 0.1)

Pbindef(\k, \dur, Prand([ 1, Pseq([1/8],8), Pseq([ 1/4, 3/4, 1/4, 2/4, 1/4]) ],inf))



/// ROOKIES ----------
Pdef.removeAll; Pdef.clear
~pstop.();

TempoClock.tempo = 1.5

(Pdef.removeAll; Pdef.clear;
Pbindef(\vent3, \instrument, \bip, \dur, 1/8, \sus, 0.02,  \att, 0, \amp, 0.075, \freq, Pstutter(1000,Pwhite(700, 2000)), \rel, 0.001, \pan, Pwhite(-0.5, 0.5)).play(quant:[4,0.2]) ;
Pbindef(\vent4, \instrument, \formant, \dur, Pseq([ Pseq([1/8],2), Pseq([1/6],3) ],inf), \rel, 0.01, \att,0.001, \lenmul,10, \freq, Pstutter(500,Pwhite(700, 2000)), \addFreq, Pwhite(1000,900),\panrand, 0, \amp, 0.1, \pan, Pwhite(-0.5, 0.5)).play(quant:4);
Pbindef(\kip, \instrument, \bip, \freq, 66 * [1, 1.5, 2] * 2, \dur, 1, \amp, 0.3).play(quant:4);
)

Pbindef(\sn, \instrument, \snare, \fq, [300, 50], \rel, Pwhite(0.05, 0.01), \dur, 1/4, \amp, 0.125, \pan, Pwhite(-1.0, 1)).play(quant:4)

Pbindef(\k, \instrument, \kick, \freqAC, 6, \freqB, 180, \freqA, Prand([4000, 2000],inf), \freqC, 60, \att, 0.05, \sus, Pseq([0.05, 0, 0, 0],inf), \rel, Pseq([0.2, 0.1, 0.5, 0.1],inf), \dur, Pseq([ 1, Pseq([5/4, 3/4],inf)]) * 2, \amp, 0.5);
~k = Pbindef(\k).stop.collect({|e| ~lastKick = e;}).play(quant:4);


Pbindef(\kip, \dur, Pseq([1, 1/4, 1, 1, 1, 3/4],inf));


Pbindef(\k, \dur, Pseq([ 1, Pseq([5/4, 3/4],inf)]))

Pbindef(\k, \dur, 1, \rel, Pstutter(2, Pseq([0.25, 0.1], inf)) )

Pbindef(\kip, \dur, Pseq([1/2, 3/4, 1/2, 1/4],inf), \freq, 66 * [1, 1.5, 2] * Prand([2, 2.5],inf), \rel, 0.1, \amp, 0.1);


Pbindef(\sn, \dur, Pseq([1/8],24)); Pbindef(\kip, \dur, Pseq([1/2, 3/4, 1/2, 1/4],inf)); Pbindef(\k, \freqC, Pseq([180, 160, 220],inf));

/* Calme la snare */ Pbindef(\sn, \dur, Pseq([1, 1/4, 3/4, 1/4, 3/4],inf), \rel, 0.1); Pbindef(\kip, \dur, 1/4, \freq, 66 * [1, 1.5, 2], \rel, 0.1, \amp, 0.3);

Pbindef(\k, \dur, 1/2)


Pbindef(\k, \freqC, 67, \dur, Pseq([ 1, 3/4, 5/4], inf), \rel, Pseq([0.2, Pwhite(0.5, 1.5, 1)],inf), \att, Pwhite(0.1, 0.5))

Pbindef(\sn, \dur, Prand([1/2, 1],inf), \rel, 0.25, \cutoff, 0.001).play(quant:1);

Pbindef(\k, \dur, Prand([1, 1/2, 1/4 , Pseq([1/8],4) ], inf), \att, 0.001, \rel, 0.025, \sus, 0);  Pbindef(\kip, \freq, 600, \dur, 1)

Pbindef(\sn, \dur, Prand([3/4, 1, 1/4],inf), \rel, Pwhite(0.025, 0.05), \relC, Pwhite(0.0, 3), \cutoff, Pwhite(0.002, 0.02), \amp, 0.15).play(quant:4);

Pbindef(\sn, \dur, Prand([2, 1.5],inf), \cutoff, 0.0001)

Pbindef(\k, \dur, Pseq([1/2, 3/4, 1/2, 1/4],inf), \rel, 0.2, \freqC, 77, \freqB, 142, \freqBC, -6, \freqAC, Pwhite(0, -3.0) )

Pbindef(\kip, \dur, 1/4, \amp, 0.1, \freq, Pseq([180, 160, 220],inf), \rel, 0.1, \amp, 0.25).play;

Pbindef(\vent3, \stretch, Pfunc{if (~noKick.(2/6)) { 3 } { 1 } } )
Pbindef(\vent3, \sus, Pfunc{if (~noKick.(1/2)) { 0.3 } { 0.02 } } )
Pbindef(\vent3).stop
Pbindef(\vent4, \amp, 0.005).stop

Pbindef(\vent4, \stretch, Pfunc{if (~noKick.(2/6)) { 3 } { 1 } } )
Pbindef(\vent4, \sus, Pfunc{if (~noKick.(1/2)) { 0.05 } { 0 } } )

Pbindef(\k, \dur, Prand([ 1.5 , Pseq([3/4, 1/4]), Pseq([1/3],3) ],inf))

Pdef.gui

/////// PARTY 2 : Clubbez moi

Pdef(\k).clear; ~k.stop; ~k = Pbindef(\k, \dur, 1, \instrument, \kick, \amp, 0.5, \freqA, 3000, \freqAC, -2, \freqB, 220, \freqC, 40, \rel, 0.1).stop.collect({|e| ~lastKick = e;}).play(quant:4); TempoClock.tempo = 1; Pdef(\vent3).clear; Pdef(\vent4).clear

Pbindef(\k, \dur, Pwrand([ Pseq([1/6,1/4,2/6,1/4]), 1],[0.9,0.1],inf))

Pbindef(\sn).clear; Pbindef(\sn,\instrument, \snare, \dur,Prand([Pseq([2],6), 1,3],inf),\amp,0.1,\relC,Pwhite(-5,-3),\rel,0.4, \fq, 150).play(quant:[4,3])
Pbindef(\sn, \fq, Pseq([ 150, 600, 600],inf), \dur, Pseq([2, 0.5, 1.5 ],inf))


Pbindef(\clap, \instrument, \clap, \dur, Pxrand([0.5,Pshuf([0.25,0.75])],inf), \amp, 0.3, \rq, Pwhite(0.2,0.6), \rel,Pwhite(0.2,0.4), \freq,900, \stretch, 0.5).play(quant:[4,0.5])
Pbindef(\clap, \amp, 0.5)
Pbindef(\clap, \dur, Pseq([1/4, 7/4],inf))

Pbindef(\clap, \dur, Pif( Pfunc({~lastKick[\dur] >= 0.4 }), 1, Pxrand([0.5,Pshuf([0.25,0.75])],inf)) )
Pbindef(\clap).stop


Pbindef(\snare, \instrument, \snaredel, \dur, Prand([Pseq([1/3],3), Pseq([1/5],5)],inf), \amp, Pfunc{ if (~lastKick[\dur] >= 0.4 ) {0.04} {0}}, \deldur, 1, \delfq, 350,  \deldur, 1.5, \sus, 0.15, \delvit, 0.001, \delfq, 1, \lenmul,0.5).play(quant:4)
Pbindef(\snare, \rel, 2, \sus, 1) // ++ crash pour surcharger cpu :: default = 0.1
Pbindef(\snare).stop


(Pbindef(\snark, \instrument, \snaredel, \pan,Pwhite(-1.0,1),
	\dur,Pfunc{ if(~lastKick[\dur] >= 1) {rrand(0.1,2)}{0.5}},
	\amp,Pfunc{ if(~lastKick[\dur] >= 0.5){0.6}{0.01}},
	\rel,Pwhite(0.05,1),\relC,-3, \deldur,Pwhite(0.05,0.3),\delvit,Pwhite(0.01,0.5),\delfq,Pwhite(1,30),
	\ff,Pwrand([Pwhite(10,100,1), Pwhite(2000,5000,1)],[0.7,0.3],inf)
).play(quant:[4,2]))
Pbindef(\snark, \rel, 0, \sus, 0.1, \dur,0.01) // ++ crash pour surcharger cpu :: default = 2
Pbindef(\snark).stop;

Pbindef(\k, \dur, Pwrand([ Pseq([1/6,1/4,2/6,1/4]), Pseq([1/5],10), 1],[0.8,0.1,0.1],inf))

Pbindef(\roll, \instrument, \snare, \dur, Pfunc{if(~lastKick[\dur] < 1) {~lastKick[\dur]} {1/8}}, \noiseRelC, -12, \rel, 0.05,\att, 0.0001, \dec, 0.02, \relC, -8, \fq, [1300, 900], \hifreq, 1600, \noiseDecay, 0.05, \noiseDel, 0.01, \amp,Pfunc{ if(~lastKick[\dur] >= 1) {0.04} {0.001}}).play(quant:4)
Pbindef(\roll, \amp,0.04)
Pbindef(\roll).stop

Pbindef(\clap, \freq, Pseq([Pseries(900,1,600)],inf))
Pbindef(\clap, \dur, Pshuf([Pxrand([0.5,Pshuf([0.25,0.75])],2), Pseq([0.25],8), 1,2],inf))
Pbindef(\clap, \freq, 950)

Pbindef(\wouin,\instrument,\blip,\dur, Pfunc{ ~lastKick[\dur]} * Pwrand([0.5, 0.25, 1, 2], [0.4,0.1,0.5],inf) + Pshuf([0, -0.125,0.125]),\att,0.01,\rel,Pwhite(0.02,0.005),\sus,Pkey(\dur) * Pexprand(0.05, 0.1),\freq, 2 * [250, 502, Pseq([500, 505, 510],inf)],\amp,0.1, \pan, Pwhite(-0.5,0.5)).play(quant:[4,1.25])

Pbindef(\k, \dur, Pwrand([1/5, 1/6, 1, 2],[0.5,0.1,0.1,0.1].normalizeSum,inf))

TempoClock.tempo = 0.75

// VARIAS
Pbindef(\k, \dur, Pwrand([ Pshuf([1/4],2), Pshuf([1/3],3), Pseq([1/6],6), 1/2, 1, 2], [2,0.5,1.5,0.5,0.3,0.1].normalizeSum,inf), \sus, 0)

Pbindef(\clap, \dur, Pshuf([Pxrand([0.5,Pshuf([0.25,0.75])],2), Pseq([0.25],8), 1,2],inf))

Pbindef(\k, \dur, Pseq([3/4, 5/4]/2,inf))

y.set(\amp, 1)
