/*

SuperCollider Initiation
&
Additive Synthesis Experiments

*/

// Simplify your coding life :
// Menu > View > Show Autocomplete
// Menu > Edit > Preference > Editor > Behaviour > Auto insert matching parenthesis
// '' > Display > Highlight Bracket Content


/* 1. ARCHITECTURE & INTERFACE  */
// picture



/* 2. START */

// Start your Engines
// -> Type following text and evaluate the line to Boot the server
// -> MAC OS : |cmd| and |enter|
// -> PC : |ctrl| and |return/enter|
s.boot;



// Hello world : tells the server to communicate with you

"Hello".postln;

postln("hellos");




// Hello sound : create a SinOsc, wrap it in a function and play it (not to loud) to soundcard
// MAC OS curly brackets -> alt + Shift + (

SinOsc.ar(440)

{ SinOsc.ar(440) }

{ SinOsc.ar(440) * 0.1 }.play




/* STOP all sound : press simultaneously
-> MAC OS : |cmd| and |.|
-> PC : |ctrl| and |.|
*/




/* Useful measuring tools : ServerMeter, Freqscope, Node Tree
-> Activate them in with a right click on the status bar
*/















/*------------------------
   I. SINTESE ADITIVA
--------------------------*/



/* _A_ INDIVIDUAL RANDOMNESS */



// Choose your very own frequencie (in hz), evalutes on your turn, listen

{ SinOsc.ar( 1505 ) * 0.1 }.play











/* _B_ HARMONICS in A */

// Write this replacing ? by your position in the circle, evaluates on your turn, listen.

{ SinOsc.ar(  220 * ? ) * ( 0.1 / ? ) }.play













// Same thing but Evaluating all the SinOsc simultaneously : look curve : does it sound familiar?
(
{
	  SinOsc.ar(  220 * 1, 0, 0.1 / 1 )
	+ SinOsc.ar(  220 * 2, 0, 0.1 / 2 )
	+ SinOsc.ar(  220 * 3, 0, 0.1 / 3 )
	+ SinOsc.ar(  220 * 4, 0, 0.1 / 4 )
	+ SinOsc.ar(  220 * 5, 0, 0.1 / 5 )
	+ SinOsc.ar(  220 * 6, 0, 0.1 / 6 )
}.play;
)














/* _C_ USING LOOPS */



// Rule in coding = never repeat yourself
// in SuperCollider use the function Mix.fill is repeating a function and adding the results together
// /!\ first argument of a loop is automatically incremented before each iteration.

(
Mix.fill(3, {

	// auto increment argument;
	arg i;

	// Post the value of i in the post window
	("I'm loopy : " + i).postln;

	// Return i
	i;

})
)






// ?_ How can I make a SAW with : Mix.fill + incrementation + SinOsc.ar

(
{
	Mix.fill(6, { arg i;

		i = i+1 * 10;

		// SinOsc.ar( 220 * i  ) * ( 0.1 / i ) ) ;

		SinOsc.ar( i * rrand( 10, 20 ).postln ) * ( 0.1 / i ) ;

	})
}.play
)






/* SOLITARY ACTIVITY
Create a function using :

1. Mix.fill(n, {function})

2. an increment argument (arg i)

3. operators : +, -, *, %
(you can look for more operators in the documentation)


/!\ Use your headphones

/!\ Remember to multiply your signal by 0.1 or less to avoid crashing your ears/speakers.

/!\ when a sound is ok, copy/paste the code on a newline before tryng to improve it, to keep a track of your code.

/!\ produce a random number with : rrand( min , max )

/!\ Try Saw.ar() or Pulse.ar() instead of SinOsc.ar() -> pay attention to arguments


*/

{ Saw.ar ( ? ) * 0.1 }
{ Pulse.ar( ? , ? ) * 0.1 }


({Mix.fill( 20, { arg i;

	/*? ? ? ? ? ? ? ? ? ? ?*/

})}.play)





/*------------------------
   II. MODULATIONS : AM, FM
--------------------------*/






/* _A_ AMPLITUDE MODULATION */

{ Saw.ar(440) * SinOsc.ar( 10.rand ) * 0.1 }.play




// add postln, to see the result

{ Saw.ar(440) * SinOsc.ar( 10.rand.postln ) * 0.1 }.play

// use a floating number
{ Saw.ar(440) * SinOsc.ar( 10.0.rand.postln ) * 0.1 }.play



/* _B_ FREQUENCE MODULATION */



// Describe what this function will do

{ SinOsc.ar( SinOsc.ar(1) * 10 + 110 ) * 0.1 }.play









// Equivalent to :
{ SinOsc.ar( SinOsc.ar( 1, 0, 10, 110 ) ) }


{ SinOsc.ar( SinOsc.ar(66).range(200, 520) ) * 0.1 }.play


// Why? Check the Documentation to know what arguments are used by the function :
// -> set cursor on the function name and press |ctrl| and |d|






// Try make one
{ Pulse.ar( SinOsc.ar( ? ) * ? + ? ) * 0.1 }






// /!\ .range(min, max) Helps you to scale a signal to the values you need (get rid of theses * and + factors)

( {	SinOsc.ar(
		SinOsc.ar( 0.5 ).range( 220, 330 )
	) * 0.1
}.play )









/* _C_ STEREO & ARRAYS */



// Let's decompose out first sound

{ SinOsc.ar( 666 ) * 0.1 }.play

SinOsc.ar( 666 )

0.1

SinOsc.ar( 666 ) * 0.1


SinOsc.ar(111) + SinOsc.ar(222)




// Always 1 object ! That goes to 1 channel

{SinOsc.ar(111) * SinOsc.ar(222) * 0.1 }.play



({SinOsc.ar(111) * SinOsc.ar(222) * 0.1 }.play;
{SinOsc.ar(111) * SinOsc.ar(222) * 0.1 }.play;)







// How can I send 2 objects in the same time ?
// => send an ARRAY of 2 values



/* An ARRAY is a collection with a certain number of slots that may contain any object. */

x = [ 3, 1.23, "H3ll0 !!"]

x

y = [ SinOsc.ar( 1235 ) , Saw.ar( 892 ), 3 ]

z = [ x , y ]

z[0][1]








// Send an array with 2 SinOsc.ar() of your choice to the server using {}.play

{ [ SinOsc.ar(440) * 0.1 , SinOsc.ar(440) * 0.1 ] }.play











// VIRAL ARRAYS : operations including an array will alway output an array


[2, 4] * 0.1


[SinOsc.ar(244), SinOsc.ar(244)] * 0.1


{ [SinOsc.ar(244), SinOsc.ar(244)] * 0.1 }.play


{SinOsc.ar(244) * [0.1,0.1]}.play


0.1.dup


SinOsc.ar(244) * 0.1.dup

{SinOsc.ar(738) * 0.1 + 0.02.dup}.play

{SinOsc.ar( [278, 289] ) * 0.1 }.play


// Panoramic

{ SinOsc.ar( 400 ) * LFPulse.ar(1, [0, 0.5] ) * 0.1 }.play


/* BACK TO SOUND ! */

// Play a stereo sound with 1 synthesis technique of your choice : adition and modulation


















/* _D_ GO COMPLEX */

// How to make your code clear with complexe operations

(
{ var sig, mod;
	mod = SinOsc.ar(34) + SinOsc.ar(18) + SinOsc.ar(SinOsc.ar(0.01) + 34.5);
	sig = SinOsc.ar(mod * 25 + 1200) + SinOsc.ar( mod.range(1000, 1300)) + SinOsc.ar(189) + SinOsc.ar(172) * SinOsc.ar(144.5) * 0.1.dup;
}.play
)



// Equivalent :

(
{ var sig, mod;
	mod = SinOsc.ar(34) + SinOsc.ar(18);

	mod = mod + SinOsc.ar(SinOsc.ar(0.01) + 34.5);

	sig = SinOsc.ar(mod * 25 + 1200);

	sig = sig + SinOsc.ar( mod.range(1000, 1300));

	sig = sig + SinOsc.ar(189) + SinOsc.ar(172) * SinOsc.ar(144.5);

	sig = sig * 0.1.dup;

}.play

)

// CONTROL : Name your nodes to shut it down, and modify it in real time it's' arguments.

x = { SinOsc.ar( 110 ) * 0.1.dup }.play
y = { Saw.ar( 119 ) * 0.1.dup }.play

x.free
y.free




z = {arg pulseFreq=800, sawFreq=300 ; Pulse.ar( pulseFreq , 0.5, Saw.ar( sawFreq ) * 0.1 )!2 }.play
z.set( \pulseFreq, 100 )
z.set( \pulseFreq, 10 )
z.set( \sawFreq, 84 , \pulseFreq, 5)
z.free



// LIVE CODING TOOL
// -> Ndef( \name, { function } )


// 1. White noise
Ndef(\cascada, { WhiteNoise.ar( 0.1 ) } ).play


Ndef(\cascada).stop // On
Ndef(\cascada).play // Off




// 2. Add Amplitude Modulation
Ndef(\cascada, { WhiteNoise.ar( 0.1 ) * LFPulse.kr( [ 1 , 0.4 ] ) } ).play




// 3. Smoother transitions
Ndef(\cascada).fadeTime = 10



// 4. a Saw instead of white noise
Ndef(\cascada, { Saw.ar( 122, 0.1 ) * LFPulse.kr( [ 4 , 3 ] ) } ).play


// Clean your room :
Ndef(\cascada).clear(5)

Ndef(\cascada).play




// LIST OF OBJECTS
// -> Ugens creating different wave shapes
{SinOsc.ar(440, 0)}.plot
{Pulse.ar(440, 0.5)}.plot
{Saw.ar(440)}.plot
{VarSaw.ar(440,0,0.5)}.plot

{LFPulse.ar(440)}.plot
{LFSaw.ar(440)}.plot
{LFTri.ar(440)}.plot


{SinOsc.ar(440) * Line.ar(0, 0.1,1)}.plot(1)
{SinOsc.ar(440) * XLine.ar(0.0001, 0.1,1)}.plot(1)


{Decay2.ar( Impulse.ar(1 + 8.rand), 0.01, 0.5, Saw.ar(66 + 300.rand ) * 0.1 * Line.kr( 1, 0,1) )!2 }.play



// RECORDING

s.record

// or -> right click on status bar : "Start recording"


s.pauseRecording
s.stopRecording





/* _Z_ SIGNAL THEORY */

// Overtones, harmonics and Additive synthesis
// https://www.youtube.com/watch?v=YsZKvLnf7wU


// Fourrier transform
// https://youtu.be/spUNpyF58BY?t=50s






/* PRACTICAL EXAMPLES */

// Create other shapes using sines
{Mix.fill(5, { arg j; j.postln })}.play

// SAW : 1 fundamental + infinity of harmonics (amplitude divided by it's number)

({ Mix.fill(18, {
	arg i;
	SinOsc.ar(110 * (i+1), 0, 0.1 / ( i + 1 ));
})}.play)


// SQUARE : 1 fundamental + odd harmonics (amplitude = 1/x)
({ Mix.fill(4, {
	arg i;
	i = i*2+1;
	SinOsc.ar(110 * i, 0, 0.1/i)
};
)}.play)





/*// TRIANGLE : 1 fund + odd harmnics (amplitude = 1/x² alternating + and -)
({ Mix.fill(19, {
	arg i, amp;
	i = i *2 + 1;
	if( i.odd){ amp= i.squared } {amp = i.neg.squared };
	i.postln;
	SinOsc.ar(110 * i, 0, 0.1/i.squared)
};
)}.play)*/



({ Mix.fill(16, { arg i;
	i = i+1;
	SinOsc.ar( 110 * i.atan.exp, 0, 0.1 / i.sqrt)
})}.play)



// Ugens creating different wave shapes
{SinOsc.ar(440, 0)}.plot
{Pulse.ar(440, 0.5)}.plot
{Saw.ar(440)}.plot
{VarSaw.ar(440,0,0.5)}.plot

{LFPulse.ar(440)}.plot
{LFSaw.ar(440)}.plot
{LFTri.ar(440)}.plot


/* MODULATIONS */

// Amplitude modulation
{ SinOsc.ar(440) * SinOsc.ar(12) * 0.1}.play
{SinOsc.ar(440) * LFSaw.ar(40).dup(2) * 0.1}.play

// Frequency modulation
{Pulse.ar(700 * SinOsc.kr(14)) * 0.1}.play


// modulate the frequency with an exponential ramp
{ SinOsc.ar( XLine.kr(2000, 200.rand, 0.001), 0, 0.5) }.play;


// modulate the frequency with an exponential ramp
{ SinOsc.ar( XLine.kr(2000, rrand(200, 400), 0.001), 0, 0.5) }.play;


/* ENVELOPES : sounds with a begining and an end */

Env([0,1,0], [0.1, 0.5], [0, 0]).plot

Env.adsr(0.01, 1,0.5)

(x = {
	arg freq = 440, amp=0.4, gate=1;
	var env, fm, sig;
	// env = Env([0,1,0], [0.01, 0.5]).kr(2);
	env = Env.adsr().kr(0, gate);
	fm = 100 * SinOsc.kr(40) + 20;
	sig = SinOsc.ar(fm) + SinOsc.ar( 390* env)  * env * amp;
}.play
)

x.release
x.set(\gate, 1)


/* "INSTRUMENTS" to use and re-use : Synth Def */

(
SynthDef("windsynth", {
	arg freq = 1300, amp = 0.1, modFreq = 1;
	var sig, fm;
	// Generate random Freq modulation
	fm = LFNoise1.ar(modFreq).range(freq, freq*2);
	// Duplicate 8 times following function and mix the signals into one signal
	sig = Mix.fill(28, {
		SinOsc.ar(
			fm + 900.rand, // Frequency : Add a random value between 0 and 900 to fm
			0, // Phase
			1/8 // Mul : used as amplitude to avoid clipping
		)
	});

	// Panoramic : Define position of signal in a stereo field : -1 = left / 1 = right / 0 = centered
	// this outputs 2 channels : then "sig" will be an array of 2 item
	sig = Pan2.ar(sig, LFPulse.kr(0.5).range(-1, 1));

	// don't forget to apply amp factor
	sig = sig * amp;

	// Out.ar send something to a bus. By default the bus 0 is the first channel of your sound card
	Out.ar(0, sig);

}).add // add the synth definition to the session
)

y = Synth("windsynth");  // play the sound
y.set(\freq, 260) // change values of arguments
y.set(\modFreq, 10)
y.free // free the synth