require 'spec_helper'
require 'happymapper'

module HappyMapperMapping
  class StudentContacts
    include HappyMapper
    tag 'contacts'
    has_one :phone, String
  end

  class Student
    include HappyMapper
    tag 'student'
    has_one :id, String
    has_one :name, String
    has_one :sex, String
    has_one :school_id, String, tag: 'schoolId'
    has_one :contacts, StudentContacts
  end

  class SchoolEmailCollection
    include HappyMapper
    tag 'emails'
    has_many :emails, String, tag: 'email'
  end

  class School
    include HappyMapper
    tag 'school'
    has_one :id, String
    has_one :name, String
    has_one :email_collection, SchoolEmailCollection, tag: 'emails'
  end
end

describe 'HappyMapper' do
  let(:xml) { File.read File.join(File.dirname(__FILE__), 'fixtures', 'example.xml') }
  let(:schools) { HappyMapperMapping::School.parse(xml) }
  let(:students) { HappyMapperMapping::Student.parse(xml) }
  let(:email_collection) { HappyMapperMapping::SchoolEmailCollection.parse(xml) }

  it 'Find id of school with the name "Second school"' do
    id = schools.find { |school| school.name == 'Second school' }.id
    expect(id).to eq('2')
  end

  it 'Find emails of school with id "2"' do
    emails = schools.find { |school| school.id == '2' }.email_collection.emails
    expect(emails).to match(%w(s1@mail.com s2@mail.com))
  end

  it 'Find all school emails' do
    emails = email_collection.map(&:emails).flatten
    expect(emails).to match(%w(f1@mail.com f2@mail.com s1@mail.com s2@mail.com))
  end

  it 'Count schools' do
    school_count = schools.size
    expect(school_count).to eq(2)
  end

  it 'Find student names from school with the name "Second school"' do
    school_id = schools.find { |school| school.name == 'Second school' }.id
    student_names = students.select { |student| student.school_id == school_id }.map(&:name)
    expect(student_names).to match(%w(Alex Olivia))
  end

  it 'Find the name of a student with the phone number "666"' do
    name = students.find { |student| student.contacts.phone == '666' }.name
    expect(name).to eq('Mark')
  end

  it 'Count female students' do
    female_count = students.count { |student| student.sex == 'F' }
    expect(female_count).to eq(2)
  end

  it 'Find the name of a student that does not have a phone number in contacts' do
    student_name = students.find { |student| !student.contacts.phone }.name
    expect(student_name).to eq('Olivia')
  end

  it 'Find id of a female student with the name "Alex"' do
    student_id = students.find { |student| student.name == 'Alex' && student.sex == 'F' }.id
    expect(student_id).to eq('7')
  end

  it 'Find the name of the last student' do
    student_name = students.last.name
    expect(student_name).to eq('Olivia')
  end

  it 'No events' do
    # don't know how to do that so Nokogiri is used
    events = Nokogiri::XML(xml).xpath('//events').text
    expect(events).to be_empty
  end

  it 'No student with id "9"' do
    student = students.find { |student| student.id == '9' }
    expect(student).to be_nil
  end

  it 'Find id of school that starts with the word "Second"' do
    school_id = schools.find { |school| school.name.start_with? 'Second' }.id
    expect(school_id).to eq('2')
  end
end
