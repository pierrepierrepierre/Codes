// ENREGISTRE A LA VOLEE

(	 /// Synth Def
SynthDef(\rec, {arg out=0, bufnum=0, dur=4, in=2, amp=0.1, monitor=0, over=0, loop=0;
	var sig;

	// sig = Formant.ar( 8, 1030,830);

	sig = In.ar(in, 2) * amp * Line.kr(1,1, dur);

	RecordBuf.ar(sig, bufnum, 0, 1, over, doneAction:Done.freeSelf, loop:loop);

	Out.ar(out, sig * monitor);

}).add;

SynthDef(\play, {arg out = 0, bufnum=0, start=0, dur=4, att=0.1, rel=0.5, ampLag=0.01, rateLag=0.01, loop=0;
	var sig, env;
	var amp = NamedControl.kr(\amp,0.5,ampLag);
	var rate = NamedControl.kr(\rate,1,rateLag);

	// env = Env([0,1,1,0], [att, dur, rel]).kr(0);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rate, 1, start, loop);
	FreeSelfWhenDone.kr(sig); // frees the synth when the PlayBuf is finished
	Out.ar(out, sig * amp);
}).add;
)

(// allocate a Buffer
s = Server.local;
b = Buffer.alloc(s, 44100 * 3,2); // a 10 second 1 channel Buffer
)

b.free

x = Synth(\rec, [\monitor, 0, \dur, 10, \bufnum, b, \amp, 0.1, \over,0])
x.set(\loop, 1, \over, 0.2, \monitor, 1)
x.free

y = Synth(\play, [\bufnum, b, \loop, 1.0])
y.set(\amp, 1.3, \rate, 1)
y.free

// REC OVER
z = Synth(\rec, [\monitor, 1, \loop, 1, \bufnum, b, \over, 1])
z.set(\over, 1, \amp, 0.2)
z.free

// Execute the following in order


// record for four seconds
(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
    formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125);
    RecordBuf.ar(formant, bufnum, doneAction: Done.freeSelf, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
)

// play it back
(
SynthDef(\help_RecordBuf_playback, { arg out = 0, bufnum = 0;
    var playbuf;
    playbuf = PlayBuf.ar(1,bufnum);
    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, b]);
)

// overdub
(
SynthDef(\help_RecordBuf_overdub, { arg out=0, bufnum=0;
    var formant;
    formant = Formant.ar(XLine.kr(200, 1000, 4), 2000, 800, 0.125);
    // mixes equally with existing data
    RecordBuf.ar(formant, bufnum, 0, 0.3, 0.5, doneAction: Done.freeSelf, loop: 0);
}).play(s, [\out, 0, \bufnum, b]);
)

// play back the overdubbed version
Synth.new(\help_RecordBuf_playback, [\out, 0, \bufnum, b], s);

// write the contents of the buffer to a file (see Buffer for more options)
(
b.write(sampleFormat: 'int16');
thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff"; // generated path
)

b.close; b.free; // cleanup