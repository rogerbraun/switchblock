require "switchblock/version"
require "blankslate"

module Switchblock

  class NothingExecutedError < Exception; end

  class BlockSwitcher < BlankSlate

    def initialize(called_block, args)
      @called_block = called_block
      @args = args
      @ret = nil
      @called = false
      @callees = []
    end

    def ensure
      raise NothingExecutedError, "Nothing got executed! Expected one of #{@callees.inspect}, but only got #{@called_block}" if not @called
    end

    def method_missing(method,*args, &block)
      if (method.downcase == @called_block.to_sym.downcase or method == :always) or (@called == false and method == :else) then
        @called = true
        if args.size > 0 then
          @ret = args.first.call(*@args)
        else
          @ret = block.call(*@args)
        end
      end
      # For error reporting
      @callees << method
      @callees.uniq!
      # Always return something meaningful
      @ret
    end
  end

  private
  def it_to(x, *args)
    BlockSwitcher.new(x, args)
  end
end
