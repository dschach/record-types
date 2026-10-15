import x2odPrettierConfig from "@x2od/prettier-config" with { type: "json" };

/**
 * @see https://prettier.io/docs/configuration
 * @type {import("prettier").Config}
 */
const config = {
	...x2odPrettierConfig,
	overrides: [
		...x2odPrettierConfig.overrides,
		{
			files: "package.json",
			options: {
				printWidth: 100
			}
		},
		// Code blocks embedded in Markdown are formatted with the Markdown
		// file's options, not their own language's overrides, so Markdown
		// must use tabs for the Apex examples on the site to keep them (the
		// shared config formats Apex files with tabs but sets Markdown to
		// spaces). The Markdown text itself formats identically either way,
		// and embedded YAML stays space-indented because the YAML spec
		// forbids tabs.
		{
			files: "*.md",
			options: {
				useTabs: true
			}
		}
	]
};

export default config;
