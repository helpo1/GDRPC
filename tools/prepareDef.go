package main

import (
	"fmt"
	"os"
	"regexp"

	"github.com/Szmyk/go-utils/files"
)

func main() {
	lines := files.ReadLines("output/vdfs32g.def")
	clArg := os.Args[1]

	for i := range lines {

		if clArg == "expdef" || clArg == "pexports" {
			var re = regexp.MustCompile(`([\w]*)\s*@(\d*)`)
			lines[i] = re.ReplaceAllString(lines[i], `$1=OrgVdfs32g.$1  @$2`)

		} else if clArg == "gendef" {
			// remember to add ordinals manually
			// format: "f_name=OrgVdfs32g.f_name  @f_ordinal"
			var re = regexp.MustCompile(`(vdf_[\w]*)`)
			lines[i] = re.ReplaceAllString(lines[i], `$1=OrgVdfs32g.$1`)

		} else {
			fmt.Print("Unrecognized DLL function exports generator, no changes made.\n")
			return

		}

	}

	files.WriteLines(lines, "output/vdfs32g.def")
}
