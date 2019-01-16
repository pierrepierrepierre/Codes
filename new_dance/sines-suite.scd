(/* VU METRE & FREQSCOPE */ w = Window.new("Levels");w.visible = true; r.free; r = ServerMeterView.new(s,w,0@0,2,2);
f.free; f = FreqScope.new(400,400,0,server:s); f.window.front;)

(
~info = {arg group; group.size.do({arg i; ~sines[i].get(\freq, {arg val; (i+"").post; val.post;}); ~sines[i].get(\amp, {arg val; " : ".post; val.round(0.001).postln})})};

// Sine
SynthDef("gliss",{arg ampLag=0.5, freqLag=0, panLag=0, panFreq=0.1,panMod=0, out=0 ;
	var freq = NamedControl.kr(\freq,440,freqLag);
	var pan = NamedControl.kr(\pan,0,panLag);
	var amp = NamedControl.kr(\amp,0.05,ampLag);
	var pano = FSinOsc.kr(panFreq,0,panMod,pan);
	Out.ar(out,Pan2.ar(SinOsc.ar(freq),pano, amp));
},[10,0,0,10,10]).add;
)

/* BATCH MAKE */
( ~sines.do({arg i; i.free}); ~sines = 4.collect({arg i; Synth(\gliss,[
	// \out, ~compIn.index,
	\freq,rrand(1060,4500).postln
	,\freqLag,0.025
	,\panLag,20
	,\pan,1.0.bilinrand
	,\amp,0.0
	,\ampLag,0.1
])}))

/* BATCH CONTROL -- Entrée */
( ~sines
.do({ arg i; i.set(\dum,0
	,\freq, rrand(90, 266)
	,\freqLag,0.03
	// ,\pan,1.0.bilinrand
	,\panMod,0
	,\amp,0.025
	,\ampLag,0.1
)});)

/* CONTROL AU HASARD -- Panoramique modulation */
~sines[~sines.size.rand.post].set(\pan, 0, \panMod, 1.0.rand, \panFreq, 0.5.rand.postln)

/* ADD */
~sines = ~sines.addAll(Synth(\gliss, [\out, 3, \ampLag, 0.5, \amp, 0.025, \freq, 1300.0 + 18.0.rand, \pan, 0], ))

 /*CONTROL PRECIS */
~info.value(~sines)

(~sines[13
].set(
	\freq, 121
	,\freqLag, 60 * 2
	// ,\amp, 0.1
	// ,\ampLag, 300
))

/* BATCH CONTROL -- Freqs */
( ~sines
.do({ arg i; i.set(
	\freq,exprand(66,6066)
	,\freqLag,60*3
	// \amp, 0.0
	// ,\ampLag,50.5
	// \out, ~compIn.index
	// \pan, 1.0.bilinrand
)});)

/* LOOP CONTROL -- Freqs */
(r.stop; r.free; r = Routine({ loop {~sines.do({arg i; i.post; i.set( // Module lentement
	\freq, exprand(180,3390).postln
	,\freqLag, 60*3
	// , \amp, 0.01 + 0.005.rand
	// , \ampLag,0
	)});
		(60).wait;}
}).play)
r.stop

Routine({~sines.do({arg item; item.set(\amp,0, \ampLag, 10.rand); 10.wait; item.free}) }).play

~sines.do({arg i; i.set(\ampLag, rrand(100,630), \amp, 0.01)})
(s.free; s = Routine({ loop{ ~sines.scramble.do({arg i; i.set(\amp, [0.1,0].choose); 0.25.wait}); 1.wait }}).play )

/////////////////////////////////////////

/* ADD */
~sines = ~sines.addAll(Synth(\gliss, [\amp, 0.001,\freq, 4540.0.rand]))

~sines[1].set(\freq,55,\amp, 0.1)