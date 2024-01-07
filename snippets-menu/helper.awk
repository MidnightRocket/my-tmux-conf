#!/usr/bin/awk -f
# https://stackoverflow.com/a/1418292
BEGIN {
	ORS=" "
}

function getQuotedField(fieldNum) {
	if ($fieldNum ~ /^[^"]/) return $fieldNum # if first field does no begin with ", then return just that field
	output = ""
	for (i = fieldNum; i <= NF; i++) {
		lastField = i
		output = output OFS $i
		if ($i ~ /[^\\]"$/) {
			break
		}
	}
	return substr(output, 2)
}

function getFieldRange(start, end) {
	output = ""
	for (i = start; i <= end; i++) {
		output = output OFS $i
	}
	return substr(output, 2) # remove extra space at the beginning
}

/^''/ {
	print "''"
	next # skip to next line: https://stackoverflow.com/a/8723046
}

NF > 0 && !/^[[:space:]]*#/ {
	print getQuotedField(1), $(++lastField), "{send-keys " getFieldRange(++lastField, NF) "}"
}
