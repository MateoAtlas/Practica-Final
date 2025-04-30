# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

```
Final Project
├─ .forceignore
├─ .husky
│  └─ pre-commit
├─ .prettierignore
├─ .prettierrc
├─ config
│  └─ project-scratch-def.json
├─ force-app
│  └─ main
│     └─ default
│        ├─ applications
│        ├─ aura
│        │  └─ .eslintrc.json
│        ├─ classes
│        │  ├─ BuscadorController.cls
│        │  ├─ BuscadorController.cls-meta.xml
│        │  ├─ CountdownController.cls
│        │  ├─ CountdownController.cls-meta.xml
│        │  ├─ HelloWorldController.cls
│        │  ├─ HelloWorldController.cls-meta.xml
│        │  ├─ ListaController.cls
│        │  ├─ ListaController.cls-meta.xml
│        │  ├─ makePaymentController.cls
│        │  ├─ makePaymentController.cls-meta.xml
│        │  ├─ opportunityPdfController.cls
│        │  ├─ opportunityPdfController.cls-meta.xml
│        │  ├─ pdfController.cls
│        │  ├─ pdfController.cls-meta.xml
│        │  ├─ setLinkOpportunity.cls
│        │  └─ setLinkOpportunity.cls-meta.xml
│        ├─ contentassets
│        ├─ flexipages
│        ├─ flows
│        ├─ layouts
│        ├─ lwc
│        │  ├─ .eslintrc.json
│        │  ├─ buscador
│        │  │  ├─ buscador.css
│        │  │  ├─ buscador.html
│        │  │  ├─ buscador.js
│        │  │  ├─ buscador.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ buscador.test.js
│        │  ├─ countdown
│        │  │  ├─ countdown.html
│        │  │  ├─ countdown.js
│        │  │  ├─ countdown.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ countdown.test.js
│        │  ├─ createOpportunityPdf
│        │  │  ├─ createOpportunityPdf.html
│        │  │  ├─ createOpportunityPdf.js
│        │  │  ├─ createOpportunityPdf.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ createOpportunityPdf.test.js
│        │  ├─ listaDeTerminos
│        │  │  ├─ listaDeTerminos.css
│        │  │  ├─ listaDeTerminos.html
│        │  │  ├─ listaDeTerminos.js
│        │  │  ├─ listaDeTerminos.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ listaDeTerminos.test.js
│        │  ├─ pubsub
│        │  │  ├─ pubsub.html
│        │  │  ├─ pubsub.js
│        │  │  ├─ pubsub.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ pubsub.test.js
│        │  ├─ sendPdfOpportunity
│        │  │  ├─ sendPdfOpportunity.css
│        │  │  ├─ sendPdfOpportunity.html
│        │  │  ├─ sendPdfOpportunity.js
│        │  │  ├─ sendPdfOpportunity.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ sendPdfOpportunity.test.js
│        │  └─ testingAccountPdf
│        │     ├─ testingAccountPdf.html
│        │     ├─ testingAccountPdf.js
│        │     ├─ testingAccountPdf.js-meta.xml
│        │     └─ __tests__
│        │        └─ testingAccountPdf.test.js
│        ├─ objects
│        ├─ pages
│        │  ├─ createPdf.page
│        │  ├─ createPdf.page-meta.xml
│        │  ├─ opportunityPdfPage.page
│        │  ├─ opportunityPdfPage.page-meta.xml
│        │  ├─ Payment.page
│        │  ├─ Payment.page-meta.xml
│        │  ├─ testCommunity.page
│        │  ├─ testCommunity.page-meta.xml
│        │  ├─ testPdf.page
│        │  └─ testPdf.page-meta.xml
│        ├─ permissionsets
│        ├─ staticresources
│        ├─ tabs
│        └─ triggers
├─ jest.config.js
├─ package.json
├─ README.md
├─ scripts
│  ├─ apex
│  │  └─ hello.apex
│  └─ soql
│     └─ account.soql
└─ sfdx-project.json

```
```
Final Project
├─ .forceignore
├─ .husky
│  └─ pre-commit
├─ .prettierignore
├─ .prettierrc
├─ config
│  └─ project-scratch-def.json
├─ force-app
│  └─ main
│     └─ default
│        ├─ applications
│        ├─ aura
│        │  └─ .eslintrc.json
│        ├─ classes
│        │  ├─ BuscadorController.cls
│        │  ├─ BuscadorController.cls-meta.xml
│        │  ├─ CountdownController.cls
│        │  ├─ CountdownController.cls-meta.xml
│        │  ├─ HelloWorldController.cls
│        │  ├─ HelloWorldController.cls-meta.xml
│        │  ├─ ListaController.cls
│        │  ├─ ListaController.cls-meta.xml
│        │  ├─ makePaymentController.cls
│        │  ├─ makePaymentController.cls-meta.xml
│        │  ├─ opportunityPdfController.cls
│        │  ├─ opportunityPdfController.cls-meta.xml
│        │  ├─ pdfController.cls
│        │  ├─ pdfController.cls-meta.xml
│        │  ├─ setLinkOpportunity.cls
│        │  └─ setLinkOpportunity.cls-meta.xml
│        ├─ contentassets
│        ├─ flexipages
│        ├─ flows
│        ├─ layouts
│        ├─ lwc
│        │  ├─ .eslintrc.json
│        │  ├─ buscador
│        │  │  ├─ buscador.css
│        │  │  ├─ buscador.html
│        │  │  ├─ buscador.js
│        │  │  ├─ buscador.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ buscador.test.js
│        │  ├─ countdown
│        │  │  ├─ countdown.html
│        │  │  ├─ countdown.js
│        │  │  ├─ countdown.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ countdown.test.js
│        │  ├─ createOpportunityPdf
│        │  │  ├─ createOpportunityPdf.html
│        │  │  ├─ createOpportunityPdf.js
│        │  │  ├─ createOpportunityPdf.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ createOpportunityPdf.test.js
│        │  ├─ listaDeTerminos
│        │  │  ├─ listaDeTerminos.css
│        │  │  ├─ listaDeTerminos.html
│        │  │  ├─ listaDeTerminos.js
│        │  │  ├─ listaDeTerminos.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ listaDeTerminos.test.js
│        │  ├─ pubsub
│        │  │  ├─ pubsub.html
│        │  │  ├─ pubsub.js
│        │  │  ├─ pubsub.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ pubsub.test.js
│        │  ├─ sendPdfOpportunity
│        │  │  ├─ sendPdfOpportunity.css
│        │  │  ├─ sendPdfOpportunity.html
│        │  │  ├─ sendPdfOpportunity.js
│        │  │  ├─ sendPdfOpportunity.js-meta.xml
│        │  │  └─ __tests__
│        │  │     └─ sendPdfOpportunity.test.js
│        │  └─ testingAccountPdf
│        │     ├─ testingAccountPdf.html
│        │     ├─ testingAccountPdf.js
│        │     ├─ testingAccountPdf.js-meta.xml
│        │     └─ __tests__
│        │        └─ testingAccountPdf.test.js
│        ├─ objects
│        ├─ pages
│        │  ├─ createPdf.page
│        │  ├─ createPdf.page-meta.xml
│        │  ├─ opportunityPdfPage.page
│        │  ├─ opportunityPdfPage.page-meta.xml
│        │  ├─ Payment.page
│        │  ├─ Payment.page-meta.xml
│        │  ├─ testCommunity.page
│        │  ├─ testCommunity.page-meta.xml
│        │  ├─ testPdf.page
│        │  └─ testPdf.page-meta.xml
│        ├─ permissionsets
│        ├─ staticresources
│        ├─ tabs
│        └─ triggers
├─ jest.config.js
├─ package.json
├─ README.md
├─ scripts
│  ├─ apex
│  │  └─ hello.apex
│  └─ soql
│     └─ account.soql
└─ sfdx-project.json

```