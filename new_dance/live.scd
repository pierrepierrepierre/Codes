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


SynthDef("kick", {arg out=0,amp=0.5,pan=0,att=0.001,rel=0.1, sus=0,attC=0, relC=3, freq=86, freqC1=(8), freqC2=(-8), cutoff=360, rq=1;
	var env = Env([0,1,1,0],[att,sus,rel],[attC,0,relC]).ar(2);
	var sweep = Env([freq*50,freq,freq,freq/2],[att,sus,rel],[freqC1,0,freqC2]).ar;
	var sig = LFPar.ar(sweep, pi/2) + LFSaw.ar(sweep*0.95, pi/2, 0.1);
	sig = LPF.ar(sig, freq*4) + Resonz.ar(sig, cutoff, rq);
	sig = sig * env * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef("bip", {
	arg att=0.001, rel=0.05, freq=80, pan=0, sus=0, amp=0.1;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	sig = SinOsc.ar(freq, pi/2);
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(0,sig);
}).add;

SynthDef("clic", {
	arg att=0.001, rel=0.2, freq=800, pan=0, sus=0, amp=0.1, rq=0.25;
	var sig, env;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	sig = BPF.ar( WhiteNoise.ar(1), freq, rq, 1/rq);
	sig = Pan2.ar(sig, pan, amp * env);
	Out.ar(0,sig);
}).add;

// Snare
SynthDef("snare", {arg out=0,amp=1,fq=320, hifreq=1020, noiseDecay=0.002,pan=0,
	att=0.001,dec=0.01, rel=0.1,attC=(0),decC=0,relC=(-12),sinDel=0,
	noiseAtt= 0.002,noiseRel= 0.3, noiseAttC=(\wel),noiseRelC=(\wel),noiseDel=0,
	crash = 0.1;
	var sig, sin, env, noise, noiseEnv,harms, noiseAmp;
	noiseAmp = amp/1.5;
	env = Env([0,0,1,0.5,0],[sinDel,att,dec,rel],[0,attC,decC,relC]).kr();
	noiseEnv = Env([0,0,1,0],[noiseDel, noiseAtt,noiseRel],[0,noiseAttC,noiseRelC]).kr(2);
	harms = [0.9,1,1.1];
	sin = Mix.fill(harms.size, {arg i; LFSaw.ar(fq*harms[i],pi/2,1/((i*0.5)+1.5));});
	sin = sin * env * amp;
	noise = Mix.ar([ClipNoise.ar(0.3), Dust2.ar(fq*50,0)]);
	noise = Mix.ar([ Ringz.ar(noise,fq, noiseDecay), Ringz.ar(noise, hifreq, noiseDecay) ]);
	noise = noise * noiseEnv * noiseAmp;
	sig = Mix.new([sin, noise]);
	Out.ar(out, Pan2.ar(sig, pan));
	DetectSilence.ar(sig, 0.00001, crash, 2);
}).add;
)

Ndef.clear

CmdPeriod.add(k)
CmdPeriod.removeAll

Ndef.clear

// Bass Click
Ndef(\bassclik, {arg freq=40, amp=0.2; LFPulse.ar([1,1.25], [pi/2,0], 0.5) * SinOsc.ar(freq * Ndef(\fm), pi/2) * amp}).play
Ndef(\bassclik).set(\amp, 0.5)
Ndef(\bassclik).clear

Ndef(\fm, { LFSaw.kr(30).range(1, 1.3) * XLine.kr(1, 10, 60*100)})
Ndef(\fm).fadeTime = 10
Ndef(\fm).clear


// Sonnnerie de reveil
Ndef(\con, {  Ringz.ar( LFPulse.kr(6) * SinOsc.ar([1500,1550], 0, 0.25), 2040 * LFSaw.kr(0.0001).range(0, 1)) * 0.05}).play

// Rand sines
(Ndef(\ff, { Mix.fill(6, {arg i;  SinOsc.ar( LFNoise1.kr( [0.125,0.025,0.0375].choose).range(106,150) + (i*4) * 5, 0)}).dup
	* Line.kr(0, 1, 60) // Attaque douce
	* 0.05 }).play)
Ndef(\ff).fadeTime = 30
Ndef(\ff).clear(10)

Pbindef(\kik, \instrument, \kick, \dur, Pseq([3/4, 1, 5/4, 1],inf), \rel, 0.3, \freq, 72, \amp, 0.9).play(quant:4)
Pbindef(\kik, \dur, Pseq([ Pseq([1/2], 4), Pseq([1],2)],inf), \amp, Pseq([0.9, Pseq([0.3],7)],inf))
Pbindef(\kik, \dur, Pwhite(2,8) / 4, \instrument, Pseq([ \kick, Prand([\kick, \snare])],inf)).play
Pbindef(\kik).clear

Pbindef(\kik, \dur, Prand([1/2, 1/4],inf), \instrument, Pseq([ \kick, Prand([\kick, \snare])],inf)).play



// DRONE TUNNEL

(Ndef(\tunnel, { arg amp=0.1; var sig;
	sig = VarSaw.ar([370,369] * FSinOsc.kr(330 * LFNoise1.kr(0.25).range(0.2, 1)).range(0.5,1.5), 2, LFNoise1.kr(0.1025).range(0.2,0.9), LFPulse.kr(90))
	+ LFPulse.ar(420, 0, 0.5, VarSaw.ar(300, 0, LFNoise1.kr(0.025).range(0, 1)))
	; sig = RLPF.ar(sig, 1500 * LFNoise1.kr(0.0123).range(0.6, 1.2), 0.5)
	// ; sig = FreqShift.ar(sig, LFNoise2.kr(0.125).range(-200, 1200))
	* amp;
}).play)
Ndef(\tunnel).set(\amp, 0.2)
Ndef(\tunnel).fadeTime = 30
Ndef(\tunnel).clear(20)



// Marche électronique
/*(Ndef(\marche, {arg pulse=0.125, amp=0.1, rel=2;
	var fm = LFSaw.kr([0.25,0.15] + LFNoise1.kr(0.125).range(0.9, 1.1)).exp;
	var sig = SinOsc.ar([244, 223] , pi/2, LFSaw.kr(88, pi/2).range(0,1), SinOsc.ar([160, 180], [0, pi/3], 0.5))
	*  Decay2.kr( Impulse.kr(pulse + LFPulse.kr(pulse, 0, 1/16, 2)), 0.0001, rel/2 + LFPulse.kr(pulse).range(0,rel/2))
	; sig = RLPF.ar(sig, LFNoise1.kr(0.05).range(230, 460), 0.5, 0.6)
	+
	RHPF.ar(sig, LFNoise0.kr(0.05).range(180, 140), WhiteNoise.kr( LFNoise1.kr(10).range(1,10)))
	* amp ;
}).play)
Ndef(\marche).fadeTime = 0
Ndef(\marche).clear
Ndef(\marche).set(\pulse, 0.5, \amp, 0.2, \rel, 0.1)*/


// Clap



// Cuicui Bip Bip
Ndef(\tt, { [LFPulse.ar(4, 0, 0.05) , LFPulse.ar(2.5, pi/3, 0.05)] * SinOsc.ar([1020,1026]) * 0.1 } ).play
Ndef(\tt).clear

// UnClassique decay, impulse
Ndef(\tr, { arg amp=0.25; Decay2.kr(Impulse.kr(TIRand.kr(2, 4, Impulse.kr(0.125))), 0.001, 0.5, VarSaw.kr(0.25, 0, 0)) *  LFPulse.ar([88,75]) * amp}).play
Ndef(\tr).set(\amp, 1)
Ndef(\tr).clear

// Barre laser
(Ndef(\noz, { {var n = 20; Mix.fill( n, {SinOsc.ar(exprand(3000, 66))} ) / (n/1.5) }!2
	+ LFPulse.ar(333,0, SinOsc.kr(0.5).range(0.1, 0.9), 0.1)
	* SinOsc.ar(LFSaw.kr(0.1).range(0.2,1), 0, LFPulse.kr(1, 0, LFNoise1.kr(0.33).range(0.33,0.66)) )
	* 0.2
}).play)
Ndef(\noz).play.stop

// Barre Lazzzer
(Ndef(\lazer, { LFPulse.ar([230, 250],0, SinOsc.kr(0.125).range(0.1, 0.9), 0.1, -0.05)
	+ VarSaw.ar(150, 0, SinOsc.kr(0.25).range(0.05, 0.95), SinOsc.ar([276,82]))
	* 0.5}))
Ndef(\lazer).stop

Ndef(\coup, { Decay2.ar(Impulse.ar(0.5), 0.001, 0.5, Blip.ar(90, 20, 0.5) + FreqShift.ar( Ndef(\lazer), [-100, -89]) )}).play
Ndef(\coup).fadeTime=0
Ndef(\coup).clear

// Un kick
Ndef.clear
Pdef.clear

Pbindef(\k, \instrument, \kick, \dur, Pseq([3/4,5/4],inf), \freq, 108, \amp, 0.5, \freqC1, -2, \rel, 0.3).play(quant:4)
Pbindef(\k, \cutoff, 1700, \rq, 0.25, \amp, 0.8, \freqC1, 0)

Pbindef(\sn, \instrument, \snare, \dur, Prand([2,4, 3],inf), \amp, Prand([0.5, 0.1,0.2, 0.7],inf), \noiseDecay, 0.002, \noiseRel, 0.2).stop.play(quant:[4,0.5])
Pbindef(\sn,  \dur, Pseq([1, 1, Prand([Pseq([1],2), Pseq([5/4, 3/4]), Pseq([1/3, 4/6,2/3, 2/6]) ])],inf))
Pbindef(\sn, \dur, Pseq([1/2, 1/3, 4/6, 1, 2/3, 2/6],inf))
Pbindef(\sn, \hifreq, Pwhite(1330, 660), \rel, Pwhite(0.5, 1), \noiseDecay, 0.01, \noiseRel, 0.5, \dur, 4)

Pbindef(\tt, \instrument, \bip, \freq, 620, \dur, Pseq([1/3,2/3, 1/3, 1/3, 1/3 ],inf), \amp, 0.2).play(quant:[4,0.33])

Pbindef(\hh, \instrument, \bip, \dur, 1/4, \rel, 0.1, \freq, Pseq([ Pseq([500], Prand([16, 8])), Pseq([700], Prand([8, 16]))],inf) , \amp, 0.3 * Prand([0,1,1],inf)).play(quant:4)

Pbindef(\ki, \instrument, \kick, \dur, Pseq([ Pseq([1/8],16), Pseq([1/4],inf)]), \freq, 230, \cutoff, Pwhite(1500,1700), \rq, Pwhite(1,1.5), \amp, 0.5).play(quant:4)
Pbindef(\ki, \dur,   Pseq([ Pseq([1/8],16), Pseq([ 1/2, Prand([ Pseq([1/4],4), Pseq([ 1/3],3), Prand([ 3/4, 1/4]) ]) ],inf ) ]))


// DOUCHE NOISE
Pbindef(\wht, \instrument, \clic, \dur, 6, \freq, Pwhite(200,4000), \sus, 1, \amp, 1.5).play.stop

// Un ver dans l'oreille
Pdef.clear; Ndef.clear;
Ndef(\u, { Decay2.kr(Impulse.kr(6), 0.01, 1, SinOsc.ar(1840) + SinOsc.ar(1939) + SinOsc.ar(888) + SinOsc.ar([1796, 1808]) * LFTri.kr(0.25) )* 0.1}).play;
Ndef(\o).clear(10)

Ndef(\o, { Decay2.kr(Impulse.kr(4), 0.001, 2, SinOsc.ar(1440) + SinOsc.ar(1439) + SinOsc.ar(1444) + SinOsc.ar([1466, 1468]) * LFTri.kr(0.5, 0, LFPulse.kr(25)) )* 0.1}).play


// Hiiiiiiiii
x = []
x = x.add({SinOsc.ar([3290, 3260],0, 0.12)}.play)
x.do({arg i; i.free})
Ndef.clear; x.free;
x.do({arg i; i.free}); x = {LFSaw.ar(2000 * SinOsc.kr([0.012, 0.0121], 0, 0.125, 1), 0, 0.1) + SinOsc.ar([2222, 2300], 0, 0.1)}.play
x.free; y.free

// LOOOOOOOOW
y=[];
y = y.add({ SinOsc.ar([64,75], 0, 0.25)}.play )
y.do({arg i; i.free});
y = {LFPar.ar([60, 58] * SinOsc.kr([0.012, 0.0121]).range(0.8, 1.5), 0, 0.1) + SinOsc.ar([80, 77], 0, 0.1)}.play
y.free;


/// PART DANCE

Ndef.clear; Pdef.clear
/*Kick and synth*/

(Ndef(\you, { arg amp=0.3; {
	SinOsc.ar(250*[1,2,1.5].choose * LFNoise0.kr(10.25).range(0.25, 1), pi/2)
	max: LFSaw.kr(LFNoise0.kr(0.5).range(1,8))
	min: LFSaw.ar(LFNoise0.kr(0.25).range(1,8), pi/2)
	* LFSaw.ar(LFNoise0.kr(2).range(1,25), pi/2)
	* Decay2.ar(Impulse.ar(0.75), 0.001, 1.5, 1, Decay2.kr(Impulse.kr(3), 0.01, 0.3))
	* amp
}!2}).play)
Ndef(\you).fadeTime = 30
Ndef(\you).set(\amp,0.5)

/*Hithat*/
Ndef(\suck, {arg amp= 0.1; LFPulse.ar(8, 0, 0.2, SinOsc.ar([330, 440]*2, pi/2)) * amp * LFPulse.kr(0.5)}).play
Ndef(\suck).fadeTime = 0
Ndef(\suck).clear


// Gros Kick
Ndef(\ya, {arg amp=0.5, pulse= 1, cpulse=3; {Decay2.ar(Impulse.ar(cpulse), 0.001, 0.3, SinOsc.ar(66, pi/2, 2)) * LFPulse.kr(pulse, 0, 0.4) * amp}!2}).play
Ndef(\ya).set(\pulse, 1, \cpulse, 4)

// HH saturé
Ndef(\mya, { SinOsc.ar(1020) * (Ndef(\suck) / ( 0.0001 + Ndef(\ya))/(0.01 + Ndef(\wowo)) * 0.00051) * 0.1}).play
Ndef(\mya).clear

// Encore plus saturé le HH
Ndef(\wowo, { SinOsc.ar(SinOsc.ar([4,8]).range(380,1460), 0, SinOsc.ar( LFNoise1.ar(0.25).range(0.5,3), [0, pi/3]) * LFSaw.ar(66)) * 0.1}).play
Ndef(\wowo).fadeTime = 0
Ndef(\wowo).clear



/// DANS LA MASSE
Pdef.clear

Pbindef(\uy, \instrument, \bip, \att, 0.001, \rel, 0.1, \dur, 1/8, \freq, Pseq([420, 380, \, 420],inf), \amp, 0.7, \pan, Pwhite(-0.5, 0.5)).play(quant:4)

Pbindef(\yp, \instrument, \bip, \att, 0.001, \rel, 0.1, \dur, 1/8, \freq, Pseq([390, \, 390],inf), \amp, 0.7, \pan, Pwhite(-0.5,0.5)).play(quant:4)

Pbindef(\kkk, \instrument, \kick, \dur, Pseq([ Pseq([2], 6), Pseq([2/3, 2, 1/3])],inf), \amp, 1, \freq, [67, 134], \rel, 0.1).stop.play(quant:4)
Pbindef(\kkk, \dur, Pseq([ Pseq([1/4],3), Pseq([1],3)],inf))

Pbindef(\uio, \instrument, \bip, \att, 0.01, \rel, 0.05, \dur, Pwrand([2/3, 1/3], [0.8, 0.2],inf), \freq, Pseq([630,\,Prand([630, Prand([\, 530, 630], Prand([1, 2, 3]))])],inf), \amp, 0.5).play(quant:4)



(Pbindef(\snark, \instrument, \snaredel, \pan,Pwhite(-1.0,1),\dur,Prand([1,2],inf),\rel,Pwhite(0.1,1),\relC,-12,
	\deldur,Pwhite(0.05,0.3),\delvit,Pwhite(0.01,0.5),\delfq,Pwhite(1,30),
	\amp,Pwhite(0.5,0.8),\ff,Pwrand([Pwhite(10,100,1), Pwhite(2000,5000,1)],[0.7,0.3],inf)
).play(quant:[4,2]))
Pbindef(\snark, \dur, Pseq([1/4,3/4],inf))
Pbindef(\snark).stop.clear;