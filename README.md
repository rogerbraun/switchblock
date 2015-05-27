# Switchblock - A way to pass multiple blocks to a method

Switchblock is a module mixin that adds a simple way to pass multiple blocks to methods to your classes. It does this by creating an object that acts as a switch block.

## Usage

First, you must ```include Switchblock``` in your class (or your program). You can now write methods that take multiple blocks using the "it_to" method like this:

```ruby
def did_we_succeed?(success)
  if success
    yield it_to "success"
  else
    yield it_to "failure"
  end
end

did_we_succeed?(true) do |s|
  s.success {"Yes!!"}
  s.failure {"Aw... Bummer..."}
end

=> "Yes!!"
```

The call to it_to will give you BlockSwitcher, which will take care of the block you give to the method and execute just the subblock(s) you want.

## Features

As seen in the usage example, you can pass an unlimited number of subblocks to your BlockSwitcher. These will be executed if the method you call on the BlockSwitcher matches whatever name you specified in the "yield it_to" call.

### Switches

Switches are really simple, just make up a name and use it to call one your subblocks by yielding to it in your "yield it_to" call. The first argument to "it_to" is the name of the block you want to call. You can use anything that has a #to_sym method.

```ruby
def yield_name(name)
  yield it_to name
end

yield_name("Larry") do |s|
  s.larry {"Hi, Larry!}
end

=> "Hi, Larry!"
```

Instead of blocks, you can also use a proc as the argument to a switch.

```ruby
larry_greeter = lambda {"Hi, Larry"}

yield_name("Larry") do |s|
  s.larry larry_greeter
end

=> "Hi, Larry!"
```

Any additional arguments you yield after the switch name will be passed on to your subblock.

```ruby
def even_or_odd(x)
  if x.even?
    yield it_to "even", x
  else
    yield it_to "odd", x
  end
end

even_or_odd(5) do |s|
  s.even {|x| "#{x} is an even number" }
  s.odd {|x| "#{x} is an odd number" }
end

=> "5 is an odd number"
```

The return value of your "yield it_to" call will be the return value of the last executed subblock. If nothing at all is executed, the whole block will return nil. It will raise an error if you use "ensure" (see below).

### Special Switches
You can use any name for your switch, but "else", "always" and "ensure" have a special meaning and are treated differently.

#### always

You can use "always" as often as you wish, just as normal switches, and it will always execute no matter what.

#### else

You should use "else" only as the last switch of your switchblock. The block you give to it will only execute if no previous block executed before. You can use this to implement default behaviour.

#### ensure
You should use "ensure" only as as the last switch of your switchblock. It will ignore all passed blocks and arguments. It makes sure that at least one of your switches was called during execution and will raise a NothingExecutedError otherwise.

You can use this to protect against typos. For example, you mistype and write "yield it_to 'succes'" and you have no idea why the block passed to "s.success" in your switchblock is not executed. Using ensure will give you a nice error message in this case, telling you what should have been executed and what was actually present.

Needless to say, you should probably not use "ensure" together with "always" or "else". You can though, if you are really clever (or just feel like it).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'switchblock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install switchblock

## Contributing

1. Fork it ( https://github.com/[my-github-username]/switchblock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
