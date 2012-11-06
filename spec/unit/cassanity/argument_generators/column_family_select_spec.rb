require 'helper'
require 'cassanity/argument_generators/column_family_select'

describe Cassanity::ArgumentGenerators::ColumnFamilySelect do
  let(:column_family_name) { 'apps' }

  describe "#call" do
    it "returns array of arguments" do
      cql = "SELECT * FROM #{column_family_name}"
      expected = [cql]
      subject.call(name: column_family_name).should eq(expected)
    end

    context "with :keyspace_name" do
      it "returns array of arguments" do
        cql = "SELECT * FROM foo.#{column_family_name}"
        expected = [cql]
        subject.call({
          keyspace_name: :foo,
          name: column_family_name
        }).should eq(expected)
      end
    end

    context "with single column" do
      it "returns array of arguments querying only one column" do
        cql = "SELECT name FROM #{column_family_name}"
        expected = [cql]
        subject.call({
          name: column_family_name,
          select: :name,
        }).should eq(expected)
      end
    end

    context "with multiple columns" do
      it "returns array of arguments querying multiple columns" do
        cql = "SELECT id, name, created_at FROM #{column_family_name}"
        expected = [cql]
        subject.call({
          name: column_family_name,
          select: [:id, :name, :created_at],
        }).should eq(expected)
      end
    end

    context "with count *" do
      it "returns array of arguments querying multiple columns" do
        cql = "SELECT COUNT(*) FROM #{column_family_name}"
        expected = [cql]
        subject.call({
          name: column_family_name,
          select: 'COUNT(*)',
        }).should eq(expected)
      end
    end

    context "with count 1" do
      it "returns array of arguments querying multiple columns" do
        cql = "SELECT COUNT(1) FROM #{column_family_name}"
        expected = [cql]
        subject.call({
          name: column_family_name,
          select: 'COUNT(1)',
        }).should eq(expected)
      end
    end

    context "with WRITETIME" do
      it "returns array of arguments querying multiple columns" do
        cql = "SELECT WRITETIME(name) FROM #{column_family_name}"
        expected = [cql]
        subject.call({
          name: column_family_name,
          select: 'WRITETIME(name)',
        }).should eq(expected)
      end
    end

    context "with TTL" do
      it "returns array of arguments querying multiple columns" do
        cql = "SELECT TTL(name) FROM #{column_family_name}"
        expected = [cql]
        subject.call({
          name: column_family_name,
          select: 'TTL(name)',
        }).should eq(expected)
      end
    end

    context "with where option" do
      let(:where_clause) {
        lambda { |args| [" WHERE foo = ?", args.fetch(:where).fetch(:foo)]}
      }

      subject {
        described_class.new({
          where_clause: where_clause,
        })
      }

      it "returns array of arguments with help from where clause" do
        where = {foo: 'bar'}
        cql = "SELECT * FROM #{column_family_name} WHERE foo = ?"
        expected = [cql, 'bar']
        subject.call({
          name: column_family_name,
          where: where,
        }).should eq(expected)
      end
    end
  end
end