package main

// #include <stdlib.h>
import "C"

import (
	"bytes"
	"unsafe"

	"github.com/alecthomas/chroma/v2/formatters"
	chromahtml "github.com/alecthomas/chroma/v2/formatters/html"
	"github.com/alecthomas/chroma/v2/styles"
	treeblood "github.com/wyatt915/goldmark-treeblood"
	"github.com/yuin/goldmark"
	emoji "github.com/yuin/goldmark-emoji"
	highlighting "github.com/yuin/goldmark-highlighting/v2"
	"github.com/yuin/goldmark/extension"
	"github.com/yuin/goldmark/renderer/html"
	callout "gitlab.com/staticnoise/goldmark-callout"
)

func main() {}

//export md_to_html
func md_to_html(input *C.char) *C.char {
	if input == nil {
		return C.CString("")
	}

	inp := C.GoString(input)
	md := goldmark.New(
		goldmark.WithExtensions(
			extension.GFM,
			highlighting.NewHighlighting(
				highlighting.WithFormatOptions(
					chromahtml.Standalone(false),
					chromahtml.WithClasses(true),
				),
			),
			extension.NewFootnote(
				extension.WithFootnoteIDPrefix([]byte("footnote")),
			),
			extension.Linkify,
			treeblood.MathML(),
			callout.CalloutExtention,
			emoji.Emoji,
		),
		goldmark.WithRendererOptions(html.WithUnsafe()),
	)

	var buf bytes.Buffer
	if err := md.Convert([]byte(inp), &buf); err != nil {
		return C.CString("")
	}

	return C.CString(buf.String())
}

//export chroma_css
func chroma_css(theme *C.char) *C.char {
	if theme == nil {
		return C.CString("")
	}
	thm := C.GoString(theme)

	var buf bytes.Buffer
	formatter := formatters.Get("html").(*chromahtml.Formatter)
	if err := formatter.WriteCSS(&buf, styles.Get(thm)); err != nil {
		return C.CString("")
	}
	return C.CString(buf.String())
}

//export free_cstring
func free_cstring(s *C.char) {
	if s != nil {
		C.free(unsafe.Pointer(s))
	}
}
