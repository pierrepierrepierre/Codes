// COMPRESSEUR
(
~compIn = Bus.audio(s,2);
~compCtrl = Bus.audio(s,2);
~compOut = Bus.audio(s,2);
)
~compIn.scope
(
SynthDef("compresseur",{
	arg out = 0, in = ~compIn.index, ctrl = ~compCtrl.index,
	thresh = 0.5, slopeBelow = 1, slopeAbove = 0.5, clampT = 0.01, rel = 0.01, amp = 0.5;
	var sig, control, compr;
	sig = In.ar(in,2);
	control = In.ar(ctrl, 2);
	compr = Compander.ar(
		sig,
		control,
		thresh: thresh,
		slopeBelow: slopeBelow,
		slopeAbove: slopeAbove,
		clampTime: clampT,
		relaxTime: rel
	);
	Out.ar(out, compr * amp);
}).add;
)


x = Synth.new("compresseur")
x.set(\in, ~compIn.index, \thresh, 1, \slopeAbove, 1, \rel, 0.1)
x.free


// SIDE CHAIN //
(c.free; c = Synth.new("compresseur",[\in, ~compIn.index, \ctrl, ~compCtrl.index,
	\thresh, 0.05,\amp, 1, \slopeBelow, 1, \slopeAbove,0.001, \rel, 0.05, \clampT, 0.002],s,\addToTail))

// CUT sevère
c.set(\rel, 0.015, \clampT, 0.002, \tresh, 0.001, \amp,1, \slopeAbove, 0.000001, \slopeBelow, 2)
c.free

// Son pour test
u = Synth(\droneSine,[\amp, 0.2, \freq, 190, \out, ~compIn.index])
u.set()
u.free

Pbindef(\st, \instrument, \bip, \dur, 1, \out, ~compIn.index, \sus, 0.8).play.stop


Pbindef(\kt,\instrument, \kick, \freqB, 218, \out, [0, ~compCtrl.index], \dur,Pseq([1, 1/2, 1/4],inf), \amp,0.5, \rel, 0.25, \relBC, -3).play
Pbindef(\kt, \dur, 2).stop

~compIn.scope
~compCtrl.scope

~compCtrl.index
~compIn.index

/*Tout ds compresseur*/ Pdef.all.do({arg i; i.set(\out, ~compIn.index)})
/*Tout hors du compresseur*/ Pdef.all.do({arg i; i.set(\out, 0)})


