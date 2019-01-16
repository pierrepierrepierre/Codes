(SynthDef.new(\toc, {arg freq = 220;
	var sig, env;
	env = Env([0, 1, 0], [0.01, 0.03]).kr(2);
	sig = SinOsc.ar( freq + SinOsc.kr(58, 0, 5), pi/2 );
	sig = sig + Decay2.ar( sig, 0.001, 0.0025, RHPF.ar(WhiteNoise.ar(0.1) + Saw.ar(freq, 0.5), freq*10, 0.15,0.1));
	sig = Pan2.ar(sig, LFNoise2.kr(2));
	Out.ar(0, sig*env);
}
).add;

SynthDef(\tac, {arg pan;
	var env, sig;
	env = Env([0,1,0], [0.01, 0.01]).kr(2);
	sig = WhiteNoise.ar(0.5);
	sig = Mix.fill(60, { SinOsc.ar( rrand(230, 5000) * SinOsc.kr(0.5).range(0.9,1.1), pi/2, 0.25)}) + sig;
	sig = Pan2.ar(sig, pan, env);
	Out.ar(0, sig);
}).add;

)

Pbindef(\ttt, \instrument, \toc, \dur, Pwhite(0.5, 8)).play
Pbindef(\ttt, \freq, 260 + Pseq((0..100),1) )
Pbindef(\ttt, \dur, Pseq([ Pshuf([1, 0.5, 0.5, 1.5, 1]) ],inf) / 2)
Pbindef(\ttt, \freq, 80)


(Ndef(\oo, {
	SinOsc.ar( [60, 70] + SinOsc.ar([0.05, 0.06 ],0, 5), 0, 0.51)
}).play
)
Ndef(\oo).fadeTime = 20
Ndef(\oo).clear(20)



(Ndef(\car, { var sig;
	sig = PinkNoise.ar( 1 ) * LFNoise1.kr(0.25, SinOsc.kr(1) * SinOsc.kr(0.25)) * 0.1;
	sig = RHPF.ar(sig, LFNoise1.kr(0.1).range(600, 10000), LFNoise1.kr(1).range(0.2,0.02));
	sig = Pan2.ar( sig, SinOsc.kr(8 * LFNoise1.kr(0.05)) );
}).play)


Pbindef(\sss, \instrument, \tac, \dur, 1).play
Pbindef(\sss, \pan, Pwhite(-1, 1))




b.free


// read a soundfile from disk
b = Buffer.read(s, "D:/Musique/Mes sons/Enregistrements divers/Ventre - LS100701.WAV");
c = Bus.control(s, 1);

Buffer

b.sampleRate

(// a sample Player
SynthDef("player", { arg out = 0, bufnum = 0, rateScale = 1, amp = 1, addrate=0;
    Out.ar(
        out,
        PlayBuf.ar( 2, bufnum, BufRateScale.kr(bufnum) * XLine.kr(60, 0.6, 60*15, 1, addrate) ,doneAction:Done.freeSelf) * amp
    )
}).add;
)

{PlayBuf.ar( 2, b, BufRateScale.kr(b) * XLine.kr(60, 0.6, 60/10) ,doneAction:Done.freeSelf); b.}

d.free; d = {Out.kr(c, LFNoise1.kr(1).range(0.1, 6) )}.play

x.free; x = Synth(\player, [\bufnum, b])
x.set(\amp, 2)


