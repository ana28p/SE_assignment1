module steps::evaluation::ResultsCalculator

import steps::detection::RequirementsReader;
import steps::detection::TraceLinkConstructor;

import Set;
import util::Math;
import IO;

alias ConfusionMatrix = tuple[int truePositives, int falsePositives, int trueNegatives, int falseNegatives];
alias EvaluationResult = tuple[ConfusionMatrix cm, real precision, real recall, real fMeasure];

EvaluationResult evaluateMethod(TraceLink manual, TraceLink fromMethod, Requirement highlevel, Requirement lowlevel) {
	ConfusionMatrix cm = calculateConfusionMatrix(manual, fromMethod, highlevel, lowlevel);
	println("Here");
	real precision = calculatePrecision(cm);
	real recall = calculateRecall(cm);
	real fmeasure = calculateFMeasure(precision, recall);
	EvaluationResult res = <cm, precision, recall, fmeasure>;
	return res;
}

private real calculatePrecision(ConfusionMatrix cm) {
	return 1.0 * cm.truePositives / (cm.truePositives + cm.falsePositives);
}

private real calculateRecall(ConfusionMatrix cm) { 
	return 1.0 * cm.truePositives / (cm.truePositives + cm.falseNegatives);
}

private real calculateFMeasure(real precision, real recall) {
	return 2.0 * precision * recall / (precision + recall); 
}

private ConfusionMatrix calculateConfusionMatrix(TraceLink manual, TraceLink automatic, Requirement highlevel, Requirement lowlevel) {
	// TODO: Construct the confusion matrix.
	// True positives: Nr of trace-link predicted by the tool AND identified manually  
  	// False positives: Nr of trace-link predicted by the tool BUT NOT identified manually
  	// True negatives: Nr of trace-link NOT predicted by the tool AND NOT identified manually
  	// False negatives: Nr of trace-link NOT predicted by the tool BUT identified manually
	int tp = 0;
	int fp = 0;
	int tn = 0;
	int fn = 0;
	for (<lid, lwords> <- lowlevel) {
		for (<hid, hwords> <- highlevel) {
			if (<hid, lid> in manual) {
				if (<hid, lid> in automatic) {
					tp += 1;
				}
				else {
					fn += 1;
				}
			}
			else {
				if (<hid, lid> in automatic) {
					fp += 1;
				}
				else {
					tn += 1;
				}
			}
		}
	}
	ConfusionMatrix cm = <tp,fp,tn,fn>;
	return cm;
}