~client = NetAddr("127.0.0.1", 6666);

s.waitForBoot {
  SynthDef(\onset, {|in=0 threshold=0.5 relaxtime=1 floor=0.1|
    var sig = SoundIn.ar(in);
    var chain = FFT(LocalBuf(512, 1), sig);
    var onsets = Onsets.kr(chain, threshold, 'rcomplex', relaxtime, floor);

    SendReply.kr(onsets, '/onset', [1]);
  }).add;

  s.sync;

  ~onsets = Synth(\onset, 1);
}

~onsets.set(\floor, 0.3, \relaxtime, 2);

~prev = SystemClock.seconds;
~rout = {}.fork;
~thresh = 0.20;
~count = 0;
~done = false;
OSCdef(\onsets, {|msg time addr recvPort|
  var now = SystemClock.seconds;
  if(~done) {
    ~count.postln;
  } {
    ~count = ~count + 1;
    ~count.postln;
  };

  ~rout.stop;
  ~rout = {
    ~done = false;
    ~thresh.wait;
    ~done = true;

    if(~count == 1) {
      ~client.sendMsg("/increase", 1);
    };
    if (~count == 2) {
      ~client.sendMsg("/decrease", 1);
    };
    if (~count == 3) {
      ~client.sendMsg("/set", 0);
    };

    ~count = 1;
  }.fork;

  ~prev = now;
}, '/onset');



~client.sendMsg("/set", 0);
