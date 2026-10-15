{
	"$schema": "https://json.schemastore.org/prettierrc.json",
	"apexInsertFinalNewline": false,
	"bracketSameLine": true,
	"bracketSpacing": true,
	"endOfLine": "lf",
	"experimentalTernaries": true,
	"printWidth": 180,
	"singleAttributePerLine": false,
	"singleQuote": true,
	"tabWidth": 2,
	"trailingComma": "none",
	"useTabs": true,
	"xmlSelfClosingSpace": true,
	"overrides": [
		{
			"files": "*.{cmp,component,page,app,auradoc,design,evt,intf,tokens}",
			"options": {
				"parser": "html",
				"attributeGroups": [
					"^id$",
					"^aura:id$",
					"^name$",
					"^src$",
					"^for$",
					"^type$",
					"^href$",
					"^value$",
					"^title$",
					"^alt$",
					"^role$",
					"$DEFAULT",
					"^html-",
					"$TYPE",
					"^access$",
					"^description$",
					"^class$",
					"^data-",
					"$ARIA",
					"^aria-",
					"^on"
				],
				"attributeIgnoreCase": true,
				"singleQuote": false,
				"useTabs": false
			}
		},
		{
			"files": "*.{cmp,page,component}",
			"options": { "htmlWhitespaceSensitivity": "css", "useTabs": true }
		},
		{
			"files": "*.{auradoc,design,evt,intf,tokens}",
			"options": { "htmlWhitespaceSensitivity": "ignore" }
		},
		{
			"files": "*.{cls,trigger}",
			"options": { "parser": "apex", "useTabs": true }
		},
		{ "files": "*.trigger", "options": { "printWidth": 200 } },
		{
			"files": "*.apex",
			"options": { "parser": "apex-anonymous", "useTabs": true }
		},
		{
			"files": "*.xml",
			"options": {
				"parser": "xml",
				"singleQuote": false,
				"useTabs": true,
				"xmlSelfClosingSpace": true,
				"xmlWhitespaceSensitivity": "preserve"
			}
		},
		{
			"files": [
				"*-meta.xml",
				"manifest/*.xml",
				"package.xml",
				"destructiveChanges*.xml"
			],
			"options": {
				"parser": "xml",
				"embeddedLanguageFormatting": "off",
				"tabWidth": 4,
				"useTabs": false,
				"xmlSelfClosingSpace": false,
				"xmlWhitespaceSensitivity": "strict"
			}
		},
		{
			"files": "*.{yml,yaml}",
			"options": {
				"parser": "yaml",
				"singleQuote": true,
				"tabWidth": 2,
				"useTabs": false
			}
		},
		{
			"files": [".prettier*", "*prettier*js"],
			"options": { "printWidth": 80, "singleQuote": false }
		},
		{ "files": "*.css", "options": { "useTabs": true } },
		{ "files": "*.md", "options": { "useTabs": false } },
		{
			"files": "*.json",
			"options": {
				"parser": "json",
				"printWidth": 80,
				"singleQuote": false,
				"useTabs": false
			}
		},
		{
			"files": "*.json5",
			"options": { "parser": "json5", "quoteProps": "consistent" }
		},
		{ "files": "package.json", "options": { "parser": "json-stringify" } },
		{
			"files": "doc*/**/*.html",
			"options": {
				"parser": "html",
				"attributeGroups": ["$CODE_GUIDE"],
				"htmlWhitespaceSensitivity": "css",
				"printWidth": 150,
				"singleQuote": false,
				"tabWidth": 2,
				"useTabs": true
			}
		},
		{
			"files": "**/lwc/**/*.html",
			"options": { "parser": "lwc", "printWidth": 120 }
		},
		{
			"files": "*.sh",
			"options": {
				"functionNextLine": false,
				"indent": 2,
				"keepComments": true,
				"spaceRedirects": true,
				"switchCaseIndent": true,
				"useTabs": false
			}
		}
	],
	"plugins": [
		"prettier-plugin-apex",
		"@prettier/plugin-xml",
		"prettier-plugin-organize-attributes",
		"prettier-plugin-pkg",
		"prettier-plugin-sh"
	]
}
