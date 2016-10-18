@address-color: #666;

#interpolation {
  [zoom >= 17] {
    line-color: #888;
    line-width: 1;
    line-dasharray: 2,4;
  }
}

#housenumbers {
  [zoom >= 17] {
    text-name: "[addr:housenumber]";
    text-placement: interior;
    text-min-distance: 1;
    text-wrap-width: 0;
    text-face-name: @book-fonts;
    text-fill: @address-color;
    text-size: 10;
    [zoom >= 20] {
        text-size: 11;
    }
  }
}

#housenames {
  [zoom >= 17] {
    text-name: "[addr:housename]";
    text-placement: interior;
    text-wrap-width: 20;
    text-face-name: @book-fonts;
    text-fill: @address-color;
    text-size: 10;
    [zoom >= 20] {
        text-size: 11;
    }
  }
}

#building-text {
  [zoom >= 14][way_pixels > 3000],
  [zoom=15][way_pixels > 750], [zoom=16][way_pixels > 187],
  [zoom >= 17] {
    text-name: "[name]";
    text-size: 11;
    text-fill: #444;
    text-face-name: @book-fonts;
    text-halo-radius: @standard-halo-radius;
    text-wrap-width: 20;
    text-halo-fill: rgba(255,255,255,0.5);
    text-placement: interior;
  }
}
