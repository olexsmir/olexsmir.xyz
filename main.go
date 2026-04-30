package main

import (
	"bytes"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
)

// note: as for posts; i will write them in html, which would be easier for
// interactive stuff, and wont require any markdown converter

const (
	cname     = "olexsmir.xyz"
	outputDir = "_site"
)

func main() {
	_ = os.RemoveAll(outputDir)
	_ = os.Mkdir(outputDir, 0711)
	_ = os.CopyFS(outputDir, os.DirFS("static"))

	_ = writeFile(".nojekyll", "")
	_ = writeFile("CNAME", cname)

	_ = writeTemplate("index.html", "index.html", nil)
	_ = writeTemplate("404.html", "404.html", nil)

	_ = writeGopkg("json2go", "https://github.com/olexsmir/json2go")
	_ = writeGopkg("mugit", "https://git.olexsmir.xyz/mugit")
	_ = writeGopkg("x", "https://github.com/olexsmir/x")

	fmt.Println("site generated")
}

func writeFile(dst, content string) error {
	return os.WriteFile(filepath.Join(outputDir, dst), []byte(content), 0711)
}

func writeGopkg(pkg, repoUrl string) error {
	return writeTemplate("gopkg.html", pkg+".html", map[string]any{
		"Gomod":   cname + "/" + pkg,
		"RepoUrl": repoUrl,
	})
}

func writeTemplate(name, output string, data map[string]any) error {
	tmpl, err := template.ParseFiles(name)
	if err != nil {
		return err
	}
	var buf bytes.Buffer
	err = tmpl.Execute(&buf, data)
	return writeFile(output, buf.String())
}
