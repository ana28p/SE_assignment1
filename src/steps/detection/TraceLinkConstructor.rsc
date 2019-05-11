module steps::detection::TraceLinkConstructor

import steps::detection::SimilarityCalculator;
import List;
import IO;
import util::Math;

alias TraceLink = rel[str,str];
alias AllTraceLinks = list[TraceLink];

AllTraceLinks constructLinks(SimilarityMatrix sm, TraceLink excl) =
	[constructMethod1(sm) - excl, constructMethod2(sm) - excl, constructMethod3(sm) - excl]; 
	// You can add more constructed trace-links to the list if wanted

TraceLink constructMethod1(SimilarityMatrix sm) {
	TraceLink result = {};
	for (<Hid, Lid, score> <- sm) {
		if (score > 0) {
			result += <Hid, Lid>;
		}
	}
	return result;
}

TraceLink constructMethod2(SimilarityMatrix sm) {
	TraceLink result = {};
	for (<Hid, Lid, score> <- sm) {
		if (score >= 0.25) {
			result += <Hid, Lid>;
		}
	}
	return result;
} 

TraceLink constructMethod3(SimilarityMatrix sm) {
	TraceLink result = {};
	for (Hid <- sm.highlevel) {
		real highLScore = 0.0;
		for (<id, Lid, score> <- sm, Hid == id) {
			highLScore = max(highLScore, score);
		}
		for (<id, Lid, score> <- sm, Hid == id) {
			if (score >= 0.67 * highLScore) {
				result += <Hid, Lid>;
			}
		}
	}
	return result;
}
