package main

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	sysdrive, exists := os.LookupEnv("SYSTEMDRIVE")
	if exists {
		sysdrive = fmt.Sprintf("%s\\", sysdrive)
		files := []string{}
		filepath.WalkDir(sysdrive, func(path string, d fs.DirEntry, err error) error {
			suffixes := []string{
				"WindowsUpdate.log", "nmh-transport.log", ".tmp", ".dmp"}
			var ok bool = false
			for _, s := range suffixes {
				if strings.HasSuffix(path, s) {
					ok = true
				}
			}
			if ok {
				info, err := d.Info()
				if err == nil {
					if !info.IsDir() && info.Mode().IsRegular() {
						files = append(files, path)
					}
				}
			}
			return nil
		})
		for _, f := range files {
			os.Remove(f)
		}
	}
}
