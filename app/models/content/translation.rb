class Content::Translation < ActiveRecord::Base
    extend Content
    extend Batchelor
    

    self.table_name = 'translation'
    self.primary_keys = :ayah_key, :resource_id # composite primary key which is a combination of ayah_key & resource_id

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'

#    mapping :_parent => { :type => 'ayah' }, :_routing => { :path => 'ayah_key', :required => true } do
#      indexes :resource_id, type: "integer"
#      indexes :ayah_key
#      indexes :text, term_vector: "with_positions_offsets_payloads"
#    end

    def self.import(options = {})
        transform = lambda do |a|
            {index: {_id: "#{a.resource_id},#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json}} 
        end
        options = {transform: transform}.merge(options)
        self.importing options 
    end



    # def as_indexed_json(options={})
    #     self.as_json(
        
    #         # methods: [:resource_info],
    #         include: {
    #             resource: {
    #                 only: [:slug, :name, :type]
    #             }
    #         }

    #     )
    # end


end
# notes:
# - provides a 'text' column
# transform = lambda do |a|
#    {index: {_id: a.id, _parent: a.author_id, data: a.__elasticsearch__.as_indexed_json}}
# end


