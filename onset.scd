s.waitForBoot {
  SynthDef(\onset, {|in=0 threshold=0.5 relaxtime=1 floor=0.1|
    var sig = SoundIn.ar(in);
    var chain = FFT(LocalBuf(512, 1), sig);
    var onsets = Onsets.kr(chain, threshold, 'rcomplex', relaxtime, floor);

    SendReply.kr(onsets, '/onset', [1]);
  }).add;

  OSCdef(\onsets, {|msg time addr recvPort|
    msg.postln;
  }, '/onset');

  ~onsets = Synth(\onset, 1);
}
