## Adding Custom Fonts

To add custom fonts to your Linea installation:

1. **Create a fonts folder**: Create a new folder called `fonts` inside the `public` directory:
   ```
   public/fonts/
   ```

2. **Add font files**: Place your font files (e.g., .ttf, .woff, .woff2) into the `public/fonts` folder.

3. **Configure fonts in stylesheet**: In your modified stylesheet (e.g., `app/assets/stylesheets/application.css` or your custom CSS file), add @font-face declarations to import and use your custom fonts:
   ```css
   @font-face {
       font-family: 'CustomFontName';
       src: url('/fonts/custom-font.woff2') format('woff2'),
            url('/fonts/custom-font.woff') format('woff');
       font-weight: normal;
       font-style: normal;
   }
   
   body {
       font-family: 'CustomFontName', sans-serif;
   }
   ```

4. **Verify the configuration**: Test your fonts in the development environment by running `rails server` and checking that fonts load correctly in your browser.
