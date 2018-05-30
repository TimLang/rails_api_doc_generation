



# desc
#
# Params:
#   attr: xxx
#   other: yyy
#       asdf las dflkj
# Other:
#   attr: aaa
#
#
# conversion =>
# {
#   'desc' => 'desc',
#   'Params' => [{level: 1, }],
# }
#

module ApiDocGeneration; module FormatNote; class << self

  def analyze(filelines, line_number)
    document = {}

    tmp = []; last_line = ""

    line_number.downto(0) do |i|
      line = filelines[i]

      break unless line =~ /^\s*(\#.*?\n)?$/
      break if line =~ /encoding/

      line.gsub!(/\s*\#/, '')
      next if line =~ /^\s*$/

      format_line(line, tmp, document)

      last_line = line
    end

    document['Desc'] = last_line
    document.delete last_line

    Hash[document.to_a.reverse]
  end



  private

  def format_line(line, tmp, document)
    m = line.match(/(?<level>\s*)(?<desc>(?<key>.*?)(\:(?<val>.*?))?)$/)
    level = m[:level].length / 2
    desc = m[:desc].gsub(/^\s*|\s*$/, '')
    line.gsub!(/^\s*|\:?\s*$/, '')

    if level == 0
      if tmp.length == 0 && m[:val] && m[:val].length > 0
        document[m[:key]] = m[:val]
      else
        document[m[:key] + (m[:val] || '')] = tmp.reverse.each_with_object([]) do |p, result|
          if p['level'] >= 2 && result.last
            result.last['children'] ||= []
            result.last['children'] << p
          else
            result << p
          end
        end
      end
      tmp.clear
    else
      m = desc.match(/(?<name>\w+.*?:)\:?\s*((\[(?<type>.*?)(?<required>:required)??)\]\s*?(?<val>.*))?$/)
      p = {'level' => level, 'desc' => desc}

      p.merge!({
        'name' => m[:name]&.sub(/[:：]/,''),
        'type' => m[:type],
        'required' => m[:required].nil? ? false : true,
        'val' => m[:val]
      }) if m

      tmp << p
    end
  end
end; end; end
