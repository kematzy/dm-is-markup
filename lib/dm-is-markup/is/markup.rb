module DataMapper
  module Is
    
    # = dm-is-markup
    # 
    # 
    # 
    #     class Article
    #       include DataMapper::Resource
    #       property :id,     Serial
    #       property :title,   String
    #       ...<snip>
    # 
    #       is :markup, [:title, :body]
    # 
    #     end
    # 
    # 
    # 
    # 
    # 
    # 
    module Markup
      
      RENDER_FORMATS = [:erb, :html, :markdown, :txt, :textile, :textile_erb]
      
      
      ##
      # fired when your plugin gets included into Resource
      #
      def self.included(base)
        
      end
      
      ##
      # Methods that should be included in DataMapper::Model.
      # Normally this should just be your generator, so that the namespace
      # does not get cluttered. ClassMethods and InstanceMethods gets added
      # in the specific resources when you fire is :markup
      # 
      ##
      # 
      # 
      # ==== Examples 
      # 
      # Simplest declaration, makes the :body field into textile formatted
      # 
      #   is :markup :body
      # 
      # Multiple fields marked-up
      # 
      #   is :markup :title, :body
      # 
      # Using different renders for different fields
      # 
      #   is :markup :title => :textile, :body => :markdown
      # 
      # Passing mode to the renderer, by using an Array as the node value
      # 
      #   is :markup :title => [:textile, :lite_mode], :body => :markdown
      # 
      # 
      # 
      # 
      
      def is_markup(*args)
        # incoming can be either:
        #   - Array (of fields)
        #   - Hash ( field => renderer )
        #   - Hash ( field => [renderer,render_options] )
        raise ArgumentError, "You must declare a field/attribute to markup" if args.empty?
        
        # holder of the field names to format
        markup_attributes = {}
        markedup_attributes = []
        # test if handles unicode text
        markup_handle_unicode = String.new.respond_to? :chars
        # the formatting options
        markup_type_options = %w( plain source )
        
        # Check through things before proceeding
        if args.first.is_a?(Symbol)
          
          args.each do |f|
            raise ArgumentError, "The attribute [#{f.inspect}] is NOT an existing attribute in the Model" unless properties.any?{ |p| p.name == f.to_sym }
            markup_attributes[f] = :textile
          end
          
        elsif args.first.is_a?(Hash)
          
          args.first.each do |f, r|
            raise ArgumentError, "The attribute [#{f.inspect}] is NOT an existing attribute in the Model" unless properties.any?{ |p| p.name == f.to_sym }
            renderer =  r.is_a?(Array) ? r.first : r
            raise ArgumentError, "The renderer [#{renderer.inspect}] is NOT an available renderer. Please use one of the following renderers: \"#{RENDER_FORMATS.join(', ')}\"" unless RENDER_FORMATS.include?(renderer.to_sym)
          end
          markup_attributes = args.first
          
        else
          raise ArgumentError, "I'm totally confused about what you've written in the method declaration. Please RTFM ;-)"
        end
        
        
        # loop through all the attributes
        puts "markup_attributes.inspect=[#{markup_attributes.inspect}]<br>"
        markup_attributes.each do |attribute, renderer|
          
          puts "<br>markup_attributes.each do | attribute=[#{attribute}], renderer=[#{renderer.inspect}] |"
          define_method(attribute) do |*type|   # def attribute_name(:type)
            type = type.first
            
            if type.nil? && self[attribute]
              # render content here
              puts "<br><br>renderer=[#{renderer.inspect}] renderer.class=[#{renderer.class}]<br><br>"
              
              # if renderer.is_a?(Array) 
              #   the_renderer = renderer.shift 
              #   the_render_options = renderer
              #   puts "\n\nIS ARRAY the_renderer=[#{the_renderer.inspect}] and the_render_options=[#{the_render_options.inspect}]<br><br>"
              # else
                the_renderer = renderer
                the_render_options = []
                puts "\n\nthe_renderer=[#{the_renderer.inspect}] and the_render_options=[#{the_render_options.inspect}]<br><br>"
              # end
              
              
              case the_renderer.to_sym
              when :erb
                out = ::ERB.new(self[attribute]).result(binding).strip
              when :html
              when :txt
                out = self[attribute]
              when :textile
                require 'RedCloth'
                # out = ::RedCloth.new(self[attribute], renderer << :no_span_caps ).to_html
                out = ::RedCloth.new(self[attribute], the_render_options ).to_html
              # when :textile_erb
              #   require 'RedCloth'
              #   out = ::RedCloth.new(self[attribute], renderer + [:no_span_caps] ).to_html
              when :markdown
                require 'rdiscount'
                out = ::RDiscount.new(self[attribute]).to_html
              else
                raise ArgumentError, "Unknown output format [#{the_renderer}] for attribute [#{attribute}]"
              end
              
              # # def render(output_format=nil) 
              #   # if we want the raw format only
              #   return self.answer unless output_format.nil?
              # 
              #   case self.format
              #   when 'erb'
              #     # handle recursive snippets by adding the binding
              #     out = ::ERB.new(self.answer).result(binding).strip
              #   when 'html'
              #     out = self.answer
              #   when 'txt'
              #     out = self.answer
              #   when 'markdown'
              #     require 'rdiscount'
              #     out = ::RDiscount.new(self.answer).to_html
              #   when 'textile'
              #     out = ::RedCloth.new(self.answer, [:no_span_caps] ).to_html
              #   when 'textile_erb'
              #     out = ::RedCloth.new(::ERB.new(self.answer.lerb).result(binding).strip, [:no_span_caps] ).to_html
              #   else
              #     out = "format[#{self.format}] + " + self.answer.inspect
              #   end
              #   out
              # # end
              # # alias_method :to_html, :render
              
            elsif type.nil? && self[attribute].nil?
              nil
            elsif markup_type_options.include?(type.to_s)
              send("#{attribute}_#{type}")
            else
              raise ArgumentError, "Invalid format option: '#{type}'. Allowed values are: '#{markup_type_options.join('\' or \'')}'."
            end
            
            markedup_attributes << attribute
            
            puts "<br><br>markedup_attributes.inspect=[#{markedup_attributes.inspect}] [#{__FILE__}:#{__LINE__}]"
          end #/ attribute.each
          
          define_method("#{attribute}_plain",  proc { strip_redcloth_html(__send__(attribute)) if __send__(attribute) } )
          define_method("#{attribute}_source",  proc { __send__(attribute) } )
          # define_method("#{attribute}_source",  proc { __send__("#{attribute}_before_type_cast") } )
          
        end
        
        
        
        
        
        # Add class-methods
        extend  DataMapper::Is::Markup::ClassMethods
        
        # Only need to define these once on a class
        unless included_modules.include? InstanceMethods
          class_inheritable_accessor  :markup_attributes,
                                      :markup_handle_unicode,
                                      :markup_type_options
          
          # Add instance-methods
          include DataMapper::Is::Markup::InstanceMethods
        end
        
        
        self.markup_attributes = markup_attributes
        self.markup_handle_unicode = markup_handle_unicode
        self.markup_type_options = markup_type_options
        
      end
      
      module ClassMethods
        
      end # ClassMethods
      
      module InstanceMethods
        
        ##
        # Ensuring all models using this plugin responds to markedup? with true.
        #  
        # ==== Examples
        # 
        #   @some_model.markedup?  =>  true
        # 
        # @api public
        def markedup?
          true
        end
        
        
        ##
        # TODO: add some comments here
        #  
        # ==== Examples
        # 
        # 
        # @api public/private
        def markedup
          markedup? ? (@markedup ||= {}) : @markedup_attributes.dup
        end
        
        private
          
          
          ##
          # Removes RedCloth HTML code from the attribute
          #  
          # ==== Examples
          # 
          # 
          # 
          # @api public
          def strip_redcloth_html(html)
            returning html.dup.gsub(html_regexp, '') do |h|
              redcloth_glyphs.each do |(entity, char)|
                sub = [ :gsub!, entity, char ]
                @markup_handle_unicode ? h.chars.send(*sub) : h.send(*sub)
              end
            end
          end
          
          ##
          # Converts entities into text chars.
          #  
          # ==== Examples
          # 
          # 
          # 
          # @api public
          def redcloth_glyphs
             [[ '&#8217;', "'" ],
              [ '&#8216;', "'" ],
              [ '&lt;', '<' ], 
              [ '&gt;', '>' ], 
              [ '&#8221;', '"' ],
              [ '&#8220;', '"' ],
              [ '&#8230;', '...' ],
              [ '\1&#8212;', '--' ], 
              [ ' &rarr; ', '->' ], 
              [ ' &#8211; ', '-' ], 
              [ '&#215;', 'x' ], 
              [ '&#8482;', '(TM)' ], 
              [ '&#174;', '(R)' ],
              [ '&#169;', '(C)' ]]
          end
          
          ##
          #  
          #  
          # ==== Examples
          # 
          #  
          # 
          # @api public
          def html_regexp
            %r{<(?:[^>"']+|"(?:\\.|[^\\"]+)*"|'(?:\\.|[^\\']+)*')*>}xm
          end
        
      end # InstanceMethods
      
      module ResourceInstanceMethods 
        
        ##
        # Ensuring all models NOT using this plugin responds to markedup? with false.
        #  
        # ==== Examples
        # 
        #   @untouched_model.markedup?  =>  false
        # 
        # @api public
        def markedup?
          false
        end
        
      end #/module ResourceInstanceMethods
      
    end # Markup
  end # Is
end # DataMapper
