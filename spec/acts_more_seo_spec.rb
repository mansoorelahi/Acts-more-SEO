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

class HistorableElement < ActiveRecord::Base
    acts_more_seo :columns => :name, 
      :use_id => false, 
      :history => true,
      :case_sensitive => true
end

class IntegerElement < ActiveRecord::Base
  acts_more_seo :columns => [:name]
end

describe CoolElement do
  subject { CoolElement }
  before(:each){ subject.destroy_all }

  context "when we have polish letters" do
    it "should turn them into global and use downcase" do
      a = subject.create(:name => 'Kraj Żelaza')
      a.name.to_url.should == 'kraj-zelaza'
    end

   context 'when we add some pauses in the name' do
     it "should replace them and leave only one" do
      a = subject.create(:name => 'Kraj - Żelaza')
      a.name.to_url.should == 'kraj-zelaza'
     end
   end
  end

  context "when we have a class which has use_id => true" do
    it "should find element unless id is corrupted" do
      a = subject.create(:name => 'bla bla bla')
      subject.find_by_seo(a.id).should eql(a)
      subject.find_by_seo(a.to_param).should eql(a)
      subject.find_by_seo("#{a.to_param}aaa").should eql(a)
      subject.find_by_seo("134534dass").should eql(nil)
      lambda { subject.find_by_seo!("134534dass") }.should raise_error(ActiveRecord::RecordNotFound)
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
        a = subject.create(:name => 'Danzō')
        a.to_param.should eql("#{a.id}-danzo")
      end
    end
  end
end

describe CoolerElement do
  subject { CoolerElement }
  before(:each){ subject.destroy_all }

  context "when there is no name" do
    it "should return only id" do
      a = subject.create
      a.to_param.should eql(a.id.to_s)
    end

    it "should be able to find existing element" do
      a = subject.create
      subject.find_by_seo(a.id).should eql(a)
    end

    it "should raise error when there is no element" do
      a = subject.create
     lambda { subject.find_by_seo!(a.id+1) }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when there is no name" do
    it "should return nice url" do
      a = subject.create(:title => 'bla bla bla')
      a.to_param.should eql("#{a.id}-bla-bla-bla")
      subject.find_by_seo!(a.to_param).should eql(a)
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
  before(:each){ subject.destroy_all }

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
  before(:each){ subject.destroy_all }

  context "when there is no surname" do
    context "but surname and title exists" do
      it "should return nice looking url " do
        a = subject.create({:name => 'mensfeld', :title => 'test abc'})
        a.seo_url.should eql("mensfeld-test-abc")
        a.seo_url.should eql("mensfeld-test-abc")
      end
    end
  end

  context "when there is no name" do
    context "but surname and title exists" do
      it "should return nice looking url " do
        a = subject.create({:surname => 'mensfeld', :title => 'test abc'})
        a.seo_url.should eql("mensfeld-test-abc")
        a.reload
        a.seo_url.should eql("mensfeld-test-abc")
      end
    end

    context "and no other param" do
      it "should return only id" do
        a = subject.create()
        a.seo_url.should eql("#{a.id}")
        a.reload
        a.seo_url.should eql("#{a.id}")
      end
    end
  end

  context "when there are all the params" do
    it "should return nice url" do
        a = subject.create({:name => 'maciej', :surname => 'mensfeld', :title => 'test abc'})
        a.seo_url.should eql("maciej-mensfeld-test-abc")
        a.reload
        a.seo_url.should eql("maciej-mensfeld-test-abc")
    end
  end

  context "when we have a class which has use_id => false" do
    it "should find element only when seo_url is same (or by id) case insensitive" do
      a = subject.create(:name => 'bla bla bla')
      subject.find_by_seo!(a.seo_url).should eql(a)
      subject.find_by_seo!('Bla-bLa-blA').should eql(a)
      lambda { subject.find_by_seo!("#{a.to_param}aaa") }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when updating object" do
    it "should have refreshed seo_url" do
        a = subject.create({:name => 'mensfeld', :title => 'test abc'})
        a.seo_url.should eql("mensfeld-test-abc")
        a.name = 'kowalski'
        a.save
        a.seo_url.should eql("kowalski-test-abc")
        subject.find_by_seo("kowalski-test-abc").should eql(a)
    end
  end

  context "when we have two objects" do
    it "should assing to the second - seo url with id" do
        a = subject.create({:name => 'mensfeld', :title => 'test abc'})
        b = subject.create({:name => 'mensfeld ', :title => 'test abc'})
        a.seo_url.should eql("mensfeld-test-abc")
        b.reload
        b.seo_url.should eql("#{b.id}-mensfeld-test-abc")
    end

    context "and we change name in a second one" do
      it "should add na id if necessery" do
        a = subject.create({:name => 'mensfeld', :title => 'test abc'})
        b = subject.create({:name => 'mensfeld2 ', :title => 'test abc'})
        a.seo_url.should eql("mensfeld-test-abc")
        b.seo_url.should eql("mensfeld2-test-abc")
        b.name = 'mensfeld'
        b.save!
        b.reload
        b.seo_url.should eql("#{b.id}-mensfeld-test-abc")
      end

      it "should not add id if not necessery" do
        a = subject.create({:name => 'mensfeld', :title => 'test abc'})
        b = subject.create({:name => 'mensfeld2 ', :title => 'test abc'})
        a.seo_url.should eql("mensfeld-test-abc")
        b.seo_url.should eql("mensfeld2-test-abc")
        b.name = 'mensfeld3'
        b.save!
        b.reload
        b.seo_url.should eql("mensfeld3-test-abc")
      end
    end
  end

end

describe HistorableElement do
  subject { HistorableElement }
  before(:each){ subject.destroy_all }

  context "when we have polish letters" do
    it "should turn them into global and use downcase" do
      a = subject.create(:name => 'Kraj Żelaza')
      a.name.to_url.should == 'kraj-zelaza'
    end
  end

  context "when there is no name" do
    it "should return only id" do
      a = subject.create
      a.to_param.should eql(a.id.to_s)
    end
  end

  context "when we change element name" do
    it "should be able to find it via old one also" do
      a = subject.create(:name => 'Kraj Żelaza')
      a.name.to_url.should == 'kraj-zelaza'

      a.update_attributes(:name => 'Kraj Złota')
      a.reload
      subject.find_by_seo('kraj-zelaza').should eql a
      subject.find_by_seo('kraj-zlota').should eql a
      subject.find_by_seo('kraj-a').should eql nil
    end

    context "and the new seo_url looks the same as old one" do
      it "should not remember it in history" do
        nr = Acts::MoreSeo::SeoHistory.count
        a = subject.create(:name => 'Kraj Żelaza')
        a.update_attributes(:name => 'Kraj Żelaza')
        nr.should eql Acts::MoreSeo::SeoHistory.count
      end
    end
  end

  context "when searching for a case sensitive element" do
    it "shoudl find only if case is same" do
      a = subject.create(:name => 'Kraj Żelaza')
      subject.find_by_seo('kraj-zelaza').should eql a
      lambda { subject.find_by_seo!('kraj-zelazA') }.should raise_error(ActiveRecord::RecordNotFound)    
    end
  end

end

describe IntegerElement do
  subject { IntegerElement }
  before(:each){ subject.destroy_all }

  context "when we have integer field" do
    it "should cast it to string before saving" do
      a = subject.create(:name => 1234)
      a.name.to_s.to_url.should == '1234'
    end
  end
end
