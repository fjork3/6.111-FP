# Takes in audio samples, and generates Mel-scale frequency vectors
# Operates on 1024 samples of data (for hardware, need several operating on overlapping data sets to generate multiple feature vectors)

from numpy.fft import *
import math



# filter boundaries for 257-point FFT
boundaries = [0,3,6,10,14,18,24,30,36,44,52,62,72,85,98,114,131,150,173,197,225,257]


# Takes in a chunk of audio samples and applies an FFT; gives out Fourier coefficients, to be used by Mel filters.
def take_fft(audio_in):
   numpy.fft(512)


# Applies a single Mel filter to get a power spectrum in that filter's range.
# fft_in: list of coefficients
# bins: 3-tuple of low, mid, high bins
# 
def mel_filter(bins, fft_in):
   (low, mid, high) = bins
   # for hardware implementation, would hard-code coeffs
   coeffs = [0]*len(fft_in)
   coeffs[mid] = 1000
   for i in range(low, mid):
      coeffs[i] = int(1000*float(i-low)/(mid-low))
   for i in range(mid, high):
      coeffs[i] = int(1000*(1-float(i-mid)/(high-mid)))
   print coeffs






# Given 1 s of audio stored in an array, calculate feature vectors on overlapped chunks
def process_audio(audio_in):
   pass


   # for each chunk of audio data:
   # - take 512-point FFT
   # - keep top 400 coeffs


'''
# test of numpy FFT
audio = [math.cos(x) for x in xrange(400)]
print audio
print fft(audio)
'''

# testing filter coeff generator
mel_filter((0, 3, 7), [0]*12)

