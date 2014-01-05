# Pearson [![Build Status](https://secure.travis-ci.org/alfonsojimenez/pearson.png)](http://travis-ci.org/alfonsojimenez/pearson)

Pearson correlation coefficient calculator

![Pearson](http://davidmlane.com/hyperstat/pictures/pearson6.GIF)

## Installation

You can install the ```pearson``` gem with rubygems:

```
gem install pearson
```

If you are using Bundler, you can include it into the Gemfile:

```
gem 'pearson', '~> 1.0'
```

## Usage

```ruby
scores = {
  'Jack' => {
    'The Godfather' => 2.5,
    'Gattaca' => 3.5,
    'Matrix' => 3.0,
    'American History X' => 3.5,
    'Back to the future' => 2.5
  },
  'Lisa' => {
    'The Godfather' => 1.5,
    'Gattaca' => 2.5,
    'Matrix' => 1.5,
    'Back to the future' => 5.0
  },
  'Tom' => {
    'The Godfather' => 3.5,
    'Gattaca' => 3.0,
    'American History X' => 1.5,
    'Back to the future' => 5.0
  },
  'Sarah' => {
    'The Godfather' => 3.0,
    'Gattaca' => 3.5,
    'Matrix' => 1.5,
    'American History X' => 5.0,
    'Back to the future' => 1.0
  },
  'Mike' => {
    'The Godfather' => 3.0,
    'Back to the future' => 4.0
  }
}
```

### Example 1

Calculate the pearson correlation coefficient between two entities:

```ruby
Pearson.coefficient(scores, 'Sarah', 'Lisa')
#=> -0.5297608986976613
```

### Example 2 

Calculate the closest entity from a given entity:

```ruby
Pearson.closest_entities(scores, 'Jack', limit: 1)
#=> [['Sarah', 0.7010740719559754]]
```

### Example 3 

Calculate the best recommendations for an entity. These recommendations are based on the pearson correlation coefficient. The results are sorted by item ranking:

```ruby
Pearson.recommendations(scores, 'Mike')
#=> [["Gattaca", 2.75], ["American History X", 1.5], ["Matrix", 1.5]]
```
