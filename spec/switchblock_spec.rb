require 'spec_helper'

describe Switchblock do
  include Switchblock

  it 'has a version number' do
    expect(Switchblock::VERSION).not_to be nil
  end

  def switch_helper(name, *args)
    yield it_to name, *args
  end

  let(:yes_no_block) {
    lambda do |s|
      s.success {'yes'}
      s.failure {'no'}
    end
  }

  let(:ensured_block) {
    lambda do |s|
      s.success {'yes'}
      s.failure {'no'}
      s.ensure
      end
  }

  let(:block_with_default) {
    lambda do |s|
      s.success {'yes'}
      s.failure {'no'}
      s.always {'ok'}
    end
  }

  let(:block_with_else) {
    lambda do |s|
      s.success {'yes'}
      s.failure {'no'}
      s.else {'maybe'}
    end
  }

  it 'should be able to switch between codeblocks' do

    res = switch_helper('success', &yes_no_block)
    expect(res).to eql('yes')

    res = switch_helper('failure', &yes_no_block)
    expect(res).to eql('no')
  end

  it 'should return nil if no codeblock is run' do
    res = switch_helper('N/A', &yes_no_block)
    expect(res).to be_nil
  end

  it 'should also take procs as subblocks' do

    procblock = lambda{'procblock'}

    res = switch_helper('procblock') do |s|
      s.procblock procblock
    end

    expect(res).to eql('procblock')
  end

  it 'should execute "always" switches' do
    res = switch_helper('N/A', &block_with_default)
    expect(res).to eql('ok')
  end

  it 'should return the last evaluated subblock' do
    res = switch_helper('success', &block_with_default)
    expect(res).to eql('ok')
  end

  it 'should raise an error if ensure is used and no code has run' do
    expect{ switch_helper('suxess', &ensured_block)}.to raise_error
  end

  it 'should not raise an error if ensure is used and code has run' do
    expect{ switch_helper('success', &ensured_block)}.to_not raise_error
  end

  it 'should execute else blocks if nothing else has run' do
    res = switch_helper('N/A', &block_with_else)
    expect(res).to eql('maybe')
  end

  it 'should not execute else blocks if something else has run' do
    res = switch_helper('failure', &block_with_else)
    expect(res).to eql('no')
  end

end
