(
SynthDef("bip", { arg dur=1;
	var sig, env;
	env = Env([0, 1,1, 0], [0.01, dur, 0.01]).kr(2);






	sig = Pan2.ar(sig, 0, 1);
	Out.ar(0, sig*env);
}).add
)

Pbindef(\b, \instrument, \bip, \dur, 1).play.stop



(Ndef(\tt, {

}).play)