# Merch Product Picture

WTF is this? you might ask. Well, it's a simple **rack** app tranforming you designs in branded merch images. Pillows, t-shirts, posters, canvases, all kinds of products!

On top of that is caches those rendered images for further call, a worker delete the old and unused ones.

It also has a Docker file for easy deployment to your IaaS of choice.

## Getting started

```bash
# Have ruby and bundler installed
$ bundle install
$ bundle exec rackup
```

Done! Now try this url out: [http://localhost:9292/?type=pillow&url=http://fansluart.s3-website-us-west-2.amazonaws.com/images/artworks/large/3jvorhenxn_1414094141.jpg](http://localhost:9292/?type=pillow&url=http://fansluart.s3-website-us-west-2.amazonaws.com/images/artworks/large/3jvorhenxn_1414094141.jpg)
