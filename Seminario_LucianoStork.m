% Seminário - Processamento Digital de Sinais.
% Aluno: Luciano Stork, matrícula 204300018.
clear; close all; clc;

% Leitura do Sinal de Áudio:
[audio, Fs_audio] = audioread("Apresentação_Seminário.wav");
subplot(2,1,1)
% Tempo do Sinal de Áudio:
L_audio = size(audio,1);
tempo_audio = L_audio/Fs_audio;

% Plot do Sinal de Áudio no Domínio do Tempo:
x_audio = 0:1/Fs_audio:tempo_audio;
subplot(2,1,1)
plot(x_audio(2:end),audio,'b')
axis([-1.5 19.5 -1.5 1.5])
grid on
sgtitle("Representação do sinal de áudio");
title("Domínio do tempo");
xlabel("Duração [s]")
ylabel("Intensidade")

% Plot do Sinal de Áudio no Domínio da Frequência:
espectro_audio = abs(fft(audio));
espectro_audio = espectro_audio(1:L_audio/2);
freq_audio = Fs_audio*(0:(L_audio/2)-1)/L_audio;
subplot(2,1,2)
plot(freq_audio/10^3, espectro_audio,"b")
grid on
title("Domínio da frequência");
xlabel("Frequência [kHz]")
ylabel("Intensidade")
axis([-0.5 20.5 -500 3500])

% ---------------------------------------------------------------------

% Leitura do Sinal de Ruído:
[ruido, Fs_ruido] = audioread("Ruído.wav");

% Reprodução do Sinal de Ruído:
%sound(ruido, Fs_ruido);

% Interpolação dos dois vetores:
ruido_redimensionado = interp1(linspace(0, 1, length(ruido)), ruido, linspace(0, 1, length(audio)));

% Plot do Sinal de Ruído Redimensionado no Domínio do Tempo:
figure()
subplot(2,1,1)
plot(x_audio(2:end),ruido_redimensionado,'r')
axis([-1.5 19.5 -1.5 1.5])
grid on
sgtitle("Representação do sinal de ruído")
title("Domínio do tempo")
xlabel("Duração [s]")
ylabel("Intensidade")

% Plot do Sinal de Ruído Redimensionado no Domínio da Frequência:
espectro_ruido = abs(fft(ruido_redimensionado));
espectro_ruido = espectro_ruido(1:L_audio/2);
freq_ruido = Fs_ruido*(0:(L_audio/2)-1)/L_audio;
subplot(2,1,2)
plot(freq_ruido/10^3, espectro_ruido, "r")
grid on
title("Domínio da frequência");
xlabel("Frequência [kHz]")
ylabel("Intensidade")
axis([-0.5 20.5 -500 5000])

% ---------------------------------------------------------------------

% Soma dos Sinais:
audio_ruido = audio + ruido_redimensionado;
%sound(audio_ruido, Fs)

figure()
subplot(2,1,1)
plot(x_audio(2:end),audio,'b')
axis([-1.5 19.5 -1.5 1.5])
grid on
sgtitle("Sobreposição dos sinais");
title("Domínio do tempo");
xlabel("Duração [s]")
ylabel("Intensidade")
hold on
plot(x_audio(2:end),ruido_redimensionado,'r')
axis([-1.5 19.5 -1.5 1.5])
grid on
xlabel("Duração [s]")
ylabel("Intensidade") 

subplot(2,1,2)
plot(freq_audio/10^3, espectro_audio, "b")
grid on
title("Domínio da frequência");
xlabel("Frequência [kHz]")
ylabel("Intensidade")
axis([-0.5 20.5 -500 5000])
hold on
plot(freq_ruido/10^3, espectro_ruido, "r")
grid on
title("Domínio da frequência");
xlabel("Frequência [kHz]")
ylabel("Intensidade")
axis([-0.5 20.5 -500 5000])

% -----------------------------------------------------------
% Projeta o filtro bandpass
[b, a] = butter(4, [750, 850] / (Fs_audio/2), 'stop');

% Filtragem do sinal
audio_filtrado = filter(b, a, audio_ruido);

% Visualização da resposta em frequência
figure()
freqz(b, a);
grid on;
xlabel('Frequência (kHz)');
ylabel('Magnitude (dB)');
sgtitle('Resposta em Frequência do Filtro Rejeita Faixa');
legend('Filtro Rejeita Faixa');
axis([-0.25 1.25 -6.5 0.5])

% Plot do Sinal de Áudio Filtrado no Domínio do Tempo:
figure()
subplot(2,1,1)
plot(x_audio(2:end),audio_filtrado,'g')
axis([-1.5 19.5 -1.5 1.5])
grid on
sgtitle("Representação do sinal de áudio filtrado");
title("Domínio do tempo");
xlabel("Duração [s]")
ylabel("Intensidade")

% Plot do Sinal de Áudio Filtrado no Domínio da Frequência:
espectro_audio_filtrado = abs(fft(audio_filtrado));
espectro_audio_filtrado = espectro_audio_filtrado(1:L_audio/2);
freq_audio_filtrado = Fs_audio*(0:(L_audio/2)-1)/L_audio;
subplot(2,1,2)
plot(freq_audio_filtrado/10^3, espectro_audio_filtrado, "g")
grid on
title("Domínio da frequência");
xlabel("Frequência [kHz]")
ylabel("Intensidade")
axis([-0.5 20.5 -500 3500])