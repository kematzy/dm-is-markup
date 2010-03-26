require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

if HAS_SQLITE3 || HAS_MYSQL || HAS_POSTGRES
  describe 'DataMapper::Is::Markup' do
    
    # class InvalidArticle
    #   include DataMapper::Resource
    #   property :id,     Serial
    #   property :title,   String
    #   property :body,    Text
    #   
    #   is :markup
    # end 
    
    # args.class=[Array] when args.inspect=[[:body]] 
    # args.class=[Array] when args.inspect=[[:title, :body]]
    # args.class=[Array] when args.inspect=[[{:title=>:textile, :body=>:markdown}]]
    
    # args.class=[Array], args.first.class=[Symbol] when args.inspect=[[:body]] 
    # args.class=[Array], args.first.class=[Symbol] when args.inspect=[[:title, :body]] 
    # args.class=[Array], args.first.class=[Hash] when args.inspect=[[{:title=>:textile, :body=>:markdown}]]
    
    # class SingleArticle
    #   include DataMapper::Resource
    #   property :id,     Serial
    #   property :title,   String
    #   property :body,    Text
    #   
    #   is :markup, :body
    # end 
    # 
    # class DoubleArticle
    #   include DataMapper::Resource
    #   property :id,     Serial
    #   property :title,   String
    #   property :body,    Text
    #   
    #   is :markup, :title, :body
    # end 
    # 
    # class DiffArticle
    #   include DataMapper::Resource
    #   property :id,     Serial
    #   property :title,   String
    #   property :body,    Text
    #   
    #   is :markup, :title => :textile, :body => :markdown
    # end 
    
    class HashArticle
      include DataMapper::Resource
      property :id,     Serial
      property :title,   String
      property :body,    Text
      
      # is :markup, :title => [:textile, :no_span_caps], :body => :markdown
      is :markup, :title => :textile, :body => :markdown
    end 
    
    
    before(:each) do 
      
      # SingleArticle.auto_migrate!
      # DoubleArticle.auto_migrate!
      # DiffArticle.auto_migrate!
      HashArticle.auto_migrate!
      
      # SingleArticle.create(:title => "SingleArticle", :body => "Does _this_ *work*?" )
      # DoubleArticle.create(:title => "*DoubleArticle*", :body => "Does _this_ *work*?" )
      # DiffArticle.create(:title => "*DiffArticle*", :body => "Does _this_ *work*?" )
      HashArticle.create(:title => "*HashArticle*", :body => "Does _this_ *work*?" )
    end
    
    
    # it "should jdsaljflj" do
    #   SingleArticle.first.body.should == 'adfasdf'
    # end
    
    it "should qewrqwerq" do
      # lambda { 
      #   HashArticle.auto_migrate!
      #  }.should raise_error(Exception)
      
      HashArticle.first.body(:source).should == 'adfasdf'
    end
    
    
    
  #   describe "is :markup" do 
  #     
  #     describe "setup configurations" do 
  #       
  #       describe "invalid declaration" do 
  #         
  #         it "should raise an ArgumentError if no args are passed" do 
  #           lambda { 
  #             class InvalidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :body,    Text
  #               is :markup
  #             end 
  #           }.should raise_error(ArgumentError)
  #         end
  #         
  #         it "should raise an ArgumentError if weird args are passed" do 
  #           lambda { 
  #             class InvalidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :body,    Text
  #               is :markup, 123
  #             end 
  #           }.should raise_error(ArgumentError)
  #         end
  #         
  #         it "should raise an ArgumentError if non-existent fields are passed" do 
  #           lambda { 
  #             class InvalidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :body,    Text
  #               is :markup, :does_not_exist
  #             end 
  #           }.should raise_error(ArgumentError)
  #         end
  #         
  #         it "should raise an ArgumentError if non-existent fields are passed in a Hash " do 
  #           lambda { 
  #             class InvalidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :body,    Text
  #               is :markup, :does_not_exist => :textile
  #             end 
  #           }.should raise_error(ArgumentError)
  #         end
  #         
  #         it "should raise an ArgumentError if non-supported renderer is passed in a Hash " do 
  #           lambda { 
  #             class InvalidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :body,    Text
  #               is :markup, :body => :does_not_exist
  #             end 
  #           }.should raise_error(ArgumentError)
  #           lambda { 
  #             class InvalidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :body,    Text
  #               is :markup, :body => 'is_a_string'
  #             end 
  #           }.should raise_error(ArgumentError)
  #         end
  #         
  #       end #/ invalid declaration
  #       
  #       describe "valid declarations" do 
  #         
  #         it "should NOT raise an ArgumentError when passing existent attributes" do 
  #           lambda { 
  #             class ValidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :body,    Text
  #               is :markup, :body 
  #             end 
  #           }.should_not raise_error(ArgumentError)
  #         end
  #         
  #         it "should NOT raise an ArgumentError when passing existent attributes as an Array" do 
  #           lambda { 
  #             class ValidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :title,   String
  #               property :body,    Text
  #               is :markup, :title, :body 
  #             end 
  #           }.should_not raise_error(ArgumentError)
  #         end
  #         
  #         it "should NOT raise an ArgumentError when passing existent attributes in a Hash" do 
  #           lambda { 
  #             class ValidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :title,   String
  #               property :body,    Text
  #               is :markup, :title => :textile, :body => :markdown
  #             end 
  #           }.should_not raise_error(ArgumentError)
  #         end
  #         
  #         it "should NOT raise an ArgumentError when passing existent attributes in a Hash as Strings" do 
  #           lambda { 
  #             class ValidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :title,   String
  #               property :body,    Text
  #               is :markup, 'title' => 'textile', 'body' => 'markdown'
  #             end 
  #           }.should_not raise_error(ArgumentError)
  #         end
  #         
  #         it "should NOT raise an ArgumentError when passing existent attributes in a Hash and the renderer with render options" do 
  #           lambda { 
  #             class ValidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :title,   String
  #               property :body,    Text
  #               is :markup, :title => [:textile, :lite_mode], :body => :markdown
  #             end 
  #           }.should_not raise_error(ArgumentError)
  #           lambda { 
  #             class ValidArticle
  #               include DataMapper::Resource
  #               property :id,     Serial
  #               property :title,   String
  #               property :body,    Text
  #               is :markup, :title => [:textile, :lite_mode, :no_span_caps], :body => :markdown
  #             end 
  #           }.should_not raise_error(ArgumentError)
  #         end
  #         
  #       end #/ valid declarations
  #       
  #     end #/ setup configurations
  #     
  #   end #/ is :markup
  #   
  #   
  #   describe "ClassMethods" do 
  #     
  #     describe "#markup_attributes" do 
  #       
  #       it "should add default :textile renderer on single attribute declarations" do 
  #         SingleArticle.markup_attributes.should == { :body => :textile }
  #       end
  #       
  #       it "should add default :textile renderer on double attribute declarations" do 
  #         DoubleArticle.markup_attributes.should == { :title => :textile, :body => :textile }
  #       end
  #       
  #       it "should add the configuration on Hash declarations" do 
  #         DiffArticle.markup_attributes.should == { :title => :textile, :body => :markdown }
  #       end
  #       
  #       it "should add the configuration on Hash declarations" do 
  #         class ValidArticle
  #           include DataMapper::Resource
  #           property :id,     Serial
  #           property :title,   String
  #           property :body,    Text
  #           is :markup, :title => [:textile, :lite_mode], :body => :markdown
  #         end 
  #         
  #         ValidArticle.markup_attributes.should == { :title => [:textile, :lite_mode], :body => :markdown }
  #       end
  #       
  #     end #/ #markup_attributes
  #     
  #     describe "#markup_handle_unicode" do 
  #       
  #       it "should return boolean value of true" do 
  #         SingleArticle.markup_handle_unicode.should == true
  #       end
  #       
  #     end #/ #markup_handle_unicode
  #     
  #     
  #   end #/ ClassMethods
  #   
  #   
  #   describe "InstanceMethods" do 
  #     
  #     describe "#markedup?" do 
  #       
  #       it "should respond to :markedup?" do 
  #         SingleArticle.first.should respond_to(:markedup?)
  #         SingleArticle.first.markedup?.should == true
  #       end
  #       
  #     end #/ #markedup?
  #     
  #     
  #   end #/ InstanceMethods
  #   
  #   
  #   describe "Workflow" do 
  #     
  #     
  #   end #/ Workflow
  #   
  end
end
