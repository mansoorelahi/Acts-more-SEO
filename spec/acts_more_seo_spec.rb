# coding: utf-8
require 'spec_helper'

ROOT = File.expand_path(File.dirname(__FILE__))

class CoolElement < ActiveRecord::Base
    acts_more_seo
end

class CoolerElement < ActiveRecord::Base
    acts_more_seo :title
end

describe CoolElement do
  subject { CoolElement }

  context "when there is no name" do
    it "should return only id" do
      a = subject.create
      a.to_param.should eql(a.id)
    end
  end

  context "when there is no name" do
    it "should return nice url" do
      a = subject.create(:name => 'bla bla bla')
      a.to_param.should eql("#{a.id}-bla-bla-bla")
    end

    context "and there are some url-not-friendly letters" do
      it "should remove them and return nice url" do
        a = subject.create(:name => 'ą')
        a.to_param.should eql("#{a.id}-aa")
      end
    end
  end
end

describe CoolerElement do
  subject { CoolerElement }

  context "when there is no name" do
    it "should return only id" do
      a = subject.create
      a.to_param.should eql(a.id)
    end
  end

  context "when there is no name" do
    it "should return nice url" do
      a = subject.create(:title => 'bla bla bla')
      a.to_param.should eql("#{a.id}-bla-bla-bla")
    end

    context "and there are some url-not-friendly letters" do
      it "should remove them and return nice url" do
        a = subject.create(:title => 'ą')
        a.to_param.should eql("#{a.id}-aa")
      end
    end
  end
end
