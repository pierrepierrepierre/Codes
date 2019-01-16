
s.boot

(
SynthDef(\bip, { arg out=0, amp=0.1, att=0.01, rel=0.01, sus=0, freq=100, pan=0;
	var env, sig;
	env = Env([0,1,1,0], [att, sus, rel]).kr(2);
	sig = SinOsc.ar(freq, pi/2);
	Out.ar(out, Pan2.ar(sig, pan, env));

}).add
)



~f = [4000, 200, 300, 1200]

Pbindef(\bips, \instrument, \bip, \dur, 2, \freq, Pseq([ Pfunc({ ~f})], inf), \amp, 0.1).play





/// BEAT INCREMENT

(
~env = {arg amp=0.1, att=0.01, sus=0, rel=0.02; amp * Env([0,1,1,0], [att, sus, rel]).kr(2)};
~sig = {arg freq=100; {SinOsc.ar(freq,pi/2)}.dup()};
~inc = {~f = ~f ++ rrand(30, 10000);};
~chance = {arg i; i%8 == 0 };
~amp = {arg freq; (~f.sum - freq) / (~f.sum * ~f.size)};
)


~f = [1000.rand, 1000.rand];
~wait = 0.5;

~chance = { 0.1.coin}
~chance = true

~nfo.do({arg i; i.postln});
~f.size

~amp = {arg freq;  1 / ~f.size}
~amp = {arg freq; (~f.sum - freq) / (~f.sum) / ~f.size};


(
~b=0; ~f = [40, 60]; ~wait = 1; // RAZ
x = Routine{ loop {
	~b = ~b + 1;

	~nfo=[];

	~f.do({	arg i, j; var amp = ~amp.(i);
		{~sig.(i) * ~env.(amp)}.play;
		~nfo = ~nfo.add( [i.trunc(0.01), amp.trunc(0.001)]);
	});
	~wait.wait;
	if( ~chance.(~b) ) { ~inc.()};
}}
)

x.play
x.free
