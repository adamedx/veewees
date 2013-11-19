class SysprepGenerator
  def initialize( sysprep_xml_source_file, sysprep_script_destination_file)
    @sysprep_xml_file = sysprep_xml_file
    @sysprep_script_destination_file = sysprep_script_destination_file
  end

  def escape_for_batch content
    # escape WIN BATCH special chars
    content.gsub!(/[(<|>)^]/).each{|m| "^#{m}"}
  end

  def generate
    escaped_content = nil

    File.Open(@sysprep_xml_file) |source| do
      content = source.read
      escaped_content = escape_for_batch content
    end

    
    
  end

  def write_batch content
    File.Open(
  end
  
  
end

