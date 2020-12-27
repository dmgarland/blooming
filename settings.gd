extends Node

var samples = [
	{ 'label': 'Ebow Guitar', 'resource': 'res://bowed.wav' }, 
	{ 'label': 'Bell', 'resource': 'res://bell.wav' }, 
	{ 'label': 'Bass', 'resource': 'res://bass.wav' }
]

var settings = {
	'OQ_LeftController': {
		'sample': samples[0].resource
	},
	'OQ_RightController': {
		'sample': samples[1].resource
	}
}
