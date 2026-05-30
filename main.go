package main

import (
	"bytes"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"strings"
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
	fmt.Println("copying static/ to", outputDir)
	_ = os.CopyFS(outputDir, os.DirFS("static"))

	_ = writeFile(".nojekyll", "")
	_ = writeFile("CNAME", cname)

	_ = writeStyles("style.css")
	_ = writeTemplate("index.html", "index.html", nil)
	_ = writeTemplate("404.html", "404.html", nil)

	_ = writeGopkg("json2go", "https://github.com/olexsmir/json2go")
	_ = writeGopkg("clerk", "https://git.olexsmir.xyz/clerk")
	_ = writeGopkg("mugit", "https://git.olexsmir.xyz/mugit")
	_ = writeGopkg("x", "https://github.com/olexsmir/x")
	_ = writeGopkg("x/ratelimit", "https://github.com/olexsmir/x")

	fmt.Println("site generated")
}

func writeFile(dst, content string) error {
	full := filepath.Join(outputDir, dst)
	if err := os.MkdirAll(filepath.Dir(full), 0755); err != nil {
		return err
	}
	fmt.Println("writing:", dst)
	return os.WriteFile(full, []byte(content), 0711)
}

func writeGopkg(pkg, repoURL string) error {
	return writeTemplate("gopkg.html", pkg+".html", map[string]any{
		"Gomod":   cname + "/" + pkg,
		"RepoUrl": repoURL,
		"Branch":  "main",
	})
}

func writeTemplate(name, output string, data map[string]any) error {
	tmpl, err := template.ParseFiles(name)
	if err != nil {
		return err
	}
	var buf bytes.Buffer
	if err = tmpl.Execute(&buf, data); err != nil {
		return err
	}
	out := minifyWebFile(buf.String())
	return writeFile(output, out)
}

func writeStyles(file string) error {
	in, err := os.ReadFile(file)
	if err != nil {
		return nil
	}
	out := minifyWebFile(string(in))
	return writeFile(file, out)
}

func minifyWebFile(cnt string) string {
	return strings.NewReplacer("    ", "", "  ", "", "\t", "", "\n", "").Replace(cnt)
}
