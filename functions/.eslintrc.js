module.exports = {
    root: true,
    env: {
        es6: true,
        node: true
    },
    extends: [
        "eslint:recommended",
        "plugin:import/errors",
        "plugin:import/warnings",
        "plugin:import/typescript",
        "plugin:@typescript-eslint/recommended",
        "google"
    ],
    parser: "@typescript-eslint/parser",
    parserOptions: {
        project: [
            "tsconfig.json",
            "tsconfig.dev.json"
        ],
        sourceType: "module"
    },
    ignorePatterns: [
        "/lib/**/*"
    ],
    plugins: [
        "@typescript-eslint",
        "import"
    ],
    rules: {
        "quotes": ["error", "double"],
        "linebreak-style": 0,
        "indent": ["error", 4, {
            "MemberExpression": 2
        }],
        "max-len": ["error", {
            "code": 500
        }],
        "comma-dangle": ["error", {
            "arrays": "never",
            "objects": "never",
            "imports": "never",
            "exports": "never",
            "functions": "never"
        }],
        "import/no-unresolved": 0,
        "@typescript-eslint/no-var-requires": 0,
        "@typescript-eslint/no-explicit-any": 0
    }
};
