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

~prev = SystemClock.seconds;
~rout = {}.fork;
~thresh = 0.20;
OSCdef(\onsets, {|msg time addr recvPort|
  var now = SystemClock.seconds;
  var sendAddr = if(now - ~prev > ~thresh) { "/increase" } { "/decrease" };

  ~rout.stop;
  ~rout = {
    ~thresh.wait;
    ~client.sendMsg(sendAddr, 1);
  }.fork;

  ~prev = now;
}, '/onset');

~client.sendMsg("/set", 0);
