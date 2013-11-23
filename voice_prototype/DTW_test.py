# Testing implementation of DTW scheme on recorded audio

import math
import wave
import numpy


def DTW_score(a, b):
    '''Given two lists a and b, compute the optimal DTW score between the two.'''

    memo = {}

    if len(a) != len(b):
        print "Non-matching inputs."
        return None

    def calc_DTW(i, j):
        if i == 0 and j == 0:
            return 0
        elif i == 0 or j == 0:
            return 100000
        elif (i, j) in memo.keys():
            return memo[(i, j)]
        else:
            score = abs(a[i] - b[j]) + min(calc_DTW(i-1, j), calc_DTW(i, j-1), calc_DTW(i-1, j-1))
            memo[(i,j)] = score
            return score


    return calc_DTW(len(a)-1, len(b)-1)


# Test of DTW scoring

print "Length 100, different value"
print DTW_score([1]*100, [0]*100)

print "Same list"
print DTW_score([1]*100, [1]*100)


# TODO: get a test running with actual audio recording? (maybe not necessary)



CHUNK = 1024

# Get 1024 samples of audio data (about 23 ms)
def get_wav_data(filename):
    result = ''
    wf = wave.open(filename, 'rb')
    data = wf.readframes(CHUNK)
    while data != '':
        result += data
        data = wf.readframes(CHUNK)
    N = len(result) / 4
    return numpy.fromstring(result, dtype=numpy.int16).astype(float) / 32768.0
