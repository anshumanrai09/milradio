<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <title>Tactical Web PTT - MilRadio v4</title>
  
  <!-- Fonts & PeerJS CDN -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:wght@500;700&family=Share+Tech+Mono&display=swap" rel="stylesheet">
  <script src="https://unpkg.com/peerjs@1.5.2/dist/peerjs.min.js"></script>

  <style>
    :root {
      --case-bg: #272c29;
      --case-border: #181c1a;
      --lcd-bg: #09170e;
      --lcd-glow: #38ef7d;
      --lcd-dim: #134e2b;
      --accent-orange: #ff7700;
      --accent-red: #ff2222;
      --screw: #505652;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      user-select: none;
      -webkit-user-select: none;
    }

    body {
      background: radial-gradient(circle at center, #1a1e1b, #090a09);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Chakra Petch', sans-serif;
      padding: 16px;
      color: #eee;
    }

    /* Outer Radio Chassis */
    .radio-chassis {
      position: relative;
      width: 100%;
      max-width: 370px;
      background: var(--case-bg);
      border: 5px solid var(--case-border);
      border-radius: 36px 36px 28px 28px;
      padding: 24px 20px 28px;
      box-shadow: 0 25px 60px rgba(0,0,0,0.85), inset 0 2px 4px rgba(255,255,255,0.1);
    }

    /* Antenna & Top Knobs */
    .top-fixtures {
      position: absolute;
      top: -38px;
      left: 0;
      right: 0;
      display: flex;
      justify-content: space-between;
      padding: 0 32px;
      pointer-events: none;
    }
    .antenna {
      width: 14px;
      height: 38px;
      background: linear-gradient(90deg, #3a3f3c, #111);
      border-radius: 4px 4px 0 0;
      border: 1px solid #111;
      border-bottom: none;
    }
    .knob {
      width: 26px;
      height: 18px;
      margin-top: 20px;
      background: repeating-linear-gradient(90deg, #1f2320, #1f2320 3px, #424944 4px, #1f2320 5px);
      border-radius: 4px 4px 0 0;
      border: 2px solid #111;
      border-bottom: none;
    }

    /* Screws */
    .screw {
      position: absolute;
      width: 10px;
      height: 10px;
      background: var(--screw);
      border-radius: 50%;
      box-shadow: inset 1px 1px 2px #000;
    }
    .screw::after {
      content: '';
      position: absolute;
      top: 4px;
      left: 1px;
      width: 8px;
      height: 2px;
      background: #111;
    }
    .tl { top: 12px; left: 12px; }
    .tr { top: 12px; right: 12px; }
    .bl { bottom: 12px; left: 12px; }
    .br { bottom: 12px; right: 12px; }

    /* Header & Indicator LEDs */
    .header-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 14px;
      border-bottom: 2px solid #1d211e;
      padding-bottom: 10px;
    }
    .brand-title {
      font-weight: 700;
      font-size: 13px;
      letter-spacing: 2px;
      color: #8c978f;
    }
    .led-cluster {
      display: flex;
      gap: 12px;
      align-items: center;
    }
    .led-wrap {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 3px;
    }
    .led-wrap span {
      font-size: 8px;
      font-weight: 700;
      color: #667269;
    }
    .led {
      width: 9px;
      height: 9px;
      border-radius: 50%;
      background: #1c201d;
      border: 1px solid #111;
      transition: all 0.2s;
    }
    .led.pwr { background: #00ff66; box-shadow: 0 0 8px #00ff66; }
    .led.rx.active { background: #ffaa00; box-shadow: 0 0 10px #ffaa00; }
    .led.tx.active { background: #ff2222; box-shadow: 0 0 12px #ff2222; animation: blink 0.3s infinite alternate; }
    @keyframes blink { to { opacity: 0.3; } }

    /* CRT Military LCD */
    .lcd-screen {
      background: var(--lcd-bg);
      border: 3px solid #161917;
      border-radius: 12px;
      padding: 12px 14px;
      box-shadow: inset 0 0 16px rgba(0,0,0,0.9);
      position: relative;
      overflow: hidden;
      margin-bottom: 16px;
    }
    .lcd-screen::before {
      content: " ";
      position: absolute;
      inset: 0;
      background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.45) 50%);
      background-size: 100% 3px;
      pointer-events: none;
      z-index: 2;
    }
    .lcd-top {
      display: flex;
      justify-content: space-between;
      font-family: 'Share Tech Mono', monospace;
      font-size: 11px;
      color: var(--lcd-glow);
      text-transform: uppercase;
      margin-bottom: 6px;
    }
    .lcd-frequency {
      font-family: 'Share Tech Mono', monospace;
      font-size: 38px;
      line-height: 1;
      color: var(--lcd-glow);
      text-shadow: 0 0 10px rgba(56, 239, 125, 0.6);
      text-align: center;
      letter-spacing: 5px;
      margin: 4px 0 8px;
    }
    .lcd-label {
      font-size: 9px;
      text-align: center;
      color: var(--lcd-dim);
      letter-spacing: 1.5px;
      margin-bottom: 8px;
    }

    /* Waveform Canvas */
    #visualizer {
      width: 100%;
      height: 42px;
      display: block;
      background: rgba(0, 0, 0, 0.4);
      border-radius: 4px;
      border: 1px solid var(--lcd-dim);
    }

    /* Input Controls */
    .controls-panel {
      display: flex;
      flex-direction: column;
      gap: 10px;
      margin-bottom: 16px;
    }
    .input-row {
      display: flex;
      gap: 8px;
    }
    .freq-input {
      flex: 1;
      background: #151816;
      border: 2px solid #333a35;
      border-radius: 8px;
      color: #38ef7d;
      font-family: 'Share Tech Mono', monospace;
      font-size: 18px;
      letter-spacing: 3px;
      text-align: center;
      padding: 10px;
      outline: none;
    }
    .freq-input:focus { border-color: var(--accent-orange); }
    .btn-action {
      background: #3a423d;
      border: 2px solid #232724;
      border-radius: 8px;
      color: #fff;
      font-family: 'Chakra Petch', sans-serif;
      font-weight: 700;
      font-size: 13px;
      padding: 0 16px;
      cursor: pointer;
      transition: background 0.15s;
    }
    .btn-action:active { background: #232724; }

    /* Push-To-Talk Button */
    .ptt-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;
      margin: 10px 0 18px;
    }
    .ptt-button {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      background: radial-gradient(circle at 35% 35%, #59615a, #242825 80%);
      border: 6px solid #161917;
      color: #bbb;
      font-family: 'Chakra Petch', sans-serif;
      font-weight: 700;
      font-size: 15px;
      letter-spacing: 1.5px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.7), inset 0 2px 4px rgba(255,255,255,0.2);
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      touch-action: none;
      cursor: not-allowed;
      transition: transform 0.08s, box-shadow 0.08s, background 0.15s;
    }
    .ptt-button.ready {
      background: radial-gradient(circle at 35% 35%, #ff8800, #b84700 80%);
      color: #fff;
      border-color: #572000;
      cursor: pointer;
    }
    .ptt-button.transmitting {
      transform: scale(0.93);
      background: radial-gradient(circle at 35% 35%, #ff3b30, #910e06 80%) !important;
      border-color: #400400 !important;
      box-shadow: 0 0 35px rgba(255, 34, 34, 0.8), inset 0 3px 6px rgba(0,0,0,0.6);
      color: #fff !important;
    }

    /* Speaker Grill */
    .speaker-grill {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 5px;
      padding-top: 8px;
    }
    .grill-line {
      height: 4px;
      background: #171a18;
      border-radius: 2px;
      box-shadow: inset 0 1px 2px #000;
    }
    .grill-1 { width: 50%; }
    .grill-2 { width: 68%; }
    .grill-3 { width: 80%; }
    .grill-4 { width: 68%; }
    .grill-5 { width: 50%; }

    .instructions {
      font-size: 10px;
      color: #79867e;
      text-align: center;
      margin-top: 8px;
      letter-spacing: 1px;
    }
  </style>
</head>
<body>

  <div class="radio-chassis">
    <!-- Antenna and Top Dials -->
    <div class="top-fixtures">
      <div class="antenna"></div>
      <div class="knob"></div>
    </div>

    <!-- Case Screws -->
    <div class="screw tl"></div>
    <div class="screw tr"></div>
    <div class="screw bl"></div>
    <div class="screw br"></div>

    <!-- Upper Control Header -->
    <div class="header-bar">
      <div class="brand-title">MIL-SPEC // PTT-88</div>
      <div class="led-cluster">
        <div class="led-wrap"><div class="led pwr"></div><span>PWR</span></div>
        <div class="led-wrap"><div id="ledRx" class="led rx"></div><span>RX</span></div>
        <div class="led-wrap"><div id="ledTx" class="led tx"></div><span>TX</span></div>
      </div>
    </div>

    <!-- Phosphor Green LCD -->
    <div class="lcd-screen">
      <div class="lcd-top">
        <span id="lcdStatus">INITIALIZING...</span>
        <span>SIG: 99%</span>
      </div>
      <div class="lcd-label">COMMUNICATION FREQUENCY</div>
      <div id="lcdFreq" class="lcd-frequency">----</div>
      <canvas id="visualizer"></canvas>
    </div>

    <!-- Frequency Switch Panel -->
    <div class="controls-panel">
      <div class="input-row">
        <input type="text" id="targetFreq" class="freq-input" placeholder="CODE (4-DIGIT)" maxlength="4" />
        <button id="btnConnect" class="btn-action" onclick="connectFrequency()">LOCK IN</button>
      </div>
    </div>

    <!-- Push-To-Talk Center -->
    <div class="ptt-wrapper">
      <button id="pttButton" class="ptt-button">OFFLINE</button>
      <div id="hintLabel" class="instructions">PERMIT MIC ACCESS TO OPERATE</div>
    </div>

    <!-- Bottom Speaker Grill -->
    <div class="speaker-grill">
      <div class="grill-line grill-1"></div>
      <div class="grill-line grill-2"></div>
      <div class="grill-line grill-3"></div>
      <div class="grill-line grill-4"></div>
      <div class="grill-line grill-5"></div>
    </div>
  </div>

  <audio id="remoteAudio" autoplay playsinline></audio>

  <script>
    // 1. Generate 4-Digit Local Frequency Code
    const myFreq = Math.floor(1000 + Math.random() * 9000).toString();
    document.getElementById("lcdFreq").innerText = myFreq;

    let peer = null;
    let localStream = null;
    let currentCall = null;
    let isConnected = false;
    let isTransmitting = false;

    // Web Audio Synthesizer & Visualizer Elements
    let audioCtx = null;
    let analyserNode = null;
    let canvas = document.getElementById("visualizer");
    let canvasCtx = canvas.getContext("2d");

    const lcdStatus = document.getElementById("lcdStatus");
    const pttButton = document.getElementById("pttButton");
    const ledRx = document.getElementById("ledRx");
    const ledTx = document.getElementById("ledTx");
    const hintLabel = document.getElementById("hintLabel");
    const remoteAudio = document.getElementById("remoteAudio");

    // Audio Context Init (User interaction ke sath)
    function getAudioContext() {
      if (!audioCtx) {
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
      }
      if (audioCtx.state === 'suspended') {
        audioCtx.resume();
      }
      return audioCtx;
    }

    // 2. Synthesize Authentic Tactical Squelch (PTT Press Sound)
    function playSquelchSound() {
      const ctx = getAudioContext();
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();

      osc.type = "sawtooth";
      osc.frequency.setValueAtTime(140, ctx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(40, ctx.currentTime + 0.08);

      gain.gain.setValueAtTime(0.35, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.08);

      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      osc.stop(ctx.currentTime + 0.08);
    }

    // 3. Synthesize NASA / Apollo Roger Beep (PTT Release Sound)
    function playRogerBeep() {
      const ctx = getAudioContext();
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();

      osc.type = "sine";
      osc.frequency.setValueAtTime(2475, ctx.currentTime); // Standard 2.475 kHz tone

      gain.gain.setValueAtTime(0.25, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.18);

      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      osc.stop(ctx.currentTime + 0.18);
    }

    // 4. Initialize Local Microphone
    navigator.mediaDevices.getUserMedia({ audio: true, video: false })
      .then(stream => {
        localStream = stream;
        // Default: Mute microphone track
        localStream.getAudioTracks()[0].enabled = false;
        setupVisualizer(stream);
        initPeer();
      })
      .catch(err => {
        lcdStatus.innerText = "MIC ERROR";
        hintLabel.innerText = "MICROPHONE ACCESS DENIED BY BROWSER";
        console.error(err);
      });

    // 5. Setup Oscilloscope Canvas
    function setupVisualizer(stream) {
      const ctx = getAudioContext();
      const source = ctx.createMediaStreamSource(stream);
      analyserNode = ctx.createAnalyser();
      analyserNode.fftSize = 256;
      source.connect(analyserNode);

      const bufferLength = analyserNode.frequencyBinCount;
      const dataArray = new Uint8Array(bufferLength);

      function draw() {
        requestAnimationFrame(draw);
        canvasCtx.fillStyle = "rgba(9, 23, 14, 0.4)";
        canvasCtx.fillRect(0, 0, canvas.width, canvas.height);

        if (!isTransmitting) {
          // Idle flat line with scan flicker
          canvasCtx.lineWidth = 1.5;
          canvasCtx.strokeStyle = "#134e2b";
          canvasCtx.beginPath();
          canvasCtx.moveTo(0, canvas.height / 2);
          canvasCtx.lineTo(canvas.width, canvas.height / 2);
          canvasCtx.stroke();
          return;
        }

        analyserNode.getByteTimeDomainData(dataArray);
        canvasCtx.lineWidth = 2;
        canvasCtx.strokeStyle = "#38ef7d";
        canvasCtx.beginPath();

        const sliceWidth = canvas.width * 1.0 / bufferLength;
        let x = 0;

        for (let i = 0; i < bufferLength; i++) {
          const v = dataArray[i] / 128.0;
          const y = v * canvas.height / 2;
          if (i === 0) canvasCtx.moveTo(x, y);
          else canvasCtx.lineTo(x, y);
          x += sliceWidth;
        }

        canvasCtx.lineTo(canvas.width, canvas.height / 2);
        canvasCtx.stroke();
      }
      draw();
    }

    // 6. Setup PeerJS Signaling
    function initPeer() {
      peer = new Peer(myFreq);

      peer.on('open', () => {
        lcdStatus.innerText = "STANDBY // READY";
        hintLabel.innerText = "ENTER FREQUENCY OR SHARE CODE";
      });

      // Receiver handling
      peer.on('call', (call) => {
        currentCall = call;
        call.answer(localStream);
        bindAudioCall(call);
        setConnected(call.peer);
      });

      peer.on('error', (err) => {
        lcdStatus.innerText = "LINK FAILED";
        console.error(err);
      });
    }

    function connectFrequency() {
      const target = document.getElementById("targetFreq").value.trim();
      if (!target || target === myFreq) {
        alert("Enter valid target 4-digit frequency!");
        return;
      }
      lcdStatus.innerText = "TUNING...";
      const call = peer.call(target, localStream);
      currentCall = call;
      bindAudioCall(call);
      setConnected(target);
    }

    function bindAudioCall(call) {
      call.on('stream', (remoteStream) => {
        remoteAudio.srcObject = remoteStream;
        ledRx.classList.add("active");
      });
      call.on('close', () => {
        alert("Frequency Lost.");
        location.reload();
      });
    }

    function setConnected(freqCode) {
      isConnected = true;
      lcdStatus.innerText = "SYNC: " + freqCode;
      pttButton.innerText = "HOLD\nTO TALK";
      pttButton.classList.add("ready");
      hintLabel.innerText = "HOLD PTT BUTTON OR SPACEBAR TO TRANSMIT";
    }

    // 7. Push-To-Talk Logic
    function startTransmission(e) {
      if (!isConnected || !localStream || isTransmitting) return;
      if (e) e.preventDefault();

      isTransmitting = true;
      playSquelchSound();
      localStream.getAudioTracks()[0].enabled = true;

      pttButton.classList.add("transmitting");
      pttButton.innerText = "TRANSMIT";
      ledTx.classList.add("active");
      lcdStatus.innerText = "TRANSMITTING...";
    }

    function stopTransmission(e) {
      if (!isConnected || !localStream || !isTransmitting) return;
      if (e) e.preventDefault();

      isTransmitting = false;
      localStream.getAudioTracks()[0].enabled = false;
      playRogerBeep();

      pttButton.classList.remove("transmitting");
      pttButton.innerText = "HOLD\nTO TALK";
      ledTx.classList.remove("active");
      lcdStatus.innerText = "MONITORING";
    }

    // Mouse & Touch bindings
    pttButton.addEventListener("mousedown", startTransmission);
    window.addEventListener("mouseup", stopTransmission);
    pttButton.addEventListener("touchstart", startTransmission, { passive: false });
    window.addEventListener("touchend", stopTransmission, { passive: false });

    // Spacebar keyboard binding
    window.addEventListener("keydown", (e) => {
      if (e.code === "Space" && e.target.tagName !== "INPUT") {
        startTransmission();
      }
    });
    window.addEventListener("keyup", (e) => {
      if (e.code === "Space" && e.target.tagName !== "INPUT") {
        stopTransmission();
      }
    });
  </script>
</body>
</html>