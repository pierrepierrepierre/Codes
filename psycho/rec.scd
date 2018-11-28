// ENREGISTRE A LA VOLEE

(	 /// Synth Def
SynthDef(\play, {arg out = 0, bufnum=0, start=0, att=0.1, rel=0.1, ampLag=0.01, rateLag=0.01, loop=0, dur=1;
	var sig, trig, env, len;
	var amp = NamedControl.kr(\amp,0.5,ampLag);
	var rate = NamedControl.kr(\rate,1,rateLag);
	len = dur - (att + rel);
	env = Env([0,1,1,0], [att, len, rel]).kr(2);


	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rate, 1, BufFrames.kr(bufnum) * start, loop, 2);
	Out.ar(out, sig * amp * env);
}).add;
)

~p = Synth("play", [\bufnum, b, \dur, 13000, \start, 0, \amp, 0.5])
~p.set(\rateLag, 130, \rate, 1)
~p.set(\amp, 0.75)
~p.free

Pbindef(\p, \instrument, \play, \bufnum, b.bufnum, \dur, 1, \start, Pseq([Pseries(0, 0.0001,1000)],inf) * 1 + 0.3 , \amp, 0.5).play
Pbindef(\p, \dur, Pseq([ Pseries(1, -0.01, 99), Pseq([0.001], 1000), Pseries(0.01, 0.01, 99) ],inf ) )




(// allocate a Buffer & a position Control bus
b = Buffer.read(s,"/home/pierre/Musique/Musique maison/WAV2/Tapette Fest Rec/CD master/WAV2 & Martin - Tapette Fest.wav" );
~pos = Bus.control(s);
)

(
SynthDef(\read, { arg bus = 0, posBus=1, bufnum=0, rate=1, start=0, amp=0.1, freq=0, factor=1;
	var trig, pos, sig, frames, loop;
	frames = BufFrames.kr(bufnum);
	loop = ( freq == 0 ).asInteger;
	trig = Impulse.kr( freq ,0.5);
	pos = Phasor.ar( Delay1.kr(trig), BufRateScale.kr(bufnum) * rate, frames * start, frames, In.kr(posBus) - ( BufSampleRate.kr(bufnum) * rate * (loop-1).abs / (loop + freq) * factor) );
	Out.kr(posBus, Latch.kr( pos , trig));
	sig = BufRd.ar(2, bufnum, pos, 1);
	Out.ar(bus, sig * amp)  ;
}).add;
)


v = Synth(\read, [\bufnum, b.bufnum, \posBus, ~pos, \amp, 1, \start,0])
v.free

v.set(\freq, 0, \amp, 1.2, \factor, 1 )
~pos.get

v.set(\rate, 1)



b.close; b.free; // cleanup