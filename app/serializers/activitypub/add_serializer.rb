# frozen_string_literal: true

class ActivityPub::AddSerializer < ActivityPub::Serializer
  class UriSerializer < ActiveModel::Serializer
    include RoutingHelper

    def serializable_hash(*_args)
      ActivityPub::TagManager.instance.uri_for(object)
    end
  end

  def self.serializer_for(model, options)
    case model.class.name
    when 'Status'
      UriSerializer
    when 'FeaturedTag'
      ActivityPub::HashtagSerializer
    else
      super
    end
  end

  include RoutingHelper

  attributes :type, :actor, :target
  has_one :proper_object, key: :object

  def type
    'Add'
  end

  def actor
    ActivityPub::TagManager.instance.uri_for(object.account)
  end

  def proper_object
    object
  end

  def target
    ActivityPub::TagManager.instance.collection_uri_for(object.account, :featured)
  end
end
