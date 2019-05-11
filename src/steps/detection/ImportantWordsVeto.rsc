module steps::detection::ImportantWordsVeto

import analysis::text::stemming::Snowball;
import util::Math;
import steps::detection::RequirementsReader;
import steps::detection::TraceLinkConstructor;

import IO;
import String;
import List;

list[str] getImportantWords(int maxFrequency) {
	list[str] lines = split("\n",readFile(|project://SE_assignment1/data/English-Word-Frequency.txt|));
	list[str] words = [];
	for (str line <- lines, /^<word:[a-z]+>,<val:[0-9]+>$/ := trim(line)) {
		if (toInt(val) <= maxFrequency) {
			words += word;
		}
	}
	return words;
}

TraceLink getExcludedLinks(list[str] importantVocabulary, Requirement highlevel, Requirement lowlevel, real relativeMaxDifference) {
	TraceLink exclude = {};
	for (<Hid, Hwords> <- highlevel) {
		for (<Lid, Lwords> <- lowlevel) {
			int difference = 0;
			int total_occ = 0;
			list[str] unionWords = Hwords + Lwords;
			for (word <- importantVocabulary & unionWords) {
				if (!(word in Hwords <==> word in Lwords)) {
					difference += 1;
				} 
				if (word in Hwords || word in Lwords) {
					total_occ += 1;
				}
			}
			
			if (1.0 * difference >= total_occ * relativeMaxDifference) {
				exclude += <Hid, Lid>;
			}
		}
	}
	return exclude;
}