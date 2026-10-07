# DITA Bootstrap PDF

A plug-in for [DITA Open Toolkit][1] that adds PDF print output to the [DITA Bootstrap plug-ins][2].

- [Installing](#installing)
- [Using](#using)
- [Featured Bootstrap components](#featured-bootstrap-components)
- [Customizing](#customizing)
- [License](#license)

## Installing

Use the `dita` command to add this plug-in and its requirements to your DITA Open Toolkit installation:

```console
dita install dita-bootstrap.specialization
dita install dita-bootstrap.pdf
```

## Using

Specify the `pdf` format when building output with the `dita` command. If the plug-in is installed, the Bootstrap-based
XSL-FO overrides will be applied automatically.

```console
dita --input=path/to/your.ditamap \
     --format=pdf
```

## Featured Bootstrap components

The plug-in includes XSL-FO handling for the following DITA Bootstrap components. You can use these through the
**DITA Bootstrap Specialization** elements to achieve a consistent look in print:

- [Accordions](https://dita-bootstrap.org/pdf/accordion.html) (`<accordion>`)
- [Alerts](https://dita-bootstrap.org/pdf/alerts.html) (`<alert>`)
- [Badges](https://dita-bootstrap.org/pdf/badge.html) (`<badge>`)
- [Buttons](https://dita-bootstrap.org/pdf/buttons.html) (`<button>`)
- [Cards](https://dita-bootstrap.org/pdf/card.html) (`<card>`)
- [Carousels](https://dita-bootstrap.org/pdf/carousel.html) (`<carousel>` as a contact sheet)
- [Figures](https://dita-bootstrap.org/pdf/figures.html) (`<fig>`)
- [Grid layout](https://dita-bootstrap.org/pdf/grid.html) (`<grid-row>`, `<grid-col>`)
- [Icons](https://dita-bootstrap.org/pdf/icons.html) (`<icon>`)
- [List groups](https://dita-bootstrap.org/pdf/list-group.html) (`<list-group>`)
- [Notes](https://dita-bootstrap.org/pdf/alerts.html) (`<note>` - as `<alert>`)
- [Tables](https://dita-bootstrap.org/pdf/tables.html) (`<table>`)
- [Thumbnails](https://dita-bootstrap.org/pdf/images.html) (`<thumbnail>`)

## Using Bootstrap Specializations

The preferred way to use this plug-in is via the [DITA Bootstrap domain specializations][2]. These provide native DITA elements
with specialized attributes for Bootstrap styling:

```xml
<card color="primary" border="1" rounded="yes">
  <title>Card Title</title>
  <p>Card content goes here.</p>
</card>
```

The print plug-in interprets these specialized elements and attributes to generate equivalent XSL-FO styling in the PDF output.

### Colors and Borders

Most DITA Bootstrap Specializations, as well as many base DITA elements, support the `color` and `border` attributes to control their appearance:

- **Color Themes**: Use standard Bootstrap themes such as `primary`, `secondary`, `success`, `danger`, `warning`, `info`, `light`, and `dark`.

  ```xml
  <section color="primary">
    <title>Primary Section</title>
    <p>This section has a primary background color.</p>
  </section>

  <alert color="warning">
    <p>This is a warning alert.</p>
  </alert>
  <badge color="success">New</badge>
  ```

- **Border Thickness**: Use numeric values from `1` to `5` to control border width.

  ```xml
  <ph border="1">Bordered phrase</ph>

  <card border="3" color="info">
    <title>Thick Border Card</title>
    <p>Content...</p>
  </card>
  ```

- **@color**: Sets the border and background theme (e.g., `primary` uses a solid primary border and a subtle primary background).

```xml
<thumbnail href="image.png" color="primary"/>
```

## Customizing

### Common Bootstrap utility classes

The common Bootstrap utility classes for borders, background, text, and spacing can also be used via the `outputclass`
attribute in DITA topics. The print plug-in interprets these classes and applies corresponding XSL-FO styling.

For more information on the available classes, see the [main DITA Bootstrap documentation][2].

## License

[Apache 2.0](LICENSE) © 2026 Jason Fox

> [!NOTE]
> Within the sample documentation, where necessary, the texts describing the usage of each component have been copied
> directly from the official [Bootstrap 5.3 documentation][2], however DITA markup is used throughout the examples describing
> how to implement these components correctly using `outputclass`. The text is therefore a derivative of "Bootstrap 5.3 docs"
> by Twitter, Inc. and the Bootstrap Authors, and used under CC BY 3.0.

[1]: http://www.dita-ot.org
[2]: https://dita-bootstrap.org
