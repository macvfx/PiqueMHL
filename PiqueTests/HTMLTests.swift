import XCTest
@testable import Pique

final class HTMLTests: XCTestCase {

    // MARK: - escapeHTML

    func testEscapeHTMLScriptTag() {
        XCTAssertEqual(SyntaxHighlighter.escapeHTML("<script>"), "&lt;script&gt;")
    }

    func testEscapeHTMLAllSpecialChars() {
        XCTAssertEqual(
            SyntaxHighlighter.escapeHTML("<div class=\"test\">&value</div>"),
            "&lt;div class=&quot;test&quot;&gt;&amp;value&lt;/div&gt;"
        )
    }

    func testEscapeHTMLPlainText() {
        let plain = "Hello World 123"
        XCTAssertEqual(SyntaxHighlighter.escapeHTML(plain), plain)
    }

    func testEscapeHTMLEmptyString() {
        XCTAssertEqual(SyntaxHighlighter.escapeHTML(""), "")
    }

    // MARK: - inlineMarkdown

    func testInlineMarkdownBold() {
        XCTAssertEqual(SyntaxHighlighter.inlineMarkdown("**bold**"), "<strong>bold</strong>")
    }

    func testInlineMarkdownItalic() {
        XCTAssertEqual(SyntaxHighlighter.inlineMarkdown("*italic*"), "<em>italic</em>")
    }

    func testInlineMarkdownCode() {
        XCTAssertEqual(SyntaxHighlighter.inlineMarkdown("`code`"), "<code>code</code>")
    }

    func testInlineMarkdownLink() {
        let result = SyntaxHighlighter.inlineMarkdown("[text](https://example.com)")
        XCTAssertEqual(result, "<a href=\"https://example.com\">text</a>")
    }

    func testInlineMarkdownMixed() {
        XCTAssertEqual(
            SyntaxHighlighter.inlineMarkdown("**bold** and *italic* and `code`"),
            "<strong>bold</strong> and <em>italic</em> and <code>code</code>"
        )
    }

    func testInlineMarkdownPlainTextUnchanged() {
        let plain = "just plain text"
        XCTAssertEqual(SyntaxHighlighter.inlineMarkdown(plain), plain)
    }

    func testInlineMarkdownUnderscoreBold() {
        XCTAssertEqual(SyntaxHighlighter.inlineMarkdown("__bold__"), "<strong>bold</strong>")
    }

    func testInlineMarkdownUnderscoreItalic() {
        XCTAssertEqual(SyntaxHighlighter.inlineMarkdown("_italic_"), "<em>italic</em>")
    }

    func testRenderMediaHashListShowsSummary() {
        let source = """
        <?xml version="1.0" encoding="UTF-8"?>
        <hashlist version="1.1">
            <creatorinfo>
                <tool>OffShoot</tool>
                <startdate>2024-06-21T04:41:35Z</startdate>
                <finishdate>2024-06-21T04:48:53Z</finishdate>
            </creatorinfo>
            <hash>
                <file>XDROOT/Clip/903_3855.MXF</file>
                <size>2110586928</size>
                <lastmodificationdate>2024-06-20T19:18:03Z</lastmodificationdate>
                <xxhash64>3cc1da179799aea7</xxhash64>
                <hashdate>2024-06-21T04:41:50Z</hashdate>
            </hash>
        </hashlist>
        """

        let html = SyntaxHighlighter.highlight(source, format: .mhl)
        XCTAssertTrue(html.contains("MEDIA HASH LIST"))
        XCTAssertTrue(html.contains("XDROOT/Clip/903_3855.MXF"))
        XCTAssertTrue(html.contains("3cc1da179799aea7"))
        XCTAssertTrue(html.contains("1 file") || html.contains(">1<"))
    }
}
