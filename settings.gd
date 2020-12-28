extends Node

var samples = [	
	{ 'label': 'Bass', 'resource': 'res://samples/bass.wav', 'loop': { 'begin': 111808, 'end': 130944 }},
	{ 'label': 'Bell', 'resource': 'res://samples/bell.wav', 'loop': { 'begin': 56688, 'end': 74912 }}, 
	{ 'label': 'Ebow Guitar', 'resource': 'res://samples/ebow.wav', 'loop': { 'begin': 39520, 'end': 52832 } },
	{ 'label': 'Flute', 'resource': 'res://samples/flute.wav', 'loop': { 'begin': 9392, 'end': 21632 } },
	{ 'label': 'Harp', 'resource': 'res://samples/harp.wav', 'loop': { 'begin': 40740, 'end': 55176 } },
	{ 'label': 'Synth Lead', 'resource': 'res://samples/synth_lead.wav', 'loop': { 'begin': 100016, 'end': 100816 } },
	{ 'label': 'Synth Pad', 'resource': 'res://samples/synth_pad.wav', 'loop': { 'begin': 146302, 'end': 162048 } },
	{ 'label': 'Vibes', 'resource': 'res://samples/vibes.wav', 'loop': { 'begin': 71392, 'end': 84192 } },
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
