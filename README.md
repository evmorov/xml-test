# XmlTest

Compare different xml parsing libraries.

## Given

```xml
<city>
  <schools>
    <school>
      <id>1</id>
      <name>First school</name>
      <emails>
        <email>first1@school.com</email>
        <email>first2@school.com</email>
      </emails>
    </school>
    <school>
      <id>2</id>
      <name>Second school</name>
      <emails>
        <email>second1@school.com</email>
        <email>second2@school.com</email>
      </emails>
    </school>
  </schools>
  <students>
    <student>
      <id>5</id>
      <name>Alex</name>
      <sex>M</sex>
      <schoolId>1</schoolId>
      <contacts>
        <phone>555</phone>
      </contacts>
    </student>
    <student>
      <id>6</id>
      <name>Mark</name>
      <sex>M</sex>
      <schoolId>1</schoolId>
      <contacts>
        <phone>666</phone>
      </contacts>
    </student>
    <student>
      <id>7</id>
      <name>Alex</name>
      <sex>F</sex>
      <schoolId>2</schoolId>
      <contacts>
        <phone>777</phone>
      </contacts>
    </student>
    <student>
      <id>8</id>
      <name>Olivia</name>
      <sex>F</sex>
      <schoolId>2</schoolId>
    </student>
  </students>
  <events>
  </events>
</city>
```

## Tasks

1. Find id of school with the name "Second school"
2. Find emails of school with id "2"
3. Find all school emails
4. Count schools
5. Find student names from school with the name "Second school"
6. Find the name of a student with the phone number "666"
7. Count female students
8. Find the name of a student that does not have a phone number in contacts
9. Find id of a female student with the name "Alex"
10. Find the name of the last student
11. No events
12. No student with id "9"
13. Find id of school that starts with the word "Second"

## Libraries

1. [Nokogiri](https://github.com/sparklemotion/nokogiri)
2. [HappyMapper](https://github.com/dam5s/happymapper)
3. [SAX Machine](https://github.com/pauldix/sax-machine)

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/evmorov/xml-test>.
