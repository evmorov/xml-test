require 'spec_helper'
require 'sax-machine'
require 'nokogiri'

module SamMachineMapping
  class StudentContacts
    include SAXMachine
    element :phone
  end

  class Student
    include SAXMachine
    element :id
    element :name
    element :sex
    element :schoolId, as: :school_id
    element :contacts, class: StudentContacts
  end

  class StudentCollection
    include SAXMachine
    elements :student, as: :students, class: Student
  end

  class SchoolEmailCollection
    include SAXMachine
    elements :email, as: :emails
  end

  class School
    include SAXMachine
    element :id
    element :name
    element :emails, as: :email_collection, class: SchoolEmailCollection
  end

  class SchoolCollection
    include SAXMachine
    elements :school, as: :schools, class: School
  end
end

describe 'Sax-machine' do
  let(:xml) { File.read File.join(File.dirname(__FILE__), 'fixtures', 'example.xml') }
  let(:school_collection) { SamMachineMapping::SchoolCollection.parse(xml) }
  let(:student_collection) { SamMachineMapping::StudentCollection.parse(xml) }

  it 'Find id of school with the name "Second school"' do
    id = school_collection.schools.find { |school| school.name == 'Second school' }.id
    expect(id).to eq('2')
  end

  it 'Find emails of school with id "2"' do
    emails = school_collection.schools.find { |school| school.id == '2' }.email_collection.emails
    expect(emails).to match(%w(s1@mail.com s2@mail.com))
  end

  it 'Find all school emails' do
    emails = school_collection.schools.map { |school| school.email_collection.emails }.flatten
    expect(emails).to match(%w(f1@mail.com f2@mail.com s1@mail.com s2@mail.com))
  end

  it 'Count schools' do
    school_count = school_collection.schools.size
    expect(school_count).to eq(2)
  end

  it 'Find student names from school with the name "Second school"' do
    school_id = school_collection.schools.find { |school| school.name == 'Second school' }.id
    student_names = student_collection.students.select do |student|
      student.school_id == school_id
    end.map(&:name)
    expect(student_names).to match(%w(Alex Olivia))
  end

  it 'Find the name of a student with the phone number "666"' do
    name = student_collection.students.find { |student| student.contacts.phone == '666' }.name
    expect(name).to eq('Mark')
  end

  it 'Count female students' do
    female_count = student_collection.students.count { |student| student.sex == 'F' }
    expect(female_count).to eq(2)
  end

  it 'Find the name of a student that does not have a phone number in contacts' do
    student_name = student_collection.students.find { |student| !student.contacts.phone }.name
    expect(student_name).to eq('Olivia')
  end

  it 'Find id of a female student with the name "Alex"' do
    student_id = student_collection.students.find do |student|
      student.name == 'Alex' && student.sex == 'F'
    end.id
    expect(student_id).to eq('7')
  end

  it 'Find the name of the last student' do
    student_name = student_collection.students.last.name
    expect(student_name).to eq('Olivia')
  end

  it 'No events' do
    # don't know how to do that so Nokogiri is used
    events = Nokogiri::XML(xml).xpath('//events').text
    expect(events).to be_empty
  end

  it 'No student with id "9"' do
    student = student_collection.students.find { |student| student.id == '9' }
    expect(student).to be_nil
  end

  it 'Find id of school that starts with the word "Second"' do
    school_id = school_collection.schools.find { |school| school.name.start_with? 'Second' }.id
    expect(school_id).to eq('2')
  end
end
