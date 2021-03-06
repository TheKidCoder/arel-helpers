# encoding: UTF-8

require 'spec_helper'

class TestQueryBuilder < ArelHelpers::QueryBuilder
  def initialize(query = nil)
    super(query || Post.unscoped)
  end

  def noop
    reflect(query)
  end
end

describe ArelHelpers::QueryBuilder do
  let(:builder) { TestQueryBuilder.new }

  it "returns (i.e. reflects) new instances of QueryBuilder" do
    builder.tap do |original_builder|
      original_builder.noop.object_id.should_not == original_builder.object_id
    end
  end

  it "forwards #to_a" do
    Post.create(title: "Foobar")
    builder.to_a.tap do |posts|
      posts.size.should == 1
      posts.first.title.should == "Foobar"
    end
  end

  it "forwards #to_sql" do
    builder.to_sql.strip.should == 'SELECT "posts".* FROM "posts"'
  end

  it "forwards #each" do
    created_post = Post.create(title: "Foobar")
    builder.each do |post|
      post.should == created_post
    end
  end

  it "forwards other enumerable methods via #each" do
    Post.create(title: "Foobar")
    builder.map(&:title).should == ["Foobar"]
  end
end
