# coding: utf-8
require 'spec_helper'

ROOT = File.expand_path(File.dirname(__FILE__))

class CoolElement < ActiveRecord::Base
    acts_more_seo
end

class CoolerElement < ActiveRecord::Base
    acts_more_seo :title
end

class SpecialElement < ActiveRecord::Base
    acts_more_seo :columns => [:name, :surname, :title]
end

class BestElement < ActiveRecord::Base
    acts_more_seo :columns => [:name, :surname, :title], :use_id => false
end

describe CoolElement do
  subject { CoolElement }

  context "when we have a class which has use_id => true" do
    it "should find element unless id is corrupted" do
      a = subject.create(:name => 'bla bla bla')
      subject.find(a.id).should eql(a)
      subject.find(a.to_param).should eql(a)
      subject.find("#{a.to_param}aaa").should eql(a)
      lambda { subject.find("134534dass") }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when there is no name" do
    it "should return only id" do
      a = subject.create
      a.to_param.should eql(a.id.to_s)
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
        a.to_param.should eql("#{a.id}-a")
      end
    end
  end
end

describe CoolerElement do
  subject { CoolerElement }

  context "when there is no name" do
    it "should return only id" do
      a = subject.create
      a.to_param.should eql(a.id.to_s)
    end

    it "should be able to find existing element" do
      a = subject.create
      subject.find(a.id).should eql(a)
    end

    it "should raise error when there is no element" do
      a = subject.create
     lambda { subject.find(a.id+1) }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when there is no name" do
    it "should return nice url" do
      a = subject.create(:title => 'bla bla bla')
      a.to_param.should eql("#{a.id}-bla-bla-bla")
      subject.find(a.to_param).should eql(a)
    end

    context "and there are some url-not-friendly letters" do
      it "should remove them and return nice url" do
        a = subject.create(:title => 'ą')
        a.to_param.should eql("#{a.id}-a")
      end
    end
  end
end

describe SpecialElement do
  subject { SpecialElement }

  context "when there is no name" do
    context "but surname and title exists" do
      it "should return nice looking url " do
        a = subject.create({:surname => 'mensfeld', :title => 'test abc'})
        a.to_param.should eql("#{a.id}-mensfeld-test-abc")
      end
    end

    context "and no other param" do
      it "should return only id" do
        a = subject.create()
        a.to_param.should eql("#{a.id}")
      end
    end
  end

  context "when there are all the params" do
    it "should return nice url" do
        a = subject.create({:name => 'maciej', :surname => 'mensfeld', :title => 'test abc'})
        a.to_param.should eql("#{a.id}-maciej-mensfeld-test-abc")
    end
  end
end


describe BestElement do
  subject { BestElement }

  context "when there is no surname" do
    context "but surname and title exists" do
      it "should return nice looking url " do
        a = subject.create({:name => 'mensfeld', :title => 'test abc'})
        a.to_param.should eql("mensfeld-test-abc")
        a.seo_url.should eql("mensfeld-test-abc")
      end
    end
  end

  context "when there is no name" do
    context "but surname and title exists" do
      it "should return nice looking url " do
        a = subject.create({:surname => 'mensfeld', :title => 'test abc'})
        a.to_param.should eql("mensfeld-test-abc")
        a.reload
        a.seo_url.should eql("mensfeld-test-abc")
      end
    end

    context "and no other param" do
      it "should return only id" do
        a = subject.create()
        a.to_param.should eql("#{a.id}")
        a.reload
        a.seo_url.should eql("#{a.id}")
      end
    end
  end

  context "when there are all the params" do
    it "should return nice url" do
        a = subject.create({:name => 'maciej', :surname => 'mensfeld', :title => 'test abc'})
        a.to_param.should eql("maciej-mensfeld-test-abc")
        a.reload
        a.seo_url.should eql("maciej-mensfeld-test-abc")
    end
  end

  context "when we have a class which has use_id => false" do
    it "should find element only when seo_url is same (or by id)" do
      a = subject.create(:name => 'bla bla bla')
      subject.find(a.id).should eql(a)
      subject.find(a.to_param).should eql(a)
      lambda { subject.find("#{a.to_param}aaa") }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when updating object" do
    it "should have refreshed seo_url" do
        a = subject.create({:name => 'mensfeld', :title => 'test abc'})
        a.to_param.should eql("mensfeld-test-abc")
        a.name = 'kowalski'
        a.save
        a.to_param.should eql("kowalski-test-abc")
        subject.find("kowalski-test-abc").should eql(a)
    end
  end

end
