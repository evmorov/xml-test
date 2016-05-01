require 'spec_helper'
require 'nokogiri'

describe 'Nokogiri' do
  let(:xml) { File.read File.join(File.dirname(__FILE__), 'fixtures', 'example.xml') }
  let(:doc) { Nokogiri::XML(xml) }

  it 'Find id of school with the name "Second school"' do
    id = doc.xpath('//school[name/text()="Second school"]/id').text
    expect(id).to eq('2')
  end

  it 'Find emails of school with id "2"' do
    emails = doc.xpath('//school[id/text()="2"]/emails/email').map(&:text)
    expect(emails).to match(%w(s1@mail.com s2@mail.com))
  end

  it 'Find all school emails' do
    emails = doc.xpath('//school/emails/email').map(&:text)
    expect(emails).to match(%w(f1@mail.com f2@mail.com s1@mail.com s2@mail.com))
  end

  it 'Count schools' do
    school_count = doc.xpath('//school').size
    expect(school_count).to eq(2)
  end

  it 'Find student names from school with the name "Second school"' do
    school_id = doc.xpath('//school[name/text()="Second school"]/id').text
    student_names = doc.xpath("//student[schoolId/text()=#{school_id}]/name").map(&:text)
    expect(student_names).to match(%w(Alex Olivia))
  end

  it 'Find the name of a student with the phone number "666"' do
    name = doc.xpath('//student[contacts/phone/text()="666"]/name').text
    expect(name).to eq('Mark')
  end

  it 'Count female students' do
    female_count = doc.xpath('//student/sex[text()="F"]').size
    expect(female_count).to eq(2)
  end

  it 'Find the name of a student that does not have a phone number in contacts' do
    student_name = doc.xpath('//student[not(contacts/phone)]/name').text
    expect(student_name).to eq('Olivia')
  end

  it 'Find id of a female student with the name "Alex"' do
    student_id = doc.xpath('//student[name/text()="Alex" and sex/text()="F"]/id').text
    expect(student_id).to eq('7')
  end

  it 'Find the name of the last student' do
    student_name = doc.xpath('//student[last()]/name').text
    expect(student_name).to eq('Olivia')
  end

  it 'No events' do
    events = doc.xpath('//events').text
    expect(events).to be_empty
  end

  it 'No student with id "9"' do
    student = doc.xpath('//student[id/text()="9"]')
    expect(student).to be_empty
  end

  it 'Find id of school that starts with the word "Second"' do
    school_id = doc.xpath('//school[starts-with(name, "Second")]/id').text
    expect(school_id).to eq('2')
  end
end
