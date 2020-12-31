extends Node

var samples = [	
	{ 'label': 'Bass', 'resource': 'res://samples/bass_m.01.L.wav', 'loop': { 'begin': 134456, 'end': 139600 }},
	{ 'label': 'Bell', 'resource': 'res://samples/bell.01.L.wav', 'loop': { 'begin': 59088, 'end': 75776 }}, 
	{ 'label': 'Ebow Guitar', 'resource': 'res://samples/ebow_m.01.L.wav', 'loop': { 'begin': 39520, 'end': 52832 } },
	{ 'label': 'Flute', 'resource': 'res://samples/flute_m.01.L.wav', 'loop': { 'begin': 68458, 'end': 68656 } },
	{ 'label': 'Harp', 'resource': 'res://samples/harp_m.01.L.wav', 'loop': { 'begin': 40740, 'end': 55176 } },
	{ 'label': 'Synth Lead', 'resource': 'res://samples/synth_lead_m.01.L.wav', 'loop': { 'begin': 60418, 'end': 60820 } },
	{ 'label': 'Synth Pad', 'resource': 'res://samples/synth_pad_m.01.L.wav', 'loop': { 'begin': 18378, 'end': 98613 } },
	{ 'label': 'Vibes', 'resource': 'res://samples/vibes_m.01.L.wav', 'loop': { 'begin': 58401, 'end': 59402 } },
]

var settings = {
	'OQ_LeftController': {
		'sample': samples[2],
		'looping': false,
		'notes': []
	},
	'OQ_RightController': {
		'sample': samples[1],
		'looping': false,
		'notes': []
	}
}
