# Digi Parse

I really wanted to get some data from a web page, but it was all in tables, and not easily copy-able, so I decided to write a script to parse the html from the webpage ([`source.html`](../source.html)) and convert it into a CSV that I could load into a database. How exactly I'll use that data is TBD...

## About the Data

This data is from an old video game called Digimon Digital Card Battle. It was a digital collectible card game for the original Playstation. I used to rent that game from Movie Gallery when I was a kid, and bought it for myself sometime later. I'm not sure where my original copy of that game is, but I always thought the core mechanics of it would make a good table top game, so I thought I'd get the data from the actual cards I used in the game all those years ago, and try to turn it into a physical card game! I do not own the names of the cards, so I don't know if there are any copyrights on them.

## Running the Project

This project comes with Prettier b/c I used it to format the original source file which is not included in this project. You shouldn't need to use it, but if you want to try it out, run:

```
yarn install
yarn prettier
```

To get the final CSV, you will need Ruby on your local machine (I developed this using ruby 2.5.3). Once you have Ruby installed, run:

```
ruby run.rb
```

Check the `dist` directory for `cards.csv`. Voila!
