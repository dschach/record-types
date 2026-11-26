import x2odPrettierConfig from '@x2od/prettier-config' with { type: 'json' };

/**
 * @see https://prettier.io/docs/configuration
 * @type {import("prettier").Config}
 */
const config = {
	...x2odPrettierConfig,
	overrides: [
		...x2odPrettierConfig.overrides,
		// Salesforce-specific files in this project
		{
			files: [
				'*-meta.xml',
				'manifest/*.xml',
				'manifest*.xml',
				'package*.xml',
				'destructiveChanges*.xml'
			],
			options: {
				parser: 'xml',
				embeddedLanguageFormatting: 'off',
				printWidth: 180,
				singleQuote: false,
				tabWidth: 4,
				useTabs: false,
				xmlSelfClosingSpace: false,
				xmlWhitespaceSensitivity: 'preserve'
			}
		}
	]
};

export default config;
